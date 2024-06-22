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

package im.turms.service.domain.group.access.admin.controller;

import java.util.Collection;
import java.util.List;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.Request;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.time.DateRange;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.group.access.admin.dto.request.AddGroupBlockedUserDTO;
import im.turms.service.domain.group.access.admin.dto.request.QueryGroupBlockedUsersRequestDTO;
import im.turms.service.domain.group.access.admin.dto.request.UpdateGroupBlockedUsersRequestDTO;
import im.turms.service.domain.group.po.GroupBlockedUser;
import im.turms.service.domain.group.service.GroupBlocklistService;

import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_BLOCKLIST_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_BLOCKLIST_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_BLOCKLIST_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_BLOCKLIST_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_GROUP_BLOCKED_USER)
public class GroupBlocklistController extends BaseController {

    private final GroupBlocklistService groupBlocklistService;

    public GroupBlocklistController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            GroupBlocklistService groupBlocklistService) {
        super(context, propertiesManager);
        this.groupBlocklistService = groupBlocklistService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = GROUP_BLOCKLIST_CREATE)
    public Mono<ResponseDTO<GroupBlockedUser>> addGroupBlockedUser(
            @Request AddGroupBlockedUserDTO addGroupBlockedUserDTO) {
        Mono<GroupBlockedUser> createMono =
                groupBlocklistService.addBlockedUser(addGroupBlockedUserDTO.groupId(),
                        addGroupBlockedUserDTO.userId(),
                        addGroupBlockedUserDTO.requesterId(),
                        addGroupBlockedUserDTO.blockDate());
        return HttpHandlerResult.okIfTruthy(createMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = GROUP_BLOCKLIST_QUERY)
    public Mono<ResponseDTO<Collection<GroupBlockedUser>>> queryGroupBlockedUsers(
            QueryGroupBlockedUsersRequestDTO request) {
        size = getLimit(size);
        Flux<GroupBlockedUser> userFlux = groupBlocklistService.queryBlockedUsers(groupIds,
                userIds,
                DateRange.of(blockDateStart, blockDateEnd),
                requesterIds,
                0,
                size);
        return HttpHandlerResult.okIfTruthy(userFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(GROUP_BLOCKLIST_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<GroupBlockedUser>>>> queryGroupBlockedUsers(
//            @QueryParam(required = false) Set<Long> groupIds,
//            @QueryParam(required = false) Set<Long> userIds,
//            @QueryParam(required = false) Date blockDateStart,
//            @QueryParam(required = false) Date blockDateEnd,
//            @QueryParam(required = false) Set<Long> requesterIds,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = groupBlocklistService.countBlockedUsers(groupIds,
//                userIds,
//                DateRange.of(blockDateStart, blockDateEnd),
//                requesterIds);
//        Flux<GroupBlockedUser> userFlux = groupBlocklistService.queryBlockedUsers(groupIds,
//                userIds,
//                DateRange.of(blockDateStart, blockDateEnd),
//                requesterIds,
//                page,
//                size);
//        return HttpHandlerResult.page(count, userFlux);
//    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = GROUP_BLOCKLIST_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateGroupBlockedUsers(
            List<GroupBlockedUser.Key> keys,
            @Request UpdateGroupBlockedUsersRequestDTO request) {
        Mono<UpdateResultDTO> updateMono = groupBlocklistService
                .updateBlockedUsers(CollectionUtil.newSet(keys),
                        request.blockDate(),
                        request.requesterId())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = GROUP_BLOCKLIST_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteGroupBlockedUsers(
            List<GroupBlockedUser.Key> keys) {
        Mono<DeleteResultDTO> deleteMono =
                groupBlocklistService.deleteBlockedUsers(CollectionUtil.newSet(keys))
                        .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

}