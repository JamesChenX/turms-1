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

package im.turms.server.common.domain.debug.access.admin.dto.request;

import java.util.List;
import jakarta.annotation.Nullable;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import im.turms.server.common.domain.common.access.dto.CreateRequestDTO;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@EqualsAndHashCode(callSuper = true)
@Data
public class CreateMethodCallsRequestDTO extends CreateRequestDTO {
    @Schema(description = "Whether to execute the method calls sequentially")
    private boolean executeSequentially;
    @Schema(description = "The method calls")
    private List<NewMethodCall> calls;

    public record NewMethodCall(
            @Nullable @Schema(
                    description = "The bean name of the controller. "
                            + "Either \"beanName\" and \"className\" must be specified") String beanName,
            @Nullable @Schema(
                    description = "Any class name. "
                            + "Either \"beanName\" and \"className\" must be specified") String className,
            @Schema(description = "The method name") String methodName,
            @Nullable @Schema(description = "The parameters") List<ParamDTO> params
    ) {
    }

    public record ParamDTO(
            @Nullable @Schema(description = "The parameter name") String name,
            @Nullable @Schema(description = "The parameter value") Object value
    ) {
    }

}