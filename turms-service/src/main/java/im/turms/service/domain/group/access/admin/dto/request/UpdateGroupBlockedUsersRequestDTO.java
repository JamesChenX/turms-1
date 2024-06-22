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

import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.domain.common.access.dto.RequestUpdateDTO;
import im.turms.server.common.domain.common.access.dto.UpdateRequestWithFilterDTO;
import im.turms.service.domain.group.po.GroupBlockedUser;

/**
 * @author James Chen
 */
public record UpdateGroupBlockedUsersRequestDTO(
        FilterDTO filter,
        UpdateDTO update
) implements
        UpdateRequestWithFilterDTO<UpdateGroupBlockedUsersRequestDTO.FilterDTO, UpdateGroupBlockedUsersRequestDTO.UpdateDTO> {

    public record FilterDTO(
            @Schema(description = "The ID of records") List<GroupBlockedUser.Key> ids
    ) implements RequestFilterDTO {
    }

    public record UpdateDTO(
            @Schema(
                    description = "The block end date (milliseconds since epoch)") Date blockEndDate,
            @Schema(description = "The requester ID") Long requesterId
    ) implements RequestUpdateDTO {
    }

}