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
import java.util.Set;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.Request;
import im.turms.server.common.access.admin.api.annotation.DeleteMapping;
import im.turms.server.common.access.admin.api.annotation.GetMapping;
import im.turms.server.common.access.admin.api.annotation.PutMapping;
import im.turms.server.common.access.admin.api.annotation.QueryParam;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.api.response.PaginationDTO;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.access.admin.permission.RequiredPermission;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.group.access.admin.dto.request.AddGroupTypeDTO;
import im.turms.service.domain.group.access.admin.dto.request.UpdateGroupTypeDTO;
import im.turms.service.domain.group.po.GroupType;
import im.turms.service.domain.group.service.GroupTypeService;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_GROUP_TYPE)
public class GroupTypeController extends BaseController {

    private final GroupTypeService groupTypeService;

    public GroupTypeController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            GroupTypeService groupTypeService) {
        super(context, propertiesManager);
        this.groupTypeService = groupTypeService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.CREATE,
            requiredPermissions = AdminPermission.GROUP_TYPE_CREATE)
    public Mono<ResponseDTO<GroupType>> addGroupType(@Request AddGroupTypeDTO addGroupTypeDTO) {
        Mono<GroupType> addedGroupType = groupTypeService.addGroupType(null,
                addGroupTypeDTO.name(),
                addGroupTypeDTO.groupSizeLimit(),
                addGroupTypeDTO.invitationStrategy(),
                addGroupTypeDTO.joinStrategy(),
                addGroupTypeDTO.groupInfoUpdateStrategy(),
                addGroupTypeDTO.memberInfoUpdateStrategy(),
                addGroupTypeDTO.guestSpeakable(),
                addGroupTypeDTO.selfInfoUpdatable(),
                addGroupTypeDTO.enableReadReceipt(),
                addGroupTypeDTO.messageEditable());
        return HttpHandlerResult.okIfTruthy(addedGroupType);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.GROUP_TYPE_QUERY)
    public Mono<ResponseDTO<Collection<GroupType>>> queryGroupTypes(
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<GroupType> groupTypesFlux = groupTypeService.queryGroupTypes(0, size);
        return HttpHandlerResult.okIfTruthy(groupTypesFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(AdminPermission.GROUP_TYPE_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<GroupType>>>> queryGroupTypes(
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = groupTypeService.countGroupTypes();
//        Flux<GroupType> groupTypesFlux = groupTypeService.queryGroupTypes(page, size);
//        return HttpHandlerResult.page(count, groupTypesFlux);
//    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = AdminPermission.GROUP_TYPE_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateGroupType(
            Set<Long> ids,
            @Request UpdateGroupTypeDTO updateGroupTypeDTO) {
        Mono<UpdateResultDTO> updateMono = groupTypeService
                .updateGroupTypes(ids,
                        updateGroupTypeDTO.name(),
                        updateGroupTypeDTO.groupSizeLimit(),
                        updateGroupTypeDTO.invitationStrategy(),
                        updateGroupTypeDTO.joinStrategy(),
                        updateGroupTypeDTO.groupInfoUpdateStrategy(),
                        updateGroupTypeDTO.memberInfoUpdateStrategy(),
                        updateGroupTypeDTO.guestSpeakable(),
                        updateGroupTypeDTO.selfInfoUpdatable(),
                        updateGroupTypeDTO.enableReadReceipt(),
                        updateGroupTypeDTO.messageEditable())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = AdminPermission.GROUP_TYPE_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteGroupType(Set<Long> ids) {
        Mono<DeleteResultDTO> deleteMono = groupTypeService.deleteGroupTypes(ids)
                .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

}