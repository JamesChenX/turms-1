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

package im.turms.server.common.domain.observation.access.admin.dto.request;

import java.util.LinkedHashSet;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.domain.common.access.dto.QueryRequestWithPaginationDTO;
import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;

/**
 * @author James Chen
 */
public record QueryMetricsRequestDTO(
        FilterDTO filter,
        @Schema(description = "Whether to return the metric description") boolean returnDescription,
        @Schema(description = "Whether to return the available tags") boolean returnAvailableTags
) implements QueryRequestWithPaginationDTO<QueryMetricsRequestDTO.FilterDTO> {

    public record FilterDTO(
            @Schema(description = "Filter by metric names") LinkedHashSet<String> names,
            @Schema(description = "Filter by metric tags") LinkedHashSet<String> tags
    ) implements RequestFilterDTO {
    }

}