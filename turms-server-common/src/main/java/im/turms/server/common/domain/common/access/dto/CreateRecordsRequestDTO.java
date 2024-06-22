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

import java.util.List;

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
public abstract non-sealed class CreateRecordsRequestDTO<R> extends RequestDTO {

    @Schema(description = "The records to create")
    private List<R> records;

//    @Schema(
//            description = "Whether to continue creating the remaining records even if fail to create a record. "
//                          + "This parameter is usually used set to true to ignore the duplicate record error. "
//                          + "Note that \"atomic\" must not be true if \"continueOnInsertError\" is true, or Turms will respond with a status of 400")
//    boolean continueOnCreateError();
//
//    @Schema(
//            description = "Whether to create records atomically. "
//                          + "If true, no records will be created if an error occurs. "
//                          + "Note that \"atomic\" must not be true if \"continueOnInsertError\" is true, or Turms will respond with a status of 400")
//    boolean atomic();

}