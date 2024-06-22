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

package im.turms.server.common.domain.plugin.access.admin.dto.request;

import java.util.LinkedHashSet;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.domain.common.access.dto.RequestUpdateDTO;
import im.turms.server.common.domain.common.access.dto.UpdateRequestWithFilterDTO;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class UpdatePluginsRequestDTO extends
        UpdateRequestWithFilterDTO<UpdatePluginsRequestDTO.FilterDTO, UpdatePluginsRequestDTO.UpdateDTO> {

    @Accessors(fluent = true)
    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class FilterDTO extends RequestFilterDTO {
        @Schema(description = "Filter by plugin IDs")
        private LinkedHashSet<String> ids;
    }

    @Accessors(fluent = true)
    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class UpdateDTO extends RequestUpdateDTO {
        @Schema(description = "New status")
        private PluginStatus status;

        public enum PluginStatus {
            STARTED,
            STOPPED,
            RESUMED,
            PAUSED
        }
    }

}