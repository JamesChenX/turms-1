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

import jakarta.annotation.Nullable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

/**
 * @author James Chen
 */
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public abstract non-sealed class QueryRequestWithFilterDTO<F> extends RequestDTO {

    @Schema(description = "The filter is used to filter the records")
    @Nullable
    private F filter;

//    @Schema(
//            description = "Whether to query all records. "
//                          + "If true, \"filter\" must be absent, null, or empty. Otherwise, Turms will respond with a status of 400. "
//                          + "This parameter is mainly designed to prevent the admin from querying all records unconsciously")
//    private boolean queryAll;

    @Override
    public boolean hasFilter() {
        return filter() != null;
    }

}