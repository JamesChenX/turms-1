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

import java.util.ArrayList;
import java.util.List;

import im.turms.server.common.domain.common.access.dto.QueryRecordsResponseDTO;

/**
 * @author James Chen
 */
public record QueryLogPathsResponseDTO(
        long total,
        List<PathDTO> records
) implements QueryRecordsResponseDTO<PathDTO> {
    public static QueryLogPathsResponseDTO from(List<String> paths) {
        int count = paths.size();
        List<PathDTO> list = new ArrayList<>(count);
        for (String path : paths) {
            PathDTO pathDTO = new PathDTO(path);
            list.add(pathDTO);
        }
        return new QueryLogPathsResponseDTO(count, list);
    }
}