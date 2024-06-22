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

import java.util.LinkedHashSet;

import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.domain.common.access.dto.RequestUpdateDTO;
import im.turms.server.common.domain.common.access.dto.UpdateRequestWithFilterDTO;
import im.turms.service.domain.group.bo.GroupInvitationStrategy;
import im.turms.service.domain.group.bo.GroupJoinStrategy;
import im.turms.service.domain.group.bo.GroupUpdateStrategy;

/**
 * @author James Chen
 */
public record UpdateGroupTypesRequestDTO(
        FilterDTO filter,
        UpdateDTO update
) implements
        UpdateRequestWithFilterDTO<UpdateGroupTypesRequestDTO.FilterDTO, UpdateGroupTypesRequestDTO.UpdateDTO> {

    public record FilterDTO(
            @Schema(description = "Group type IDs") LinkedHashSet<Long> groupTypeIds
    ) implements RequestFilterDTO {
    }

    public record UpdateDTO(
            @Schema(description = "New name") String name,
            @Schema(description = "New group size limit") Integer groupSizeLimit,
            @Schema(
                    description = "New invitation strategy") GroupInvitationStrategy invitationStrategy,
            @Schema(description = "New join strategy") GroupJoinStrategy joinStrategy,
            @Schema(
                    description = "New info update strategy") GroupUpdateStrategy groupInfoUpdateStrategy,
            @Schema(
                    description = "New member info update strategy") GroupUpdateStrategy memberInfoUpdateStrategy,
            @Schema(description = "Whether the guest can send messages") Boolean guestSpeakable,
            @Schema(
                    description = "Whether the guest can update their information") Boolean selfInfoUpdatable,
            @Schema(description = "Whether to enable read receipts") Boolean enableReadReceipt,
            @Schema(
                    description = "Whether the guest can edit their messages") Boolean messageEditable

    ) implements RequestUpdateDTO {
    }
}