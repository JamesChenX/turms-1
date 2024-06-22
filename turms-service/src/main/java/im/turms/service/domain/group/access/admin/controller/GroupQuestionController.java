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
import im.turms.service.domain.group.access.admin.dto.request.AddGroupJoinQuestionDTO;
import im.turms.service.domain.group.access.admin.dto.request.UpdateGroupJoinQuestionsRequestDTO;
import im.turms.service.domain.group.bo.NewGroupQuestion;
import im.turms.service.domain.group.po.GroupJoinQuestion;
import im.turms.service.domain.group.service.GroupQuestionService;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_GROUP_QUESTION)
public class GroupQuestionController extends BaseController {

    private final GroupQuestionService groupQuestionService;

    public GroupQuestionController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            GroupQuestionService groupQuestionService) {
        super(context, propertiesManager);
        this.groupQuestionService = groupQuestionService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.GROUP_QUESTION_QUERY)
    public Mono<ResponseDTO<Collection<GroupJoinQuestion>>> queryGroupJoinQuestions(
            @QueryParam(required = false) Set<Long> ids,
            @QueryParam(required = false) Set<Long> groupIds,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<GroupJoinQuestion> groupJoinQuestionFlux =
                groupQuestionService.queryGroupJoinQuestions(ids, groupIds, 0, size, true);
        return HttpHandlerResult.okIfTruthy(groupJoinQuestionFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(AdminPermission.GROUP_QUESTION_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<GroupJoinQuestion>>>> queryGroupJoinQuestions(
//            @QueryParam(required = false) Set<Long> ids,
//            @QueryParam(required = false) Set<Long> groupIds,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = groupQuestionService.countGroupJoinQuestions(ids, groupIds);
//        Flux<GroupJoinQuestion> groupJoinQuestionFlux =
//                groupQuestionService.queryGroupJoinQuestions(ids, groupIds, page, size, true);
//        return HttpHandlerResult.page(count, groupJoinQuestionFlux);
//    }

    @ApiEndpoint(
            action = ApiEndpointAction.CREATE,
            requiredPermissions = AdminPermission.GROUP_QUESTION_CREATE)
    public Mono<ResponseDTO<GroupJoinQuestion>> addGroupJoinQuestion(
            @Request AddGroupJoinQuestionDTO addGroupJoinQuestionDTO) {
        Mono<GroupJoinQuestion> createMono = groupQuestionService
                .createGroupJoinQuestions(addGroupJoinQuestionDTO.groupId(),
                        List.of(new NewGroupQuestion(
                                addGroupJoinQuestionDTO.question(),
                                addGroupJoinQuestionDTO.answers(),
                                addGroupJoinQuestionDTO.score())))
                .map(List::getFirst);
        return HttpHandlerResult.okIfTruthy(createMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = AdminPermission.GROUP_QUESTION_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateGroupJoinQuestions(
            Set<Long> ids,
            @Request UpdateGroupJoinQuestionsRequestDTO request) {
        Mono<UpdateResultDTO> updateMono = groupQuestionService
                .updateGroupJoinQuestions(ids,
                        request.groupId(),
                        request.question(),
                        request.answers(),
                        request.score())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = AdminPermission.GROUP_QUESTION_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteGroupJoinQuestions(
            @QueryParam(required = false) Set<Long> ids) {
        Mono<DeleteResultDTO> deleteMono = groupQuestionService.deleteGroupJoinQuestions(ids)
                .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

}