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

package im.turms.server.common.domain.plugin.access.admin.dto.response;

import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * @author James Chen
 */
public record PluginDTO(
        @Schema(description = "The ID") String id,
        @Schema(description = "The version") String version,
        @Schema(description = "The provider") String provider,
        @Schema(description = "The license") String license,
        @Schema(description = "The description") String description,
        @Schema(description = "The extensions") List<ExtensionDTO> extensions
) {
}