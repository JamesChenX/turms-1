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

package im.turms.gateway.domain.session.access.admin.controller;

import java.util.List;
import java.util.Set;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Mono;

import im.turms.gateway.domain.session.access.admin.dto.request.DeleteSessionsRequestDTO;
import im.turms.gateway.domain.session.service.SessionService;
import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.session.bo.CloseReason;
import im.turms.server.common.domain.session.bo.SessionCloseStatus;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.net.InetAddressUtil;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_GATEWAY_SESSION)
public class SessionController extends BaseApiController {

    private static final CloseReason DISCONNECTED_BY_ADMIN =
            CloseReason.get(SessionCloseStatus.DISCONNECTED_BY_ADMIN);

    private final SessionService sessionService;

    public SessionController(ApplicationContext context, SessionService sessionService) {
        super(context);
        this.sessionService = sessionService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = AdminPermission.SESSION_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteSessions(DeleteSessionsRequestDTO request) {
        Mono<Integer> mono;
        if (request.hasFilter()) {
            DeleteSessionsRequestDTO.FilterDTO filter = request.filter();
            Set<Long> userIds = filter.userIds();
            Set<String> ips = filter.ips();
            if (userIds == null) {
                if (ips == null) {
                    if (request.deleteAll()) {
                        mono = sessionService.closeAllLocalSessions(DISCONNECTED_BY_ADMIN);
                    } else {
                        mono = ApiConst.ERROR_ILLEGAL_DELETE_ALL_REQUEST;
                    }
                } else if (ips.isEmpty()) {
                    return ResponseDTO.deleteResult0Mono();
                } else {
                    List<byte[]> ipList =
                            CollectionUtil.transformAsList(ips, InetAddressUtil::ipStringToBytes);
                    mono = sessionService.closeLocalSessions(ipList, DISCONNECTED_BY_ADMIN);
                }
            } else if (userIds.isEmpty()) {
                return ResponseDTO.deleteResult0Mono();
            } else {
                if (ips == null) {
                    mono = sessionService.closeLocalSessions(userIds, DISCONNECTED_BY_ADMIN);
                } else if (ips.isEmpty()) {
                    return ResponseDTO.deleteResult0Mono();
                } else {
                    return Mono.error(ResponseException.get(ResponseStatusCode.NOT_IMPLEMENTED,
                            "Close sessions by user IDs and IPs at the same time are not supported currently"));
                }
            }
        } else if (request.deleteAll()) {
            mono = sessionService.closeAllLocalSessions(DISCONNECTED_BY_ADMIN);
        } else {
            mono = ApiConst.ERROR_ILLEGAL_DELETE_ALL_REQUEST;
        }
        return ResponseDTO.deleteResultMono(mono);
    }

}