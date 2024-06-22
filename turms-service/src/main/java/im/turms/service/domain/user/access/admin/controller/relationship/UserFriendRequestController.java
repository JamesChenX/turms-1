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

package im.turms.service.domain.user.access.admin.controller.relationship;

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
import im.turms.service.domain.user.access.admin.dto.request.AddFriendRequestDTO;
import im.turms.service.domain.user.access.admin.dto.request.UpdateFriendRequestsRequestDTO;
import im.turms.service.domain.user.access.admin.dto.response.UserFriendRequestDTO;
import im.turms.service.domain.user.service.UserFriendRequestService;

import static im.turms.server.common.access.admin.permission.AdminPermission.USER_FRIEND_REQUEST_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_FRIEND_REQUEST_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_FRIEND_REQUEST_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_FRIEND_REQUEST_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_USER_FRIEND_REQUEST)
public class UserFriendRequestController extends BaseController {

    private final UserFriendRequestService userFriendRequestService;

    public UserFriendRequestController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            UserFriendRequestService userFriendRequestService) {
        super(context, propertiesManager);
        this.userFriendRequestService = userFriendRequestService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.CREATE,
            requiredPermissions = USER_FRIEND_REQUEST_CREATE)
    public Mono<ResponseDTO<UserFriendRequestDTO>> createFriendRequest(
            @Request AddFriendRequestDTO addFriendRequestDTO) {
        Mono<UserFriendRequestDTO> createMono = userFriendRequestService
                .createFriendRequest(addFriendRequestDTO.id(),
                        addFriendRequestDTO.requesterId(),
                        addFriendRequestDTO.recipientId(),
                        addFriendRequestDTO.content(),
                        addFriendRequestDTO.status(),
                        addFriendRequestDTO.creationDate(),
                        addFriendRequestDTO.responseDate(),
                        addFriendRequestDTO.reason())
                .map(request -> new UserFriendRequestDTO(
                        request,
                        userFriendRequestService.getEntityExpirationDate()));
        return HttpHandlerResult.okIfTruthy(createMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = USER_FRIEND_REQUEST_QUERY)
    public Mono<ResponseDTO<Collection<UserFriendRequestDTO>>> queryFriendRequests(
            @QueryParam(required = false) Set<Long> ids,
            @QueryParam(required = false) Set<Long> requesterIds,
            @QueryParam(required = false) Set<Long> recipientIds,
            @QueryParam(required = false) Set<RequestStatus> statuses,
            @QueryParam(required = false) Date creationDateStart,
            @QueryParam(required = false) Date creationDateEnd,
            @QueryParam(required = false) Date responseDateStart,
            @QueryParam(required = false) Date responseDateEnd,
            @QueryParam(required = false) Date expirationDateStart,
            @QueryParam(required = false) Date expirationDateEnd,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<UserFriendRequestDTO> userFriendRequestFlux = userFriendRequestService
                .queryFriendRequests(ids,
                        requesterIds,
                        recipientIds,
                        statuses,
                        DateRange.of(creationDateStart, creationDateEnd),
                        DateRange.of(responseDateStart, responseDateEnd),
                        DateRange.of(expirationDateStart, expirationDateEnd),
                        0,
                        size)
                .map(request -> new UserFriendRequestDTO(
                        request,
                        userFriendRequestService.getEntityExpirationDate()));
        return HttpHandlerResult.okIfTruthy(userFriendRequestFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(USER_FRIEND_REQUEST_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<UserFriendRequestDTO>>>> queryFriendRequests(
//            @QueryParam(required = false) Set<Long> ids,
//            @QueryParam(required = false) Set<Long> requesterIds,
//            @QueryParam(required = false) Set<Long> recipientIds,
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
//        Mono<Long> count = userFriendRequestService.countFriendRequests(ids,
//                requesterIds,
//                recipientIds,
//                statuses,
//                DateRange.of(creationDateStart, creationDateEnd),
//                DateRange.of(responseDateStart, responseDateEnd),
//                DateRange.of(expirationDateStart, expirationDateEnd));
//        Flux<UserFriendRequestDTO> userFriendRequestFlux = userFriendRequestService
//                .queryFriendRequests(ids,
//                        requesterIds,
//                        recipientIds,
//                        statuses,
//                        DateRange.of(creationDateStart, creationDateEnd),
//                        DateRange.of(responseDateStart, responseDateEnd),
//                        DateRange.of(expirationDateStart, expirationDateEnd),
//                        page,
//                        size)
//                .map(request -> new UserFriendRequestDTO(
//                        request,
//                        userFriendRequestService.getEntityExpirationDate()));
//        return HttpHandlerResult.page(count, userFriendRequestFlux);
//    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = USER_FRIEND_REQUEST_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateFriendRequests(
            Set<Long> ids,
            @Request UpdateFriendRequestsRequestDTO request) {
        Mono<UpdateResultDTO> updateMono = userFriendRequestService
                .updateFriendRequests(ids,
                        request.requesterId(),
                        request.recipientId(),
                        request.content(),
                        request.status(),
                        request.reason(),
                        request.creationDate(),
                        request.responseDate())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = USER_FRIEND_REQUEST_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteFriendRequests(
            @QueryParam(required = false) Set<Long> ids) {
        Mono<DeleteResultDTO> deleteMono = userFriendRequestService.deleteFriendRequests(ids)
                .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

}