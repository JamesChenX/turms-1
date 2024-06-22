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

package im.turms.service.domain.cluster.access.admin.dto.request;

import java.util.LinkedHashSet;
import jakarta.annotation.Nullable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.QueryRequestWithPaginationDTO;
import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.infra.cluster.node.NodeRole;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class QueryMembersRequestDTO
        extends QueryRequestWithPaginationDTO<QueryMembersRequestDTO.FilterDTO> {

    @Accessors(fluent = true)
    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class FilterDTO extends RequestFilterDTO {
        @Nullable
        @Schema(description = "Filter by node IDs")
        private LinkedHashSet<String> ids;
        @Nullable
        @Schema(description = "Filter by role")
        private NodeRole role;
    }

}