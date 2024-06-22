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

import java.util.Collection;
import java.util.Date;
import java.util.Set;

import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.Request;
import im.turms.server.common.access.admin.api.RequestContext;
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
import im.turms.server.common.domain.admin.po.AdminUser;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.admin.access.admin.dto.request.CreateAdminAccountsRequestDTO;
import im.turms.service.domain.admin.access.admin.dto.request.UpdateAdminDTO;
import im.turms.service.domain.admin.service.AdminUserService;
import im.turms.service.domain.common.access.admin.controller.BaseController;

import static im.turms.server.common.access.admin.permission.AdminPermission.ADMIN_ACCOUNT_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.ADMIN_ACCOUNT_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.ADMIN_ACCOUNT_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.ADMIN_ACCOUNT_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_ADMIN_USER)
public class AdminUserController extends BaseController {

    private final AdminUserService adminUserService;

    public AdminUserController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            AdminUserService adminUserService) {
        super(context, propertiesManager);
        this.adminUserService = adminUserService;
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = ADMIN_ACCOUNT_CREATE)
    public Mono<ResponseDTO<AdminUser>> addAdmin(
            RequestContext requestContext,
            @Request CreateAdminAccountsRequestDTO request) {
        Mono<AdminUser> generatedAdmin =
                adminUserService.authAndAddAdmin(requestContext.getAdminUserAccount(),
                        addAdminDTO.account(),
                        addAdminDTO.password(),
                        addAdminDTO.roleId(),
                        addAdminDTO.name(),
                        new Date(),
                        false);
        return HttpHandlerResult.okIfTruthy(generatedAdmin);
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = ADMIN_ACCOUNT_QUERY)
    public Mono<ResponseDTO<Collection<AdminUser>>> queryAdmins(
            @QueryParam(required = false) Set<String> accounts,
            @QueryParam(required = false) Set<Long> roleIds,
            boolean withPassword,
            @QueryParam(required = false) Integer size) {
        size = getLimit(size);
        Flux<AdminUser> admins = adminUserService.queryAdmins(accounts, roleIds, 0, size)
                .map(admin -> withPassword
                        ? admin
                        : admin.toBuilder()
                                .password(null)
                                .build());
        return HttpHandlerResult.okIfTruthy(admins);
    }

//    @GetMapping("page")
//    @RequiredPermission(ADMIN_ACCOUNT_QUERY)
//    public Mono<HttpHandlerResult<ResponseDTO<PaginationDTO<AdminUser>>>> queryAdmins(
//            @QueryParam(required = false) Set<String> accounts,
//            @QueryParam(required = false) Set<Long> roleIds,
//            boolean withPassword,
//            int page,
//            @QueryParam(required = false) Integer size) {
//        size = getLimit(size);
//        Mono<Long> count = adminUserService.countAdmins(accounts, roleIds);
//        Flux<AdminUser> admins = adminUserService.queryAdmins(accounts, roleIds, page, size)
//                .map(admin -> withPassword
//                        ? admin
//                        : admin.toBuilder()
//                                .password(null)
//                                .build());
//        return HttpHandlerResult.page(count, admins);
//    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = ADMIN_ACCOUNT_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateAdmins(
            RequestContext requestContext,
            Set<String> accounts,
            @Request UpdateAdminDTO updateAdminDTO) {
        Mono<UpdateResult> updateMono =
                adminUserService.authAndUpdateAdmins(requestContext.getAdminUserAccount(),
                        accounts,
                        updateAdminDTO.password(),
                        updateAdminDTO.name(),
                        updateAdminDTO.roleId());
        return HttpHandlerResult.updateResult(updateMono);
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = ADMIN_ACCOUNT_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deleteAdmins(
            RequestContext requestContext,
            Set<String> accounts) {
        Mono<DeleteResult> deleteMono = adminUserService
                .authAndDeleteAdminUsers(requestContext.getAdminUserAccount(), accounts);
        return HttpHandlerResult.deleteResult(deleteMono);
    }

}