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

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.CreateRecordsResponseDTO;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class CreatePluginsResponseDTO extends CreateRecordsResponseDTO<PluginDTO> {
    public CreatePluginsResponseDTO(List<PluginDTO> pluginInfoList) {
        super(pluginInfoList);
    }

    public static CreatePluginsResponseDTO of(List<PluginDTO> pluginInfoList) {
        return new CreatePluginsResponseDTO(pluginInfoList);
    }
}