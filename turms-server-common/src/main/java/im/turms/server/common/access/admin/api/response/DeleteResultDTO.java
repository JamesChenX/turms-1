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

import com.mongodb.client.result.DeleteResult;
import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.domain.common.access.dto.ResponseDTO;

/**
 * @author James Chen
 */
public record DeleteResultDTO(
        @Schema(description = "Deleted count") Long deletedCount
) implements ResponseDTO {

    public static final DeleteResultDTO COUNT_0 = new DeleteResultDTO(0L);
    public static final DeleteResultDTO COUNT_1 = new DeleteResultDTO(1L);

    public static DeleteResultDTO from(DeleteResult result) {
        long count = result.getDeletedCount();
        if (count == 0) {
            return COUNT_0;
        } else if (count == 1) {
            return COUNT_1;
        }
        return new DeleteResultDTO(count);
    }

}