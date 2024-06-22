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

package im.turms.ai.domain.ocr.dto.response;

import ai.djl.modality.cv.output.DetectedObjects;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;

import im.turms.ai.domain.ocr.bo.DetectedObjectClass;

/**
 * @author James Chen
 */
public record DetectedObjectDTO(
        @Schema(
                description = "Object class") @JsonProperty("class") DetectedObjectClass objectClass,
        @Schema(description = "Probability") Double probability,
        @Schema(description = "Bounding box") BoundingBoxDTO boundingBox,
        @Schema(description = "Detected text") String text
) {
    public static DetectedObjectDTO from(DetectedObjects.DetectedObject item) {
        return new DetectedObjectDTO(
                DetectedObjectClass.TEXT,
                item.getProbability(),
                BoundingBoxDTO.from(item.getBoundingBox()),
                item.getClassName());
    }
}