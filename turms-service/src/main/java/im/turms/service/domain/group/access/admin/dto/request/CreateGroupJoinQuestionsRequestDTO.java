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

package im.turms.service.domain.group.access.admin.dto.request;

import java.util.List;

import io.swagger.v3.oas.annotations.Parameter;

import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;

/**
 * @author James Chen
 */
public record CreateGroupJoinQuestionsRequestDTO(
        List<NewGroupJoinQuestionDTO> records
) implements CreateRecordsRequestDTO<CreateGroupJoinQuestionsRequestDTO.NewGroupJoinQuestionDTO> {

    public record NewGroupJoinQuestionDTO(
            @Schema(description = "The ID of the group to which the question belongs") Long groupId,
            @Schema(description = "The question text") String question,
            @Schema(description = "The answers to the question") List<String> answers,
            @Schema(description = "The score of the question") Integer score
    ) implements RequestComponentDTO {
    }

}