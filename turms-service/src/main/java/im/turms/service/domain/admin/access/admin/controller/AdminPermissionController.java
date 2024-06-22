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

import java.util.List;

import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.lang.ClassUtil;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.admin.access.admin.dto.response.PermissionDTO;
import im.turms.service.domain.admin.access.admin.dto.response.QueryAdminPermissionsResponseDTO;
import im.turms.service.domain.common.access.admin.controller.BaseController;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_ADMIN_PERMISSION)
public class AdminPermissionController extends BaseController {

    private static final ResponseDTO<QueryAdminPermissionsResponseDTO> QUERY_ADMIN_PERMISSIONS_RESPONSE_EMPTY;

    static {
        AdminPermission[] permissions = ClassUtil.getSharedEnumConstants(AdminPermission.class);
        List<PermissionDTO> permissionDTOS = CollectionUtil.transformAsList(permissions,
                permission -> new PermissionDTO(permission.getGroup(), permission));
        QUERY_ADMIN_PERMISSIONS_RESPONSE_EMPTY = ResponseDTO
                .of(new QueryAdminPermissionsResponseDTO(permissionDTOS.size(), permissionDTOS));
    }

    public AdminPermissionController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager) {
        super(context, propertiesManager);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.ADMIN_PERMISSION_QUERY)
    public ResponseDTO<QueryAdminPermissionsResponseDTO> queryAdminPermissions() {
        return QUERY_ADMIN_PERMISSIONS_RESPONSE_EMPTY;
    }

}