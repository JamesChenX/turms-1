/*
 * Copyright (C) 2019 The Turms Project
 * https://github.com/turms-im/turms
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package im.turms.server.common.access.admin.api;

import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.RecordComponent;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import jakarta.annotation.Nullable;

import com.fasterxml.jackson.databind.JavaType;
import io.netty.buffer.ByteBufInputStream;
import io.netty.buffer.CompositeByteBuf;
import io.netty.buffer.Unpooled;
import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpResponseStatus;
import reactor.core.publisher.Mono;
import reactor.netty.http.server.HttpServerRequest;

import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.infra.io.FileHolder;
import im.turms.server.common.infra.json.JsonCodecPool;
import im.turms.server.common.infra.lang.StringUtil;
import im.turms.server.common.infra.netty.ReferenceCountUtil;

/**
 * @author James Chen
 */
public class ApiRequestParamParser {

    private static final Mono<Object[]> BODY_IS_REQUIRED = Mono.error(new HttpResponseException(
            HttpHandlerResult.create(HttpResponseStatus.BAD_REQUEST,
                    new ResponseDTO<>(
                            ResponseStatusCode.ILLEGAL_ARGUMENT,
                            "The request body is required"))));
    private static final HttpResponseException FORM_DATA_IS_REQUIRED = new HttpResponseException(
            HttpHandlerResult.create(HttpResponseStatus.BAD_REQUEST,
                    new ResponseDTO<>(
                            ResponseStatusCode.ILLEGAL_ARGUMENT,
                            "The form data is required")));
    private final HttpResponseException bodyTooLargeException;

    private final int maxBodySize;

    public ApiRequestParamParser(int maxBodySize) {
        this.maxBodySize = maxBodySize;
        bodyTooLargeException = new HttpResponseException(
                HttpHandlerResult.create(HttpResponseStatus.REQUEST_ENTITY_TOO_LARGE,
                        new ResponseDTO<>(
                                ResponseStatusCode.ILLEGAL_ARGUMENT,
                                "The request body size must not exceed "
                                        + maxBodySize
                                        + " bytes")));
    }

    public Mono<ApiEndpointArguments> parse(
            HttpServerRequest request,
            RequestContext requestContext,
            ApiEndpointParameter[] parameters) {
        int length = parameters.length;
        Object[] args = new Object[length];
        ApiEndpointParameter requestJson = null;
        ApiEndpointParameter requestBinary = null;
        int bodyIndex = -1;
        int formDataIndex = -1;
        for (int i = 0; i < length; i++) {
            ApiEndpointParameter parameter = parameters[i];
            switch (parameter.type()) {
                case REQUEST_BODY_JSON -> {
                    requestJson = parameter;
                    bodyIndex = i;
                }
                case REQUEST_BODY_BINARY -> {
                    requestBinary = parameter;
                    formDataIndex = i;
                }
                case REQUEST_CONTEXT -> args[i] = requestContext;
            }
        }
        if (requestJson == null && requestBinary == null) {
            return Mono.just(new ApiEndpointArguments(args, Collections.emptyList()));
        }
        if (requestJson != null) {
            int finalBodyIndex = bodyIndex;
            Mono<Object> parseBody = parseBody(request, requestJson.typeForJackson())
                    .doOnNext(body -> args[finalBodyIndex] = body);
            if (requestJson.isRequired()) {
                parseBody = parseBody.switchIfEmpty(BODY_IS_REQUIRED);
            }
            return parseBody
                    // Used to ensure returning arguments because parseBody() may return MonoEmpty
                    .thenReturn(new ApiEndpointArguments(args, Collections.emptyList()));
        }
        int finalFormDataIndex = formDataIndex;
        Mono<List<FileHolder>> parseFormData = parseFormData(request);
        Mono<ApiEndpointArguments> collectionMono;
        if (requestBinary.isRequired()) {
            collectionMono = parseFormData.map(files -> {
                if (files.isEmpty()) {
                    throw FORM_DATA_IS_REQUIRED;
                }
                args[finalFormDataIndex] = files;
                return new ApiEndpointArguments(args, files);
            });
        } else {
            collectionMono = parseFormData.map(files -> {
                args[finalFormDataIndex] = files;
                return new ApiEndpointArguments(args, files);
            });
        }
        return collectionMono;
    }

    private Mono<Object> parseBody(HttpServerRequest request, @Nullable JavaType parameterType) {
        return Mono.defer(() -> {
            CompositeByteBuf body = Unpooled.compositeBuffer();
            return request.receive()
                    // We don't use "collectList()" because we need to reject
                    // to receive buffers if it has exceeded the max size.
                    .doOnNext(buffer -> {
                        body.addComponent(true, buffer);
                        if (body.readableBytes() > maxBodySize) {
                            body.release();
                            throw bodyTooLargeException;
                        }
                        buffer.retain();
                    })
                    .then(Mono.defer(() -> {
                        int length = body.readableBytes();
                        if (length == 0) {
                            return Mono.empty();
                        }
                        Charset charset = findCharset(request);
                        try (ByteBufInputStream stream = new ByteBufInputStream(body, length, true);
                                InputStreamReader reader = new InputStreamReader(stream, charset)) {
                            Object value = JsonCodecPool.MAPPER.readValue(reader, parameterType);
                            validateRequest(value);
                            return Mono.just(value);
                        } catch (Exception e) {
                            HttpHandlerResult<ResponseDTO<?>> result =
                                    HttpHandlerResult.badRequest("Illegal request body: "
                                            + e.getMessage());
                            return Mono.error(new HttpResponseException(result, e));
                        }
                    }))
                    .doFinally(signalType -> ReferenceCountUtil.safeEnsureReleased(body));
        });
    }

    private Charset findCharset(HttpServerRequest request) {
        String contentType = request.requestHeaders()
                .get(HttpHeaderNames.CONTENT_TYPE);
        if (contentType == null) {
            return StandardCharsets.UTF_8;
        }
        int length = contentType.length();
        if (length == 0) {
            return StandardCharsets.UTF_8;
        }
        int charsetKeyIndex = contentType.indexOf("charset=");
        if (charsetKeyIndex == -1) {
            return StandardCharsets.UTF_8;
        }
        if (charsetKeyIndex + 8 >= length) {
            return StandardCharsets.UTF_8;
        }
        String charset = contentType.substring(charsetKeyIndex + 8)
                .trim();
        try {
            return charset.startsWith("\"") && charset.endsWith("\"")
                    ? Charset.forName(charset.substring(1, charset.length() - 1))
                    : Charset.forName(charset);
        } catch (Exception e) {
            return StandardCharsets.UTF_8;
        }
    }

    private static void validateRequest(Object value) {
        Class<?> requestClass = value.getClass();
        for (RecordComponent component : requestClass.getRecordComponents()) {
            try {
                Object componentValue = component.getAccessor()
                        .invoke(value);
                if (componentValue instanceof Collection<?> collection) {
                    for (Object val : collection) {
                        if (val == null) {
                            throw new IllegalArgumentException(
                                    "The request contains a null value in the parameter: \""
                                            + component.getName()
                                            + "\"");
                        }
                    }
                }
            } catch (Exception e) {
                throw new RuntimeException("Failed to validate the request", e);
            }
        }
    }

    private Mono<List<FileHolder>> parseFormData(HttpServerRequest request) {
        return request.receiveForm(builder -> builder
                // store on disk
                .maxInMemorySize(0)
                .maxSize(maxBodySize))
                .map(data -> {
                    File file;
                    try {
                        file = data.getFile();
                    } catch (IOException e) {
                        // Should never happen because the data should be a file
                        // (DiskAttribute or DiskFileUpload)
                        throw new IllegalArgumentException(
                                "Failed to get the file from the HTTP data: "
                                        + data,
                                e);
                    }
                    data.retain();
                    String name = data.getName();
                    String basename = StringUtil.substringToLastDelimiter(name, '.');
                    return new FileHolder(data, name, basename, file);
                })
                .collectList();
    }

}