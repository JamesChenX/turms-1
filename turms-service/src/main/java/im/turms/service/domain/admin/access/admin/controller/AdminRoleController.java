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

package im.turms.service.domain.admin.access.admin.controller;

import java.util.LinkedHashSet;
import java.util.List;
import jakarta.annotation.Nullable;

import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.RequestContext;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.domain.admin.po.AdminRole;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.admin.access.admin.dto.request.CreateAdminRolesRequestDTO;
import im.turms.service.domain.admin.access.admin.dto.request.DeleteAdminRolesRequestDTO;
import im.turms.service.domain.admin.access.admin.dto.request.QueryAdminRolesRequestDTO;
import im.turms.service.domain.admin.access.admin.dto.request.UpdateAdminRolesRequestDTO;
import im.turms.service.domain.admin.access.admin.dto.response.CreateAdminRolesResponseDTO;
import im.turms.service.domain.admin.access.admin.dto.response.QueryAdminRolesResponseDTO;
import im.turms.service.domain.admin.service.AdminRoleService;
import im.turms.service.domain.common.access.admin.controller.BaseController;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_ADMIN_ROLE)
public class AdminRoleController extends BaseController {

    private final AdminRoleService adminRoleService;

    public AdminRoleController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            AdminRoleService adminRoleService) {
        super(context, propertiesManager);
        this.adminRoleService = adminRoleService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.CREATE,
            requiredPermissions = AdminPermission.ADMIN_ROLE_CREATE)
    public Mono<ResponseDTO<CreateAdminRolesResponseDTO>> createAdminRoles(
            RequestContext requestContext,
            CreateAdminRolesRequestDTO request) {
        Mono<List<AdminRole>> adminRolesMono = adminRoleService
                .authAndCreateAdminRoles(requestContext.getAdminUserAccount(), request.records());
        return ResponseDTO.of(adminRolesMono.map(CreateAdminRolesResponseDTO::from));
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.ADMIN_ROLE_QUERY)
    public Mono<ResponseDTO<QueryAdminRolesResponseDTO>> queryAdminRoles(
            @Nullable QueryAdminRolesRequestDTO request) {
        if (request == null) {
            // TODO: use aggregation.
            Mono<Long> count = adminRoleService.countAdminRoles(null, null, null, null);
            Flux<AdminRole> adminRoleFlux =
                    adminRoleService.queryAdminRoles(null, null, null, null, null, getLimit());
            return ResponseDTO.of(QueryAdminRolesResponseDTO.from(count, adminRoleFlux));
        } else if (!request.hasFilter()) {
            Mono<Long> count = adminRoleService.countAdminRoles(null, null, null, null);
            Flux<AdminRole> adminRoleFlux = adminRoleService.queryAdminRoles(null,
                    null,
                    null,
                    null,
                    request.skip(),
                    getLimit(request.limit()));
            return ResponseDTO.of(QueryAdminRolesResponseDTO.from(count, adminRoleFlux));
        }
        QueryAdminRolesRequestDTO.FilterDTO filter = request.filter();
        LinkedHashSet<Long> ids = filter.ids();
        LinkedHashSet<String> names = filter.names();
        LinkedHashSet<AdminPermission> includedPermissions = filter.includedPermissions();
        LinkedHashSet<Integer> ranks = filter.ranks();
        Mono<Long> count = adminRoleService.countAdminRoles(ids, names, includedPermissions, ranks);
        Flux<AdminRole> adminRoleFlux = adminRoleService.queryAdminRoles(ids,
                names,
                includedPermissions,
                ranks,
                request.skip(),
                getLimit(request.limit()));
        return ResponseDTO.of(QueryAdminRolesResponseDTO.from(count, adminRoleFlux));
    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = AdminPermission.ADMIN_ROLE_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateAdminRole(
            RequestContext requestContext,
            UpdateAdminRolesRequestDTO request) {
        UpdateAdminRolesRequestDTO.FilterDTO filter = request.filter();
        Mono<UpdateResult> updateMono =
                adminRoleService.authAndUpdateAdminRoles(requestContext.getAdminUserAccount(),
                        request.hasFilter()
                                ? request.filter()
                                        .ids()
                                : null,
                        request.name(),
                        request.permissions() == null
                                ? null
                                : AdminPermission.matchPermissions(request.permissions()),
                        request.rank());
        return HttpHandlerResult.updateResult(updateMono);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = AdminPermission.ADMIN_ROLE_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteAdminRoles(
            RequestContext requestContext,
            DeleteAdminRolesRequestDTO request) {
        Mono<DeleteResult> deleteMono;
        if (request.hasFilter()) {
            LinkedHashSet<Long> ids = request.filter()
                    .ids();
            if (ids == null) {
                deleteMono = adminRoleService
                        .authAndDeleteAdminRoles(requestContext.getAdminUserAccount(), null);
            } else {
                deleteMono = adminRoleService
                        .authAndDeleteAdminRoles(requestContext.getAdminUserAccount(), ids);
            }
        } else {
            deleteMono = adminRoleService
                    .authAndDeleteAdminRoles(requestContext.getAdminUserAccount(), null);
        }
        return ResponseDTO.deleteResult(deleteMono);
    }

}