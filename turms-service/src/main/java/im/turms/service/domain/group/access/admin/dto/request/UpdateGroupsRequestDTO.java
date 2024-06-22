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
import java.util.LinkedHashSet;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.domain.common.access.dto.RequestUpdateDTO;
import im.turms.server.common.domain.common.access.dto.UpdateRequestWithFilterDTO;

/**
 * @author James Chen
 */
public record UpdateGroupsRequestDTO(
        FilterDTO filter,
        UpdateDTO update
) implements
        UpdateRequestWithFilterDTO<UpdateGroupsRequestDTO.FilterDTO, UpdateGroupsRequestDTO.UpdateDTO> {

    public record FilterDTO(
            @Schema(description = "The group IDs") LinkedHashSet<Long> groupIds
    ) implements RequestFilterDTO {
    }

    public record UpdateDTO(
            @Schema(description = "New group type ID") Long typeId,
            @Schema(description = "New creator ID") Long creatorId,
            @Schema(description = "New owner ID") Long ownerId,
            @Schema(description = "New name") String name,
            @Schema(description = "New intro") String intro,
            @Schema(description = "New announcement") String announcement,
            @Schema(description = "New minimum score") Integer minimumScore,
            @Schema(description = "New active status") Boolean active,
            @Schema(description = "New creation date") Date creationDate,
            @Schema(description = "New deletion date") Date deletionDate,
            @Schema(description = "New mute end date") Date muteEndDate,
            @Schema(description = "New successor ID") Long successorId,
            @Schema(
                    description = "Whether remove the owner from the group after transferring the group to the successor") Boolean removeOwnerAfterOwnershipTransferred
    ) implements RequestUpdateDTO {
    }
}