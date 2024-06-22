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

package im.turms.server.common.domain.observation.access.admin.dto.response;

import java.util.Date;
import jakarta.annotation.Nullable;

import io.swagger.v3.oas.annotations.media.Schema;
import jdk.jfr.Recording;
import jdk.jfr.RecordingState;

import im.turms.server.common.domain.common.access.dto.ControllerDTO;
import im.turms.server.common.domain.observation.model.RecordingSession;

/**
 * @author James Chen
 */
public record RecordingDTO(
        @Schema(description = "The ID") long id,
        @Schema(description = "The state") RecordingState state,
        @Schema(description = "The start date") Date startDate,
        @Schema(
                description = "The stop date. The field will not exist if the recording is still running") @Nullable Date stopDate,
        @Nullable String description
) implements ControllerDTO {

    public static RecordingDTO from(RecordingSession session) {
        Recording recording = session.recording();
        return new RecordingDTO(
                recording.getId(),
                recording.getState(),
                Date.from(recording.getStartTime()),
                session.getStopDate(),
                session.description());
    }

}