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

package im.turms.service.domain.admin.access.admin.dto.request;

import java.util.LinkedHashSet;

import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.domain.common.access.dto.RequestUpdateDTO;
import im.turms.server.common.domain.common.access.dto.UpdateRequestWithFilterDTO;
import im.turms.server.common.infra.security.SecurityValueConst;
import im.turms.server.common.infra.security.SensitiveProperty;

/**
 * @author James Chen
 */
public record UpdateAdminAccountsRequestsDTO(
        FilterDTO filter,
        UpdateDTO update
) implements
        UpdateRequestWithFilterDTO<UpdateAdminAccountsRequestsDTO.FilterDTO, UpdateAdminAccountsRequestsDTO.UpdateDTO> {

    public record FilterDTO(
            @Schema(description = "The account IDs") LinkedHashSet<String> accountIds
    ) implements RequestFilterDTO {
    }

    public record UpdateDTO(
            @Schema(
                    description = "New password") @SensitiveProperty(SensitiveProperty.Access.ALLOW_DESERIALIZATION) String password,
            @Schema(description = "New name") String name,
            @Schema(description = "New role ID") Long roleId
    ) implements RequestUpdateDTO {
        @Override
        public String toString() {
            return "UpdateDTO["
                    + "password="
                    + SecurityValueConst.SENSITIVE_VALUE
                    + ", name="
                    + name
                    + ", roleId="
                    + roleId
                    + ']';
        }
    }

}