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

import io.netty.buffer.ByteBuf;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.FileDTO;
import im.turms.server.common.infra.http.MediaTypeConst;
import im.turms.server.common.infra.security.SecurityValueConst;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class CreateJavaPluginsRequestDTO
        extends CreateRecordsRequestDTO<CreateJavaPluginsRequestDTO.NewJavaPluginScriptDTO> {
    @Schema(description = "Whether to save the new Java plugins to the file system")
    private boolean save;

    @Accessors(fluent = true)
    @EqualsAndHashCode(callSuper = true)
    @Data
    public static class NewJavaPluginScriptDTO extends FileDTO {

        @Nullable
        @Override
        @Schema(
                description = "The name of the Java file. The filename will be used to save the file to the file system if \"save\" is true")
        public String filename() {
            return super.filename();
        }

        @Override
        @Schema(
                description = "The JAR archive that contains the compiled class files of the plugin",
                contentMediaType = MediaTypeConst.APPLICATION_JAVA_ARCHIVE)
        public ByteBuf data() {
            return super.data();
        }

        @Override
        public String toString() {
            return "NewJsPluginScriptDTO{"
                    + "filename='"
                    + filename
                    + '\''
                    + ", data='"
                    + SecurityValueConst.SENSITIVE_VALUE
                    + '\''
                    + '}';
        }

    }

}