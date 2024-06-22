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

package im.turms.service.domain.message.access.admin.dto.request;

import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.access.client.dto.constant.DeviceType;
import im.turms.server.common.domain.common.access.dto.RequestFilterDTO;
import im.turms.server.common.domain.common.access.dto.RequestUpdateDTO;
import im.turms.server.common.domain.common.access.dto.UpdateRequestWithFilterDTO;

/**
 * @author James Chen
 */
public record UpdateMessagesRequestDTO(
        FilterDTO filter,
        UpdateDTO update
) implements
        UpdateRequestWithFilterDTO<UpdateMessagesRequestDTO.FilterDTO, UpdateMessagesRequestDTO.UpdateDTO> {

    public record FilterDTO(
            @Schema(description = "Filter by message IDs") LinkedHashSet<Long> ids
    ) implements RequestFilterDTO {
    }

    public record UpdateDTO(
            Long senderId,
            String senderIp,
            DeviceType senderDeviceType,
            Boolean isSystemMessage,
            String text,
            List<byte[]> records,
            Integer burnAfter,
            Date recallDate
    ) implements RequestUpdateDTO {
    }

}