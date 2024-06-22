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

import java.util.List;

import io.swagger.v3.oas.annotations.Parameter;

import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;
import im.turms.server.common.infra.security.SecurityValueConst;
import im.turms.server.common.infra.security.SensitiveProperty;

/**
 * @author James Chen
 */
public record CreateAdminAccountsRequestDTO(
        List<NewAdminDTO> records
) implements CreateRecordsRequestDTO<CreateAdminAccountsRequestDTO.NewAdminDTO> {

    public record NewAdminDTO(
            @Schema(description = "The account of the admin") String account,
            @Schema(
                    description = "The password of the admin") @SensitiveProperty(SensitiveProperty.Access.ALLOW_DESERIALIZATION) String password,
            @Schema(description = "The name of the admin") String name,
            @Schema(description = "The role ID of the admin", required = true) Long roleId
    ) implements RequestComponentDTO {
        @Override
        public String toString() {
            return "NewAdmin["
                    + "account="
                    + account
                    + ", password="
                    + SecurityValueConst.SENSITIVE_VALUE
                    + ", name="
                    + name
                    + ", roleId="
                    + roleId
                    + ']';
        }
    }

}