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

package im.turms.service.domain.blocklist.access.admin.controller;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Set;

import org.springframework.context.ApplicationContext;
import org.springframework.util.CollectionUtils;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.Request;
import im.turms.server.common.access.admin.api.annotation.DeleteMapping;
import im.turms.server.common.access.admin.api.annotation.GetMapping;
import im.turms.server.common.access.admin.api.annotation.QueryParam;
import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.api.response.PaginationDTO;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.permission.RequiredPermission;
import im.turms.server.common.domain.blocklist.bo.BlockedClient;
import im.turms.server.common.domain.blocklist.service.BlocklistService;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.blocklist.access.admin.dto.request.AddBlockedUserIdsDTO;
import im.turms.service.domain.blocklist.access.admin.dto.response.BlockedUserDTO;
import im.turms.service.domain.common.access.admin.controller.BaseController;

import static im.turms.server.common.access.admin.permission.AdminPermission.CLIENT_BLOCKLIST_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLIENT_BLOCKLIST_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLIENT_BLOCKLIST_QUERY;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_BLOCKED_CLIENT_USER)
public class UserBlocklistController extends BaseController {

    private final BlocklistService blocklistService;

    public UserBlocklistController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            BlocklistService blocklistService) {
        super(context, propertiesManager);
        this.blocklistService = blocklistService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = CLIENT_BLOCKLIST_CREATE)
    public Mono<ResponseDTO<Void>> addBlockedUserIds(
            @Request AddBlockedUserIdsDTO addBlockedUserIdsDTO) {
        Mono<Void> result = blocklistService.blockUserIds(addBlockedUserIdsDTO.ids(),
                addBlockedUserIdsDTO.blockDurationSeconds());
        return HttpHandlerResult.okIfTruthy(result);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = CLIENT_BLOCKLIST_QUERY)
    public ResponseDTO<Collection<BlockedUserDTO>> queryBlockedUsers(Set<Long> ids) {
        List<BlockedClient<Long>> blockedUsers = blocklistService.getBlockedUsers(ids);
        return HttpHandlerResult.okIfTruthy(clients2users(blockedUsers));
    }

//    @GetMapping("page")
//    @RequiredPermission(CLIENT_BLOCKLIST_QUERY)
//    public HttpHandlerResult<ResponseDTO<PaginationDTO<BlockedUserDTO>>> queryBlockedUsers(
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        int blockUserCount = blocklistService.countBlockUsers();
//        List<BlockedClient<Long>> blockedUsers = blocklistService.getBlockedUsers(page, size);
//        return HttpHandlerResult.page(blockUserCount, clients2users(blockedUsers));
//    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = CLIENT_BLOCKLIST_DELETE)
    public Mono<ResponseDTO<Void>> deleteBlockedUserIds(
            @QueryParam(required = false) Set<Long> ids,
            boolean deleteAll) {
        Mono<Void> result = Mono.empty();
        if (deleteAll) {
            result = blocklistService.unblockAllUserIds();
        } else if (!CollectionUtils.isEmpty(ids)) {
            result = result.then(blocklistService.unblockUserIds(ids));
        }
        return HttpHandlerResult.okIfTruthy(result);
    }

    private List<BlockedUserDTO> clients2users(Collection<BlockedClient<Long>> blockedClients) {
        List<BlockedUserDTO> items = new ArrayList<>(blockedClients.size());
        for (BlockedClient<Long> blockedClient : blockedClients) {
            items.add(new BlockedUserDTO(
                    blockedClient.id(),
                    new Date(blockedClient.blockEndTimeMillis())));
        }
        return items;
    }

}