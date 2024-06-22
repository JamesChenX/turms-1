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

package im.turms.service.domain.admin.access.admin.dto.response;

import java.util.Date;
import java.util.Set;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.domain.admin.po.AdminRole;

/**
 * @author James Chen
 */
public record AdminRoleDTO(
        @Schema(description = "The ID") Long id,
        @Schema(description = "The name") String name,
        @Schema(description = "The permissions") Set<AdminPermission> permissions,
        @Schema(description = "The ID") Integer rank,
        @Schema(description = "The creation date in millis") Date creationDate
) {
    public static AdminRoleDTO from(AdminRole adminRole) {
        return new AdminRoleDTO(
                adminRole.getId(),
                adminRole.getName(),
                adminRole.getPermissions(),
                adminRole.getRank(),
                adminRole.getCreationDate());
    }
}