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

package im.turms.server.common.domain.common.access.dto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * It is recommended to use the list instead of the map because the list is more flexible.
 *
 * @author James Chen
 */
public record NameValueDTO<T>(
        String name,
        T value
) implements ResponseComponentDTO {

    public static <T> List<NameValueDTO<T>> from(Map<String, T> map) {
        List<NameValueDTO<T>> list = new ArrayList<>(map.size());
        map.forEach((key, value) -> list.add(new NameValueDTO<>(key, value)));
        return list;
    }

}