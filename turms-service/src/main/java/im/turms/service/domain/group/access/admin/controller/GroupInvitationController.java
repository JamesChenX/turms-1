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
import java.util.Date;
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
import im.turms.server.common.access.admin.permission.RequiredPermission;
import im.turms.server.common.access.client.dto.constant.RequestStatus;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.time.DateRange;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.group.access.admin.dto.request.AddGroupInvitationDTO;
import im.turms.service.domain.group.access.admin.dto.request.UpdateGroupInvitationsRequestDTO;
import im.turms.service.domain.group.access.admin.dto.response.GroupInvitationDTO;
import im.turms.service.domain.group.service.GroupInvitationService;

import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_INVITATION_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_INVITATION_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_INVITATION_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_INVITATION_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_GROUP_INVITATION)
public class GroupInvitationController extends BaseController {

    private final GroupInvitationService groupInvitationService;

    public GroupInvitationController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            GroupInvitationService groupInvitationService) {
        super(context, propertiesManager);
        this.groupInvitationService = groupInvitationService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = GROUP_INVITATION_CREATE)
    public Mono<ResponseDTO<GroupInvitationDTO>> addGroupInvitation(
            @Request AddGroupInvitationDTO addGroupInvitationDTO) {
        Mono<GroupInvitationDTO> createMono = groupInvitationService
                .createGroupInvitation(addGroupInvitationDTO.id(),
                        addGroupInvitationDTO.groupId(),
                        addGroupInvitationDTO.inviterId(),
                        addGroupInvitationDTO.inviteeId(),
                        addGroupInvitationDTO.content(),
                        addGroupInvitationDTO.status(),
                        addGroupInvitationDTO.creationDate(),
                        addGroupInvitationDTO.responseDate())
                .map(invitation -> new GroupInvitationDTO(
                        invitation,
                        groupInvitationService.getEntityExpirationDate()));
        return HttpHandlerResult.okIfTruthy(createMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = GROUP_INVITATION_QUERY)
    public Mono<ResponseDTO<Collection<GroupInvitationDTO>>> queryGroupInvitations(
            @QueryParam(required = false) Set<Long> ids,
            @QueryParam(required = false) Set<Long> groupIds,
            @QueryParam(required = false) Set<Long> inviterIds,
            @QueryParam(required = false) Set<Long> inviteeIds,
            @QueryParam(required = false) Set<RequestStatus> statuses,
            @QueryParam(required = false) Date creationDateStart,
            @QueryParam(required = false) Date creationDateEnd,
            @QueryParam(required = false) Date responseDateStart,
            @QueryParam(required = false) Date responseDateEnd,
            @QueryParam(required = false) Date expirationDateStart,
            @QueryParam(required = false) Date expirationDateEnd,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<GroupInvitationDTO> invitationFlux = groupInvitationService
                .queryInvitations(ids,
                        groupIds,
                        inviterIds,
                        inviteeIds,
                        statuses,
                        DateRange.of(creationDateStart, creationDateEnd),
                        DateRange.of(responseDateStart, responseDateEnd),
                        DateRange.of(expirationDateStart, expirationDateEnd),
                        0,
                        size)
                .map(invitation -> new GroupInvitationDTO(
                        invitation,
                        groupInvitationService.getEntityExpirationDate()));
        return HttpHandlerResult.okIfTruthy(invitationFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(GROUP_INVITATION_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<GroupInvitationDTO>>>> queryGroupInvitations(
//            @QueryParam(required = false) Set<Long> ids,
//            @QueryParam(required = false) Set<Long> groupIds,
//            @QueryParam(required = false) Set<Long> inviterIds,
//            @QueryParam(required = false) Set<Long> inviteeIds,
//            @QueryParam(required = false) Set<RequestStatus> statuses,
//            @QueryParam(required = false) Date creationDateStart,
//            @QueryParam(required = false) Date creationDateEnd,
//            @QueryParam(required = false) Date responseDateStart,
//            @QueryParam(required = false) Date responseDateEnd,
//            @QueryParam(required = false) Date expirationDateStart,
//            @QueryParam(required = false) Date expirationDateEnd,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = groupInvitationService.countInvitations(ids,
//                groupIds,
//                inviterIds,
//                inviteeIds,
//                statuses,
//                DateRange.of(creationDateStart, creationDateEnd),
//                DateRange.of(responseDateStart, responseDateEnd),
//                DateRange.of(expirationDateStart, expirationDateEnd));
//        Flux<GroupInvitationDTO> invitationFlux = groupInvitationService
//                .queryInvitations(ids,
//                        groupIds,
//                        inviterIds,
//                        inviteeIds,
//                        statuses,
//                        DateRange.of(creationDateStart, creationDateEnd),
//                        DateRange.of(responseDateStart, responseDateEnd),
//                        DateRange.of(expirationDateStart, expirationDateEnd),
//                        page,
//                        size)
//                .map(invitation -> new GroupInvitationDTO(
//                        invitation,
//                        groupInvitationService.getEntityExpirationDate()));
//        return HttpHandlerResult.page(count, invitationFlux);
//    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = GROUP_INVITATION_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateGroupInvitations(
            Set<Long> ids,
            @Request UpdateGroupInvitationsRequestDTO request) {
        Mono<UpdateResultDTO> updateMono = groupInvitationService
                .updateInvitations(ids,
                        request.inviterId(),
                        request.inviteeId(),
                        request.content(),
                        request.status(),
                        request.creationDate(),
                        request.responseDate())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = GROUP_INVITATION_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteGroupInvitations(
            @QueryParam(required = false) Set<Long> ids) {
        Mono<DeleteResultDTO> deleteMono = groupInvitationService.deleteInvitations(ids)
                .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

}