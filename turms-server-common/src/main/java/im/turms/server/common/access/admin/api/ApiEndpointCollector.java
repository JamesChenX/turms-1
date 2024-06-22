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

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.annotation.Nullable;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.HttpMethod;
import org.springframework.context.ConfigurableApplicationContext;

import im.turms.server.common.domain.common.access.dto.BinaryRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestDTO;
import im.turms.server.common.infra.io.BaseFileResource;
import im.turms.server.common.infra.json.JsonUtil;
import im.turms.server.common.infra.lang.StringUtil;
import im.turms.server.common.infra.openapi.OpenApiBuilder;
import im.turms.server.common.infra.reflect.ReflectionUtil;

import static im.turms.server.common.infra.http.MediaTypeConst.APPLICATION_JSON;
import static im.turms.server.common.infra.http.MediaTypeConst.APPLICATION_OCTET_STREAM;
import static im.turms.server.common.infra.http.MediaTypeConst.TEXT_PLAIN_UTF_8;

/**
 * @author James Chen
 */
public class ApiEndpointCollector {

    public Map<ApiEndpointKey, ApiEndpointInfo> collectEndpoints(
            ConfigurableApplicationContext context) {
        Map<ApiEndpointKey, ApiEndpointInfo> keyToEndpoint = new HashMap<>(64);
        Map<String, BaseApiController> nameToController =
                context.getBeansOfType(BaseApiController.class);
        nameToController.forEach((name, controller) -> collectEndpoints(keyToEndpoint, controller));
        return Map.copyOf(keyToEndpoint);
    }

    public void collectEndpoints(
            Map<ApiEndpointKey, ApiEndpointInfo> keyToEndpoint,
            List<BaseApiController> controllers) {
        for (BaseApiController controller : controllers) {
            collectEndpoints(keyToEndpoint, controller);
        }
    }

    private void collectEndpoints(
            Map<ApiEndpointKey, ApiEndpointInfo> keyToEndpoint,
            BaseApiController controller) {
        Class<?> controllerClass = controller.getClass();
        ApiController annotation = controllerClass.getDeclaredAnnotation(ApiController.class);
        if (annotation == null) {
            throw new IllegalArgumentException(
                    "@"
                            + ApiController.class.getSimpleName()
                            + " must be present in the controller class: "
                            + controllerClass.getName());
        }
        String basePath = annotation.value();
        if (!StringUtil.startsWithLetter(basePath)) {
            throw new IllegalArgumentException(
                    "The path must start with a letter. Actual: \""
                            + basePath
                            + "\"");
        }
        Method[] methods = controllerClass.getDeclaredMethods();
        List<HttpMethod> generatedEndpointMethods =
                List.of(HttpMethod.DELETE, HttpMethod.GET, HttpMethod.POST, HttpMethod.PUT);
        for (Method method : methods) {
            ReflectionUtil.setAccessible(method);
            ApiEndpoint apiEndpoint = method.getDeclaredAnnotation(ApiEndpoint.class);
            if (apiEndpoint == null) {
                continue;
            }
            String subpath = apiEndpoint.value();
            if (StringUtil.isBlank(subpath)) {
                throw new IllegalArgumentException(
                        "The subpath of "
                                + apiEndpoint.getClass()
                                        .getName()
                                + " must not be blank");
            }
            if (!StringUtil.startsWithLetter(subpath)) {
                throw new IllegalArgumentException(
                        "The subpath must start with a letter. Actual: \""
                                + subpath
                                + "\"");
            }
            String path = "/"
                    + basePath
                    + "/"
                    + subpath;
            for (HttpMethod endpointMethod : generatedEndpointMethods) {
                ApiEndpointInfo endpoint = new ApiEndpointInfo(
                        controller,
                        endpointMethod,
                        path,
                        method,
                        parseParameters(method),
                        findMediaType(method),
                        null,
                        apiEndpoint.requiredPermissions());
                ApiEndpointKey key = new ApiEndpointKey(path, endpointMethod);
                if (keyToEndpoint.putIfAbsent(key, endpoint) != null) {
                    throw new IllegalArgumentException(
                            "Found a duplicate endpoint ("
                                    + key
                                    + ")"
                                    + " in the controller: "
                                    + controllerClass.getName());
                }
            }
        }
    }

    private String findMediaType(Method method) {
        Type type = OpenApiBuilder.unwrapType(method.getGenericReturnType());
        if (!(type instanceof Class<?> returnValueClass)) {
            return APPLICATION_JSON;
        }
        ApiEndpoint endpoint = method.getDeclaredAnnotation(ApiEndpoint.class);
        if (endpoint != null
                && !endpoint.produces()
                        .isBlank()) {
            return endpoint.produces();
        }
        if (ByteBuf.class.isAssignableFrom(returnValueClass)
                || BaseFileResource.class.isAssignableFrom(returnValueClass)) {
            return APPLICATION_OCTET_STREAM;
        } else if (CharSequence.class.isAssignableFrom(returnValueClass)) {
            return TEXT_PLAIN_UTF_8;
        }
        return APPLICATION_JSON;
    }

    private ApiEndpointParameter[] parseParameters(Method method) {
        Parameter[] parameters = method.getParameters();
        int paramCount = parameters.length;
        ApiEndpointParameter[] endpointParams = new ApiEndpointParameter[paramCount];
        boolean hasRequestParam = false;
        for (int i = 0; i < paramCount; i++) {
            Parameter parameter = parameters[i];
            ApiEndpointParameter info = parseAsRequestBody(parameter);
            if (info != null) {
                if (hasRequestParam) {
                    throw new IllegalArgumentException(
                            "Only one parameter can be annotated with "
                                    + Request.class.getSimpleName());
                }
                endpointParams[i] = info;
                hasRequestParam = true;
                continue;
            }
            if (RequestContext.class.isAssignableFrom(parameter.getType())) {
                endpointParams[i] = new ApiEndpointParameter(
                        parameter.getName(),
                        RequestContext.class,
                        null,
                        false,
                        ApiEndpointParameterType.REQUEST_CONTEXT,
                        null,
                        null,
                        false);
                continue;
            }
            throw new IllegalArgumentException(
                    "Unsupported parameter type: "
                            + parameter.getType()
                                    .getName());
        }
        return endpointParams;
    }

    @Nullable
    private ApiEndpointParameter parseAsRequestBody(Parameter parameter) {
        Request request = parameter.getDeclaredAnnotation(Request.class);
        if (request == null) {
            return null;
        }
        Class<?> type = parameter.getType();
        if (!RequestDTO.class.isAssignableFrom(type)) {
            throw new IllegalArgumentException(
                    "The type of the request parameter must be "
                            + RequestDTO.class.getName()
                            + ". Actual: "
                            + type.getName());
        }
        String contentType = request.contentType();
        return new ApiEndpointParameter(
                parameter.getName(),
                type,
                JsonUtil.constructJavaType(type),
                request.required(),
                BinaryRequestDTO.class.isAssignableFrom(type)
                        ? ApiEndpointParameterType.REQUEST_BODY_BINARY
                        : ApiEndpointParameterType.REQUEST_BODY_JSON,
                null,
                contentType.isBlank()
                        ? null
                        : contentType,
                true);
    }

}