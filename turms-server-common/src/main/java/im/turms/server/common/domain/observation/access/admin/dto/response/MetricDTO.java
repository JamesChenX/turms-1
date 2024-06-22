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

package im.turms.server.common.domain.observation.access.admin.dto.response;

import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.domain.common.access.dto.ResponseComponentDTO;
import im.turms.server.common.infra.collection.CollectionUtil;

/**
 * @author James Chen
 */
public record MetricDTO(
        @Schema(description = "The metric name") String name,
        @Nullable @Schema(description = "The metric description") String description,
        @Schema(description = "The base unit") String baseUnit,
        @Schema(description = "The measurements") List<MeasurementDTO> measurements,
        @Nullable @Schema(description = "The available tags") Map<String, Set<String>> availableTags
) implements Comparable<MetricDTO> {

    @Override
    public int compareTo(@NotNull MetricDTO o) {
        int result = name.compareTo(o.name);
        if (result != 0) {
            return result;
        }
        Map<String, Set<String>> availableTags2 = o.availableTags;
        if (availableTags == null) {
            return availableTags2 == null
                    ? 0
                    : -1;
        }
        if (availableTags2 == null) {
            return 1;
        }
        return CollectionUtil.compare(availableTags.keySet(), availableTags2.keySet());
    }

    public record MeasurementDTO(
            @Schema(description = "The tags") List<String> tags,
            @Schema(description = "The measurements") Map<String, Double> measurements
    ) implements Comparable<MeasurementDTO> {
        @Override
        public int compareTo(@NotNull MeasurementDTO o) {
            return CollectionUtil.compare(tags, o.tags);
        }
    }
}