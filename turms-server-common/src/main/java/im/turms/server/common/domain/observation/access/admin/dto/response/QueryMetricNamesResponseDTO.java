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
import java.util.Set;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.QueryRecordsResponseDTO;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class QueryMetricNamesResponseDTO extends QueryRecordsResponseDTO<MetricNameDTO> {

    public QueryMetricNamesResponseDTO(int count, List<MetricNameDTO> list) {
        super(count, list);
    }

    public static QueryMetricNamesResponseDTO of(Set<String> names) {
        int count = names.size();
        List<MetricNameDTO> list = new ArrayList<>(count);
        for (String name : names) {
            MetricNameDTO metricName = new MetricNameDTO(name);
            list.add(metricName);
        }
        return new QueryMetricNamesResponseDTO(count, list);
    }

}