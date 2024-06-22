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

import io.swagger.v3.oas.annotations.Parameter;

import im.turms.server.common.access.client.dto.constant.RequestStatus;
import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;

/**
 * @author James Chen
 */
public record CreateGroupInvitationsRequestDTO(
        List<NewGroupInvitationDTO> records
) implements CreateRecordsRequestDTO<CreateGroupInvitationsRequestDTO.NewGroupInvitationDTO> {

    public record NewGroupInvitationDTO(
            @Schema(description = "The ID of the new invitation") Long id,
            @Schema(description = "The content of the new invitation") String content,
            @Schema(description = "The status of the new invitation") RequestStatus status,
            @Schema(description = "The creation date of the new invitation") Date creationDate,
            @Schema(description = "The response date of the new invitation") Date responseDate,
            @Schema(
                    description = "The ID of the group to which the invitation belongs") Long groupId,
            @Schema(
                    description = "The ID of the inviter who creates the invitation") Long inviterId,
            @Schema(
                    description = "The ID of the invitee who receives the invitation") Long inviteeId
    ) implements RequestComponentDTO {
    }

}