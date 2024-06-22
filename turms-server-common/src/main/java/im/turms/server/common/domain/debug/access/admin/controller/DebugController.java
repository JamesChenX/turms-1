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

package im.turms.server.common.domain.debug.access.admin.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.debug.access.admin.dto.request.CreateMethodCallsRequestDTO;
import im.turms.server.common.domain.debug.access.admin.dto.response.CreateMethodCallsResponseDTO;
import im.turms.server.common.domain.debug.access.admin.service.DebugService;
import im.turms.server.common.infra.collection.CollectorUtil;
import im.turms.server.common.infra.exception.ThrowableInfo;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_DEBUG)
public class DebugController extends BaseApiController {

    private static final Mono<CreateMethodCallsResponseDTO.MethodCallResult> RESULT_NULL =
            Mono.just(new CreateMethodCallsResponseDTO.MethodCallResult(
                    ResponseStatusCode.OK,
                    null,
                    null));
    private static final Mono<ResponseDTO<CreateMethodCallsResponseDTO>> RESULT_EMPTY =
            Mono.just(ResponseDTO.of(new CreateMethodCallsResponseDTO(Collections.emptyList())));

    private final DebugService debugService;

    public DebugController(ApplicationContext context, DebugService debugService) {
        super(context);
        this.debugService = debugService;
    }

    @ApiEndpoint(value = "method-call", action = ApiEndpointAction.CREATE)
    public Mono<ResponseDTO<CreateMethodCallsResponseDTO>> createMethodCalls(
            @Nullable CreateMethodCallsRequestDTO request) {
        if (request == null) {
            return RESULT_EMPTY;
        }
        List<CreateMethodCallsRequestDTO.NewMethodCall> calls = request.calls();
        int callCount = calls.size();
        List<Mono<CreateMethodCallsResponseDTO.MethodCallResult>> results =
                new ArrayList<>(callCount);
        for (CreateMethodCallsRequestDTO.NewMethodCall call : calls) {
            Mono<CreateMethodCallsResponseDTO.MethodCallResult> resultMono = debugService
                    .callMethod(call.beanName(), call.className(), call.methodName(), call.params())
                    .map(result -> new CreateMethodCallsResponseDTO.MethodCallResult(
                            ResponseStatusCode.OK,
                            result,
                            null))
                    .switchIfEmpty(RESULT_NULL)
                    .onErrorResume(throwable -> {
                        ThrowableInfo throwableInfo = ThrowableInfo.get(throwable);
                        return Mono.just(new CreateMethodCallsResponseDTO.MethodCallResult(
                                throwableInfo.code(),
                                null,
                                throwableInfo.reason()));
                    });
            results.add(resultMono);
        }
        Flux<CreateMethodCallsResponseDTO.MethodCallResult> resultFlux =
                request.executeSequentially()
                        ? Flux.concat(results)
                        : Flux.merge(results);
        return resultFlux.collect(CollectorUtil.toList(callCount))
                .map(resultList -> ResponseDTO.of(new CreateMethodCallsResponseDTO(resultList)));
    }

}