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
import java.util.List;
import java.util.Set;

import com.mongodb.client.result.DeleteResult;
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
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.time.DateRange;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.user.access.admin.dto.request.AddRelationshipGroupDTO;
import im.turms.service.domain.user.access.admin.dto.request.UpdateRelationshipGroupDTO;
import im.turms.service.domain.user.po.UserRelationshipGroup;
import im.turms.service.domain.user.service.UserRelationshipGroupService;

import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_GROUP_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_GROUP_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_GROUP_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_GROUP_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_USER_RELATIONSHIP_GROUP_RELATIONSHIP)
public class UserRelationshipGroupController extends BaseController {

    private final UserRelationshipGroupService userRelationshipGroupService;

    public UserRelationshipGroupController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            UserRelationshipGroupService userRelationshipGroupService) {
        super(context, propertiesManager);
        this.userRelationshipGroupService = userRelationshipGroupService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.CREATE,
            requiredPermissions = USER_RELATIONSHIP_GROUP_CREATE)
    public Mono<ResponseDTO<UserRelationshipGroup>> addRelationshipGroup(
            @Request AddRelationshipGroupDTO addRelationshipGroupDTO) {
        Mono<UserRelationshipGroup> createMono = userRelationshipGroupService
                .createRelationshipGroup(addRelationshipGroupDTO.ownerId(),
                        addRelationshipGroupDTO.index(),
                        addRelationshipGroupDTO.name(),
                        addRelationshipGroupDTO.creationDate(),
                        null);
        return HttpHandlerResult.okIfTruthy(createMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = USER_RELATIONSHIP_GROUP_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteRelationshipGroups(
            @QueryParam(required = false) List<UserRelationshipGroup.Key> keys) {
        Mono<DeleteResult> deleteMono = CollectionUtil.isEmpty(keys)
                ? userRelationshipGroupService.deleteRelationshipGroups()
                : userRelationshipGroupService
                        .deleteRelationshipGroups(CollectionUtil.newSet(keys));
        return HttpHandlerResult.okIfTruthy(deleteMono.map(DeleteResultDTO::from));
    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = USER_RELATIONSHIP_GROUP_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateRelationshipGroups(
            List<UserRelationshipGroup.Key> keys,
            @Request UpdateRelationshipGroupDTO updateRelationshipGroupDTO) {
        Mono<UpdateResultDTO> updateMono = userRelationshipGroupService
                .updateRelationshipGroups(CollectionUtil.newSet(keys),
                        updateRelationshipGroupDTO.name(),
                        updateRelationshipGroupDTO.creationDate())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = USER_RELATIONSHIP_GROUP_QUERY)
    public Mono<ResponseDTO<Collection<UserRelationshipGroup>>> queryRelationshipGroups(
            @QueryParam(required = false) Set<Long> ownerIds,
            @QueryParam(required = false) Set<Integer> indexes,
            @QueryParam(required = false) Set<String> names,
            @QueryParam(required = false) Date creationDateStart,
            @QueryParam(required = false) Date creationDateEnd,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<UserRelationshipGroup> queryFlux =
                userRelationshipGroupService.queryRelationshipGroups(ownerIds,
                        indexes,
                        names,
                        DateRange.of(creationDateStart, creationDateEnd),
                        0,
                        size);
        return HttpHandlerResult.okIfTruthy(queryFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(USER_RELATIONSHIP_GROUP_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<UserRelationshipGroup>>>> queryRelationshipGroups(
//            @QueryParam(required = false) Set<Long> ownerIds,
//            @QueryParam(required = false) Set<Integer> indexes,
//            @QueryParam(required = false) Set<String> names,
//            @QueryParam(required = false) Date creationDateStart,
//            @QueryParam(required = false) Date creationDateEnd,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = userRelationshipGroupService.countRelationshipGroups(ownerIds,
//                indexes,
//                names,
//                DateRange.of(creationDateStart, creationDateEnd));
//        Flux<UserRelationshipGroup> queryFlux =
//                userRelationshipGroupService.queryRelationshipGroups(ownerIds,
//                        indexes,
//                        names,
//                        DateRange.of(creationDateStart, creationDateEnd),
//                        page,
//                        size);
//        return HttpHandlerResult.page(count, queryFlux);
//    }

}