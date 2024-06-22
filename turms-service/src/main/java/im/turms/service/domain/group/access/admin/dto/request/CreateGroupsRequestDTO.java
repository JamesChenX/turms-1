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

import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;

/**
 * @author James Chen
 */
public record CreateGroupsRequestDTO(
        List<NewGroupDTO> records
) implements CreateRecordsRequestDTO<CreateGroupsRequestDTO.NewGroupDTO> {

    public record NewGroupDTO(
            @Schema(description = "The group type ID") Long typeId,
            @Schema(description = "The creator ID") Long creatorId,
            @Schema(description = "The owner ID") Long ownerId,
            @Schema(description = "The group name") String name,
            @Schema(description = "The group intro") String intro,
            @Schema(description = "The group announcement") String announcement,
            @Schema(description = "The minimum score to join the group") Integer minimumScore,
            @Schema(description = "The creation date") Date creationDate,
            @Schema(description = "The deletion date") Date deletionDate,
            @Schema(description = "The mute end date") Date muteEndDate,
            @Schema(description = "Whether the group is active") Boolean isActive
    ) implements RequestComponentDTO {
    }

}