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

import java.util.Date;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.access.client.dto.constant.GroupMemberRole;
import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;

/**
 * @author James Chen
 */
public record CreateGroupMembersRequestDTO(
        List<NewGroupMemberDTO> records
) implements CreateRecordsRequestDTO<CreateGroupMembersRequestDTO.NewGroupMemberDTO> {

    public record NewGroupMemberDTO(
            @Schema(description = "The ID of the group to which the member belongs") Long groupId,
            @Schema(description = "The ID of the user to be added to the group") Long userId,
            @Schema(description = "The name of the new group member") String name,
            @Schema(description = "The role of the new group member") GroupMemberRole role,
            @Schema(description = "The join date of the new group member") Date joinDate,
            @Schema(description = "The mute end date of the new group member") Date muteEndDate
    ) implements RequestComponentDTO {
    }

}