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

package im.turms.ai.domain.model.dto.response;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import jakarta.annotation.Nullable;

import ai.djl.repository.Artifact;
import ai.djl.repository.Metadata;
import lombok.With;

import im.turms.server.common.domain.common.access.dto.ResponseComponentDTO;

/**
 * @author James Chen
 */
public record ModelDTO(
        @With List<String> applications,
        String version,
        String name,
        boolean isSnapshot,
        Map<String, String> properties,
        Map<String, Object> arguments,
        Map<String, String> options,
        List<ArtifactItemDTO> files,
        @Nullable MetadataDTO metadata
) implements ResponseComponentDTO, Comparable<ModelDTO> {
    public static ModelDTO from(List<String> applications, Artifact artifact) {
        Map<String, String> properties = artifact.getProperties();
        Map<String, Object> arguments = artifact.getArguments();
        Map<String, String> options = artifact.getOptions(null);
        Metadata metadata = artifact.getMetadata();
        MetadataDTO metadataDTO = metadata == null
                ? null
                : MetadataDTO.from(metadata);
        return new ModelDTO(
                applications,
                artifact.getVersion(),
                artifact.getName(),
                artifact.isSnapshot(),
                properties == null
                        ? Collections.emptyMap()
                        : properties,
                arguments == null
                        ? Collections.emptyMap()
                        : arguments,
                options == null
                        ? Collections.emptyMap()
                        : options,
                ArtifactItemDTO.from(artifact.getFiles()),
                metadataDTO);
    }

    @Override
    public int compareTo(ModelDTO o) {
        TODO
    }
}