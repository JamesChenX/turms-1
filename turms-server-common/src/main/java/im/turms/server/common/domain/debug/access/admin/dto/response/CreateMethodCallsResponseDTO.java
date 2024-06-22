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

package im.turms.server.common.domain.debug.access.admin.dto.response;

import java.util.List;
import jakarta.annotation.Nullable;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.ResponseDTO;

/**
 * @author James Chen
 */
public record CreateMethodCallsResponseDTO(
        List<MethodCallResult> results
) implements ResponseDTO {

    public record MethodCallResult(
            @Schema(description = "The status code of the method call") ResponseStatusCode code,
            @Nullable @Schema(
                    description = "The return value of the method call. "
                            + "The value is null if the target method is a void method, or throws an error") Object returnValue,
            @Nullable @Schema(
                    description = "The error message threw by the method call. "
                            + "The value is not null if the method call throws an error") String error
    ) {
    }

}