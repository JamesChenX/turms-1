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
import java.util.stream.Collectors;

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
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.recycler.ListRecycler;
import im.turms.server.common.infra.recycler.Recyclable;
import im.turms.server.common.infra.time.DateRange;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.user.access.admin.dto.request.AddRelationshipDTO;
import im.turms.service.domain.user.access.admin.dto.request.UpdateRelationshipDTO;
import im.turms.service.domain.user.access.admin.dto.response.UserRelationshipDTO;
import im.turms.service.domain.user.bo.UpsertRelationshipResult;
import im.turms.service.domain.user.po.UserRelationship;
import im.turms.service.domain.user.service.UserRelationshipGroupService;
import im.turms.service.domain.user.service.UserRelationshipService;

import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.USER_RELATIONSHIP_UPDATE;
import static im.turms.server.common.domain.user.constant.UserConst.DEFAULT_RELATIONSHIP_GROUP_INDEX;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_BUSINESS_USER_RELATIONSHIP_GROUP_RELATIONSHIP)
public class UserRelationshipController extends BaseController {

    private final UserRelationshipService userRelationshipService;
    private final UserRelationshipGroupService userRelationshipGroupService;

    public UserRelationshipController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            UserRelationshipService userRelationshipService,
            UserRelationshipGroupService userRelationshipGroupService) {
        super(context, propertiesManager);
        this.userRelationshipService = userRelationshipService;
        this.userRelationshipGroupService = userRelationshipGroupService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = USER_RELATIONSHIP_CREATE)
    public Mono<ResponseDTO<Void>> addRelationship(@Request AddRelationshipDTO addRelationshipDTO) {
        Mono<UpsertRelationshipResult> upsertMono =
                userRelationshipService.upsertOneSidedRelationship(addRelationshipDTO.ownerId(),
                        addRelationshipDTO.relatedUserId(),
                        addRelationshipDTO.name(),
                        addRelationshipDTO.blockDate(),
                        DEFAULT_RELATIONSHIP_GROUP_INDEX,
                        null,
                        addRelationshipDTO.establishmentDate(),
                        false,
                        null);
        return upsertMono.thenReturn(HttpHandlerResult.RESPONSE_OK);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = USER_RELATIONSHIP_QUERY)
    public Mono<ResponseDTO<Collection<UserRelationshipDTO>>> queryRelationships(
            @QueryParam(required = false) Set<Long> ownerIds,
            @QueryParam(required = false) Set<Long> relatedUserIds,
            @QueryParam(required = false) Set<Integer> groupIndexes,
            @QueryParam(required = false) Boolean isBlocked,
            @QueryParam(required = false) Date establishmentDateStart,
            @QueryParam(required = false) Date establishmentDateEnd,
            @QueryParam(required = false) Integer size,
            boolean withGroupIndexes) {
        size = getLimit(size);
        Flux<UserRelationship> relationshipsFlux =
                userRelationshipService.queryRelationships(ownerIds,
                        relatedUserIds,
                        groupIndexes,
                        isBlocked,
                        DateRange.of(establishmentDateStart, establishmentDateEnd),
                        0,
                        size);
        Flux<UserRelationshipDTO> dtoFlux = relationship2dto(withGroupIndexes, relationshipsFlux);
        return HttpHandlerResult.okIfTruthy(dtoFlux);
    }

//    @GetMapping("page")
//    @RequiredPermission(USER_RELATIONSHIP_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<UserRelationshipDTO>>>> queryRelationships(
//            @QueryParam(required = false) Set<Long> ownerIds,
//            @QueryParam(required = false) Set<Long> relatedUserIds,
//            @QueryParam(required = false) Set<Integer> groupIndexes,
//            @QueryParam(required = false) Boolean isBlocked,
//            @QueryParam(required = false) Date establishmentDateStart,
//            @QueryParam(required = false) Date establishmentDateEnd,
//            int page,
//            @QueryParam(required = false) Integer size,
//            boolean withGroupIndexes) {
//        size = getLimit(size);
//        Mono<Long> count = userRelationshipService
//                .countRelationships(ownerIds, relatedUserIds, groupIndexes, isBlocked);
//        Flux<UserRelationship> relationshipsFlux =
//                userRelationshipService.queryRelationships(ownerIds,
//                        relatedUserIds,
//                        groupIndexes,
//                        isBlocked,
//                        DateRange.of(establishmentDateStart, establishmentDateEnd),
//                        page,
//                        size);
//        Flux<UserRelationshipDTO> dtoFlux = relationship2dto(withGroupIndexes, relationshipsFlux);
//        return HttpHandlerResult.page(count, dtoFlux);
//    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = USER_RELATIONSHIP_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateRelationships(
            List<UserRelationship.Key> keys,
            @Request UpdateRelationshipDTO updateRelationshipDTO) {
        Mono<UpdateResultDTO> updateMono = userRelationshipService
                .updateUserOneSidedRelationships(CollectionUtil.newSet(keys),
                        updateRelationshipDTO.name(),
                        updateRelationshipDTO.blockDate(),
                        updateRelationshipDTO.establishmentDate())
                .map(UpdateResultDTO::from);
        return HttpHandlerResult.okIfTruthy(updateMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = USER_RELATIONSHIP_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteRelationships(List<UserRelationship.Key> keys) {
        Mono<DeleteResultDTO> deleteMono =
                userRelationshipService.deleteOneSidedRelationships(CollectionUtil.newSet(keys))
                        .map(DeleteResultDTO::from);
        return HttpHandlerResult.okIfTruthy(deleteMono);
    }

    private Flux<UserRelationshipDTO> relationship2dto(
            Boolean withGroupIndexes,
            Flux<UserRelationship> relationshipsFlux) {
        return relationshipsFlux.flatMap(relationship -> {
            if (withGroupIndexes) {
                Recyclable<List<Integer>> recyclableList = ListRecycler.obtain();
                return userRelationshipGroupService.queryGroupIndexes(relationship.getKey()
                        .getOwnerId(),
                        relationship.getKey()
                                .getRelatedUserId())
                        .collect(Collectors.toCollection(recyclableList::getValue))
                        .map(indexes -> UserRelationshipDTO.from(relationship,
                                CollectionUtil.newSet(indexes)))
                        .doFinally(signalType -> recyclableList.recycle());
            }
            return Mono.just(UserRelationshipDTO.from(relationship));
        });
    }

}