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

import java.util.List;

import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.server.common.access.client.dto.constant.DeviceType;
import im.turms.server.common.domain.common.access.dto.CreateRecordsRequestDTO;
import im.turms.server.common.domain.common.access.dto.RequestComponentDTO;

/**
 * @author James Chen
 */
public record CreateMessagesRequestDTO(
        List<NewMessageDTO> records,
        @Schema(
                description = "Whether to send the messages to their recipients after creating them") boolean send
) implements CreateRecordsRequestDTO<CreateMessagesRequestDTO.NewMessageDTO> {

    public record NewMessageDTO(
            Long id,
            Boolean isGroupMessage,
            Boolean isSystemMessage,
            String text,
            List<byte[]> records,
            Long senderId,
            String senderIp,
            DeviceType senderDeviceType,
            Long targetId,
            Integer burnAfter,
            Long referenceId,
            Long preMessageId
    ) implements RequestComponentDTO {
    }

}