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

import jakarta.annotation.Nullable;

import com.fasterxml.jackson.annotation.JsonAlias;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.infra.security.SecurityValueConst;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class CreateJavaScriptPluginsRequestDTO extends
        CreateRecordsRequestDTO<CreateJavaScriptPluginsRequestDTO.NewJavaScriptPluginScriptDTO> {
    @Schema(description = "Whether to save the new JavaScript plugins to the file system")
    private boolean save;

    public record NewJavaScriptPluginScriptDTO(
            @Nullable @JsonAlias( {
                    "fileName",
                    "filename"}) @Schema(
                            description = "The name of the JavaScript file") String fileName,
            @Schema(
                    description = "The JavaScript code. The original code is required, not the text encoded in Base64") String code
    ){
        @Override
        public String toString() {
            return "NewJsPluginScriptDTO{"
                    + "fileName='"
                    + fileName
                    + '\''
                    + ", code='"
                    + SecurityValueConst.SENSITIVE_VALUE
                    + '\''
                    + '}';
        }
    }

}