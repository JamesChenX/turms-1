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

package im.turms.service.domain.user.access.admin.dto.request;

import java.util.Date;
import java.util.List;

import io.swagger.v3.oas.annotations.Parameter;

import im.turms.server.common.access.client.dto.constant.RequestStatus;
import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;

/**
 * @author James Chen
 */
public record CreateFriendRequestsRequestDTO(
        List<NewFriendRequest> records
) implements CreateRecordsRequestDTO<CreateFriendRequestsRequestDTO.NewFriendRequest> {

    public record NewFriendRequest(
            @Schema(description = "The ID of the friend request") Long id,
            @Schema(description = "The ID of the requester") Long requesterId,
            @Schema(description = "The ID of the recipient") Long recipientId,
            @Schema(description = "The content of the friend request") String content,
            @Schema(description = "The status of the friend request") RequestStatus status,
            @Schema(
                    description = "The reason for why the recipient accepted or denied the friend request") String reason,
            @Schema(description = "The creation date of the friend request") Date creationDate,
            @Schema(description = "The response date of the friend request") Date responseDate
    ) {
    }

}