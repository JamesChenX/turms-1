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
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import com.mongodb.client.result.UpdateResult;
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
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.time.DateRange;
import im.turms.server.common.infra.time.DivideBy;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.group.access.admin.dto.request.AddGroupDTO;
import im.turms.service.domain.group.access.admin.dto.request.UpdateGroupDTO;
import im.turms.service.domain.group.access.admin.dto.response.GroupStatisticsDTO;
import im.turms.service.domain.group.po.Group;
import im.turms.service.domain.group.service.GroupService;
import im.turms.service.domain.message.service.MessageService;

import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.GROUP_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_GROUP)
public class GroupController extends BaseController {

    private final GroupService groupService;
    private final MessageService messageService;

    public GroupController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            GroupService groupService,
            MessageService messageService) {
        super(context, propertiesManager);
        this.groupService = groupService;
        this.messageService = messageService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = GROUP_CREATE)
    public Mono<ResponseDTO<Group>> addGroup(@Request AddGroupDTO addGroupDTO) {
        Long ownerId = addGroupDTO.ownerId();
        Mono<Group> createdGroup = groupService.authAndCreateGroup(addGroupDTO.creatorId(),
                ownerId == null
                        ? addGroupDTO.creatorId()
                        : ownerId,
                addGroupDTO.name(),
                addGroupDTO.intro(),
                addGroupDTO.announcement(),
                addGroupDTO.minimumScore(),
                addGroupDTO.typeId(),
                addGroupDTO.creationDate(),
                addGroupDTO.deletionDate(),
                addGroupDTO.muteEndDate(),
                addGroupDTO.isActive());
        return HttpHandlerResult.okIfTruthy(createdGroup);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = GROUP_QUERY)
    public Mono<ResponseDTO<Collection<Group>>> queryGroups(
            @QueryParam(required = false) Set<Long> ids,
            @QueryParam(required = false) Set<Long> typeIds,
            @QueryParam(required = false) Set<Long> creatorIds,
            @QueryParam(required = false) Set<Long> ownerIds,
            @QueryParam(required = false) Boolean isActive,
            @QueryParam(required = false) Date creationDateStart,
            @QueryParam(required = false) Date creationDateEnd,
            @QueryParam(required = false) Date deletionDateStart,
            @QueryParam(required = false) Date deletionDateEnd,
            @QueryParam(required = false) Date lastUpdatedDateStart,
            @QueryParam(required = false) Date lastUpdatedDateEnd,
            @QueryParam(required = false) Date muteEndDateStart,
            @QueryParam(required = false) Date muteEndDateEnd,
            @QueryParam(required = false) Set<Long> memberIds,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<Group> groupsFlux = groupService.queryGroups(ids,
                typeIds,
                creatorIds,
                ownerIds,
                isActive,
                DateRange.of(creationDateStart, creationDateEnd),
                DateRange.of(deletionDateStart, deletionDateEnd),
                DateRange.of(lastUpdatedDateStart, lastUpdatedDateEnd),
                DateRange.of(muteEndDateStart, muteEndDateEnd),
                memberIds,
                0,
                size);
        return HttpHandlerResult.okIfTruthy(groupsFlux);
    }
//
//    @GetMapping("page")
//    @RequiredPermission(GROUP_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<Group>>>> queryGroups(
//            @QueryParam(required = false) Set<Long> ids,
//            @QueryParam(required = false) Set<Long> typeIds,
//            @QueryParam(required = false) Set<Long> creatorIds,
//            @QueryParam(required = false) Set<Long> ownerIds,
//            @QueryParam(required = false) Boolean isActive,
//            @QueryParam(required = false) Date creationDateStart,
//            @QueryParam(required = false) Date creationDateEnd,
//            @QueryParam(required = false) Date deletionDateStart,
//            @QueryParam(required = false) Date deletionDateEnd,
//            @QueryParam(required = false) Date lastUpdatedDateStart,
//            @QueryParam(required = false) Date lastUpdatedDateEnd,
//            @QueryParam(required = false) Date muteEndDateStart,
//            @QueryParam(required = false) Date muteEndDateEnd,
//            @QueryParam(required = false) Set<Long> memberIds,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        DateRange creationDateRange = DateRange.of(creationDateStart, creationDateEnd);
//        DateRange deletionDateRange = DateRange.of(deletionDateStart, deletionDateEnd);
//        DateRange lastUpdatedDateRange = DateRange.of(lastUpdatedDateStart, lastUpdatedDateEnd);
//        DateRange muteEndDateRange = DateRange.of(muteEndDateStart, muteEndDateEnd);
//        Mono<Long> count = groupService.countGroups(ids,
//                typeIds,
//                creatorIds,
//                ownerIds,
//                isActive,
//                creationDateRange,
//                deletionDateRange,
//                lastUpdatedDateRange,
//                muteEndDateRange,
//                memberIds);
//        Flux<Group> groupsFlux = groupService.queryGroups(ids,
//                typeIds,
//                creatorIds,
//                ownerIds,
//                isActive,
//                creationDateRange,
//                deletionDateRange,
//                lastUpdatedDateRange,
//                muteEndDateRange,
//                memberIds,
//                page,
//                size);
//        return HttpHandlerResult.page(count, groupsFlux);
//    }

    @ApiEndpoint(
            value = "statistic",
            action = ApiEndpointAction.QUERY,
            requiredPermissions = GROUP_QUERY)
    public Mono<ResponseDTO<GroupStatisticsDTO>> countGroups(
            @QueryParam(required = false) Date createdStartDate,
            @QueryParam(required = false) Date createdEndDate,
            @QueryParam(required = false) Date deletedStartDate,
            @QueryParam(required = false) Date deletedEndDate,
            @QueryParam(required = false) Date sentMessageStartDate,
            @QueryParam(required = false) Date sentMessageEndDate,
            @QueryParam(defaultValue = "NOOP") DivideBy divideBy) {
        List<Mono<?>> counts = new LinkedList<>();
        GroupStatisticsDTO.GroupStatisticsDTOBuilder builder = GroupStatisticsDTO.builder();
        if (divideBy == null || divideBy == DivideBy.NOOP) {
            if (deletedStartDate != null || deletedEndDate != null) {
                counts.add(groupService
                        .countDeletedGroups(DateRange.of(deletedStartDate, deletedEndDate))
                        .doOnNext(builder::deletedGroups));
            }
            if (sentMessageStartDate != null || sentMessageEndDate != null) {
                counts.add(messageService
                        .countGroupsThatSentMessages(
                                DateRange.of(sentMessageStartDate, sentMessageEndDate))
                        .doOnNext(builder::groupsThatSentMessages));
            }
            if (counts.isEmpty() || createdStartDate != null || createdEndDate != null) {
                counts.add(groupService
                        .countCreatedGroups(DateRange.of(createdStartDate, createdEndDate))
                        .doOnNext(builder::createdGroups));
            }
        } else {
            if (deletedStartDate != null && deletedEndDate != null) {
                counts.add(checkAndQueryBetweenDate(DateRange.of(deletedStartDate, deletedEndDate),
                        divideBy,
                        groupService::countDeletedGroups).doOnNext(builder::deletedGroupsRecords));
            }
            if (sentMessageStartDate != null && sentMessageEndDate != null) {
                counts.add(checkAndQueryBetweenDate(DateRange.of(sentMessageStartDate,
                        sentMessageEndDate), divideBy, messageService::countGroupsThatSentMessages)
                        .doOnNext(builder::groupsThatSentMessagesRecords));
            }
            if (createdStartDate != null && createdEndDate != null) {
                counts.add(checkAndQueryBetweenDate(DateRange.of(createdStartDate, createdEndDate),
                        divideBy,
                        groupService::countCreatedGroups).doOnNext(builder::createdGroupsRecords));
            }
            if (counts.isEmpty()) {
                return Mono.empty();
            }
        }
        return HttpHandlerResult.okIfTruthy(Mono.when(counts)
                .then(Mono.fromCallable(builder::build)));
    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = GROUP_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateGroups(
            Set<Long> ids,
            @Request UpdateGroupDTO updateGroupDTO) {
        Long successorId = updateGroupDTO.successorId();
        Mono<UpdateResult> updateMono = successorId == null
                ? groupService.updateGroupsInformation(ids,
                        updateGroupDTO.typeId(),
                        updateGroupDTO.creatorId(),
                        updateGroupDTO.ownerId(),
                        updateGroupDTO.name(),
                        updateGroupDTO.intro(),
                        updateGroupDTO.announcement(),
                        updateGroupDTO.minimumScore(),
                        updateGroupDTO.isActive(),
                        updateGroupDTO.creationDate(),
                        updateGroupDTO.deletionDate(),
                        updateGroupDTO.muteEndDate(),
                        null)
                : groupService.checkAndTransferGroupOwnership(ids,
                        successorId,
                        updateGroupDTO.quitAfterTransfer());
        return HttpHandlerResult.updateResult(updateMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = GROUP_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteGroups(
            @QueryParam(required = false) Set<Long> ids,
            @QueryParam(required = false) Boolean deleteLogically) {
        Mono<DeleteResultDTO> deleted =
                groupService.deleteGroupsAndGroupMembers(ids, deleteLogically)
                        .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleted);
    }

}