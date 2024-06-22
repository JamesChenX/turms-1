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

package im.turms.server.common.access.admin.api.response;

import com.mongodb.client.result.UpdateResult;
import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.domain.common.access.dto.ResponseDTO;

/**
 * @author James Chen
 * @implNote In most cases, it is meaningful to use UpdateResultDTO instead of ResponseStatusCode.OK
 *           for the result of update operations because an update operation is usually considered
 *           as successful even if the no documents changed (no documents matched)
 */
public record UpdateResultDTO(
        @Schema(description = "Matched count") Long matchedCount,
        @Schema(description = "Modified count") Long modifiedCount
) implements ResponseDTO {

    public static final UpdateResultDTO MODIFIED_COUNT_0 = new UpdateResultDTO(0L, 0L);
    public static final UpdateResultDTO MODIFIED_COUNT_1 = new UpdateResultDTO(1L, 1L);

    public static UpdateResultDTO from(UpdateResult result) {
        long resultMatchedCount = result.getMatchedCount();
        long resultModifiedCount = result.getModifiedCount();
        if (resultModifiedCount == 0L) {
            if (resultMatchedCount == 0L) {
                return MODIFIED_COUNT_0;
            }
            return new UpdateResultDTO(resultMatchedCount, resultModifiedCount);
        } else if (resultModifiedCount == 1L) {
            if (resultMatchedCount == 1L) {
                return MODIFIED_COUNT_1;
            }
            return new UpdateResultDTO(resultMatchedCount, resultModifiedCount);
        }
        return new UpdateResultDTO(resultMatchedCount, resultModifiedCount);
    }

}