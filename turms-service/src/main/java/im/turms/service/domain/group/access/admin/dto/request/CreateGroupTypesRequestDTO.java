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

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;
import im.turms.service.domain.group.bo.GroupInvitationStrategy;
import im.turms.service.domain.group.bo.GroupJoinStrategy;
import im.turms.service.domain.group.bo.GroupUpdateStrategy;

/**
 * @author James Chen
 */
public record CreateGroupTypesRequestDTO(
        List<NewGroupTypeDTO> records
) implements CreateRecordsRequestDTO<CreateGroupTypesRequestDTO.NewGroupTypeDTO> {

    public record NewGroupTypeDTO(
            @Schema(description = "The name of the new group type") String name,
            @Schema(
                    description = "The group size limit of the new group type") Integer groupSizeLimit,
            @Schema(
                    description = "The invitation strategy of the new group type") GroupInvitationStrategy invitationStrategy,
            @Schema(
                    description = "The join strategy of the new group type") GroupJoinStrategy joinStrategy,
            @Schema(
                    description = "The group info update strategy of the new group type") GroupUpdateStrategy groupInfoUpdateStrategy,
            @Schema(
                    description = "The member info update strategy of the new group type") GroupUpdateStrategy memberInfoUpdateStrategy,
            @Schema(description = "Whether the guest can send messages") Boolean guestSpeakable,
            @Schema(
                    description = "Whether the guest can update their information") Boolean selfInfoUpdatable,
            @Schema(description = "Whether to enable read receipts") Boolean enableReadReceipt,
            @Schema(
                    description = "Whether the guest can edit their messages") Boolean messageEditable
    ) implements RequestComponentDTO {
    }

}