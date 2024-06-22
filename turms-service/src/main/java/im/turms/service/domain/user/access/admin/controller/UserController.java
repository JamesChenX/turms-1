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

package im.turms.service.domain.user.access.admin.controller;

import java.util.Collection;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.Request;
import im.turms.server.common.access.admin.api.annotation.AdminApiController;
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
import im.turms.server.common.domain.user.po.User;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.time.DateRange;
import im.turms.server.common.infra.time.DivideBy;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.message.service.MessageService;
import im.turms.service.domain.user.access.admin.dto.request.AddUserDTO;
import im.turms.service.domain.user.access.admin.dto.request.UpdateUserDTO;
import im.turms.service.domain.user.access.admin.dto.response.UserStatisticsDTO;
import im.turms.service.domain.user.service.UserService;

import static im.turms.server.common.access.admin.permission.AdminPermission.USER_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_USER)
public class UserController extends BaseController {

    private final UserService userService;
    private final MessageService messageService;

    public UserController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            UserService userService,
            MessageService messageService) {
        super(context, propertiesManager);
        this.userService = userService;
        this.messageService = messageService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = USER_CREATE)
    public Mono<ResponseDTO<User>> addUser(@Request AddUserDTO addUserDTO) {
        Mono<User> addUser = userService.addUser(addUserDTO.id(),
                addUserDTO.password(),
                addUserDTO.name(),
                addUserDTO.intro(),
                addUserDTO.profilePicture(),
                addUserDTO.profileAccessStrategy(),
                addUserDTO.permissionGroupId(),
                addUserDTO.registrationDate(),
                addUserDTO.isActive());
        return HttpHandlerResult.okIfTruthy(addUser);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = USER_QUERY)
    public Mono<ResponseDTO<Collection<User>>> queryUsers(
            @QueryParam(required = false) Set<Long> ids,
            @QueryParam(required = false) Date registrationDateStart,
            @QueryParam(required = false) Date registrationDateEnd,
            @QueryParam(required = false) Date deletionDateStart,
            @QueryParam(required = false) Date deletionDateEnd,
            @QueryParam(required = false) Boolean isActive,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<User> usersFlux = userService.queryUsers(ids,
                DateRange.of(registrationDateStart, registrationDateEnd),
                DateRange.of(deletionDateStart, deletionDateEnd),
                isActive,
                0,
                size,
                true);
        return HttpHandlerResult.okIfTruthy(usersFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(USER_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<User>>>> queryUsers(
//            @QueryParam(required = false) Set<Long> ids,
//            @QueryParam(required = false) Date registrationDateStart,
//            @QueryParam(required = false) Date registrationDateEnd,
//            @QueryParam(required = false) Date deletionDateStart,
//            @QueryParam(required = false) Date deletionDateEnd,
//            @QueryParam(required = false) Boolean isActive,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = userService.countUsers(ids,
//                DateRange.of(registrationDateStart, registrationDateEnd),
//                DateRange.of(deletionDateStart, deletionDateEnd),
//                isActive);
//        Flux<User> usersFlux = userService.queryUsers(ids,
//                DateRange.of(registrationDateStart, registrationDateEnd),
//                DateRange.of(deletionDateStart, deletionDateEnd),
//                isActive,
//                page,
//                size,
//                true);
//        return HttpHandlerResult.page(count, usersFlux);
//    }

    @ApiEndpoint(
            value = "statistic",
            action = ApiEndpointAction.QUERY,
            requiredPermissions = USER_QUERY)
    public Mono<ResponseDTO<UserStatisticsDTO>> countUsers(
            @QueryParam(required = false) Date registeredStartDate,
            @QueryParam(required = false) Date registeredEndDate,
            @QueryParam(required = false) Date deletedStartDate,
            @QueryParam(required = false) Date deletedEndDate,
            @QueryParam(required = false) Date sentMessageStartDate,
            @QueryParam(required = false) Date sentMessageEndDate,
            @QueryParam(defaultValue = "NOOP") DivideBy divideBy) {
        List<Mono<?>> counts = new LinkedList<>();
        UserStatisticsDTO.UserStatisticsDTOBuilder builder = UserStatisticsDTO.builder();
        if (divideBy == null || divideBy == DivideBy.NOOP) {
            if (deletedStartDate != null || deletedEndDate != null) {
                counts.add(userService
                        .countDeletedUsers(DateRange.of(deletedStartDate, deletedEndDate))
                        .doOnNext(builder::deletedUsers));
            }
            if (sentMessageStartDate != null || sentMessageEndDate != null) {
                counts.add(messageService
                        .countUsersWhoSentMessage(DateRange.of(sentMessageStartDate,
                                sentMessageEndDate), null, false)
                        .doOnNext(builder::usersWhoSentMessages));
            }
            if (counts.isEmpty() || registeredStartDate != null || registeredEndDate != null) {
                counts.add(userService
                        .countRegisteredUsers(DateRange.of(registeredStartDate, registeredEndDate),
                                true)
                        .doOnNext(builder::registeredUsers));
            }
        } else {
            if (deletedStartDate != null && deletedEndDate != null) {
                counts.add(checkAndQueryBetweenDate(DateRange.of(deletedStartDate, deletedEndDate),
                        divideBy,
                        userService::countDeletedUsers).doOnNext(builder::deletedUsersRecords));
            }
            if (sentMessageStartDate != null && sentMessageEndDate != null) {
                counts.add(checkAndQueryBetweenDate(
                        DateRange.of(sentMessageStartDate, sentMessageEndDate),
                        divideBy,
                        messageService::countUsersWhoSentMessage,
                        null,
                        false).doOnNext(builder::usersWhoSentMessagesRecords));
            }
            if (registeredStartDate != null && registeredEndDate != null) {
                counts.add(checkAndQueryBetweenDate(
                        DateRange.of(registeredStartDate, registeredEndDate),
                        divideBy,
                        dateRange -> userService.countRegisteredUsers(dateRange, true))
                        .doOnNext(builder::registeredUsersRecords));
            }
            if (counts.isEmpty()) {
                return Mono.empty();
            }
        }
        return HttpHandlerResult.okIfTruthy(Mono.when(counts)
                .then(Mono.fromCallable(builder::build)));
    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = USER_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateUser(
            Set<Long> ids,
            @Request UpdateUserDTO updateUserDTO) {
        Mono<UpdateResultDTO> updateMono = userService
                .updateUsers(ids,
                        updateUserDTO.password(),
                        updateUserDTO.name(),
                        updateUserDTO.intro(),
                        updateUserDTO.profilePicture(),
                        updateUserDTO.profileAccessStrategy(),
                        updateUserDTO.permissionGroupId(),
                        updateUserDTO.registrationDate(),
                        updateUserDTO.isActive())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = USER_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteUsers(
            Set<Long> ids,
            @QueryParam(required = false) Boolean deleteLogically) {
        Mono<DeleteResultDTO> deleteMono = userService.deleteUsers(ids, deleteLogically)
                .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

}