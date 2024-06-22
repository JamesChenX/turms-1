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

package im.turms.ai.domain.ocr.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import jakarta.annotation.Nullable;

import ai.djl.modality.cv.output.DetectedObjects;
import org.springframework.context.ApplicationContext;

import im.turms.ai.domain.ocr.dto.response.DetectedObjectDTO;
import im.turms.ai.domain.ocr.dto.response.QueryDetectedObjectsResponseDTO;
import im.turms.ai.domain.ocr.service.OcrService;
import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.Request;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.BinaryRequestDTO;
import im.turms.server.common.domain.common.access.dto.BinaryResponseDTO;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.http.MediaTypeConst;
import im.turms.server.common.infra.io.FileHolder;
import im.turms.server.common.infra.io.FileResource;
import im.turms.server.common.infra.logging.core.logger.Logger;
import im.turms.server.common.infra.logging.core.logger.LoggerFactory;

import static im.turms.server.common.infra.http.MediaTypeConst.IMAGE_PNG;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_AI_SERVING_OCR)
public class OcrController extends BaseApiController {

    private static final Logger LOGGER = LoggerFactory.getLogger(OcrController.class);

    private static final ResponseDTO<QueryDetectedObjectsResponseDTO> DETECT_TEXT_RESULT_EMPTY =
            ResponseDTO.of(new QueryDetectedObjectsResponseDTO(Collections.emptyList()));

    private final OcrService ocrService;

    public OcrController(ApplicationContext context, OcrService ocrService) {
        super(context);
        this.ocrService = ocrService;
    }

    @ApiEndpoint(value = "image/object", action = ApiEndpointAction.QUERY)
    public ResponseDTO<QueryDetectedObjectsResponseDTO> detectTexts(
            @Request(contentType = MediaTypeConst.IMAGE) BinaryRequestDTO request) {
        List<FileHolder> fileHolders = request.fileHolders();
        int size = fileHolders.size();
        if (0 == size) {
            return DETECT_TEXT_RESULT_EMPTY;
        }
        if (1 < size) {
            throw ResponseException.get(ResponseStatusCode.ILLEGAL_ARGUMENT,
                    "Only support one image");
        }
        FileHolder fileHolder = fileHolders.getFirst();
        String imagePath = fileHolder.file()
                .toPath()
                .toAbsolutePath()
                .normalize()
                .toString();
        DetectedObjects detectedObjects = ocrService.ocr(imagePath);
        List<DetectedObjects.DetectedObject> items = detectedObjects.items();
        List<DetectedObjectDTO> dtos = new ArrayList<>(items.size());
        for (DetectedObjects.DetectedObject item : items) {
            dtos.add(DetectedObjectDTO.from(item));
        }
        return ResponseDTO.of(new QueryDetectedObjectsResponseDTO(dtos));
    }

    @ApiEndpoint(
            value = "image/object/as-image",
            action = ApiEndpointAction.QUERY,
            produces = IMAGE_PNG)
    public BinaryResponseDTO detextTextsAsImages(
            @Nullable @Request(contentType = MediaTypeConst.IMAGE) BinaryRequestDTO request) {
        if (request == null) {
            throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
        }
        List<FileHolder> fileHolders = request.fileHolders();
        int size = fileHolders.size();
        if (0 == size) {
            throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
        }
        List<FileResource> resources = new ArrayList<>(size);
        for (int i = 0; i < size; i++) {
            try {
                FileHolder fileHolder = fileHolders.get(i);
                Path path = ocrService.ocrAndWriteToFile(fileHolder.file());
                FileResource resource = new FileResource(
                        "result-"
                                + (i + 1)
                                + ".png",
                        path,
                        t -> {
                            try {
                                Files.deleteIfExists(path);
                            } catch (IOException e) {
                                LOGGER.warn("Failed to delete the output image file: "
                                        + path, e);
                            }
                        });
                resources.add(resource);
            } catch (Exception e) {
                for (FileResource resource : resources) {
                    try {
                        resource.cleanup(e);
                    } catch (Exception ex) {
                        e.addSuppressed(new RuntimeException(
                                "Caught an error while cleaning up the resource",
                                ex));
                    }
                }
                throw ResponseException.get(ResponseStatusCode.SERVER_INTERNAL_ERROR, e);
            }
        }
        return BinaryResponseDTO.of(resources);
    }
}