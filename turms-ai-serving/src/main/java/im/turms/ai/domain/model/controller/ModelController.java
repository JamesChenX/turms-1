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

package im.turms.ai.domain.model.controller;

import java.util.Collections;
import java.util.List;
import java.util.Set;
import jakarta.annotation.Nullable;

import ai.djl.repository.zoo.Criteria;
import org.springframework.context.ApplicationContext;

import im.turms.ai.domain.model.dto.request.QueryModelsRequestDTO;
import im.turms.ai.domain.model.dto.response.ModelDTO;
import im.turms.ai.domain.model.dto.response.QueryModelsResponseDTO;
import im.turms.ai.domain.model.service.ModelService;
import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_AI_SERVING_MODEL)
public class ModelController extends BaseApiController {

    private static final Criteria<?, ?> ALL = Criteria.builder()
            .build();

    private final ModelService modelService;

    public ModelController(ApplicationContext context, ModelService modelService) {
        super(context);
        this.modelService = modelService;
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY)
    public ResponseDTO<QueryModelsResponseDTO> queryModels(
            @Nullable QueryModelsRequestDTO request) {
        List<ModelDTO> models;
        if (request == null) {
            models = modelService.findModels(ALL, null);
        } else {
            if (request.hasFilter()) {
                Set<String> artifactIds = request.filter()
                        .ids();
                if (artifactIds == null) {
                    models = modelService.findModels(ALL, null, request.skip(), request.limit());
                } else if (artifactIds.isEmpty()) {
                    models = Collections.emptyList();
                } else {
                    int count = artifactIds.size();
                    if (count == 1) {
                        models = modelService.findModels(Criteria.builder()
                                .optArtifactId(artifactIds.iterator()
                                        .next())
                                .build(), null, request.skip(), request.limit());
                    } else {
                        models = modelService
                                .findModels(ALL, artifactIds, request.skip(), request.limit());
                    }
                }
            } else {
                models = modelService.findModels(ALL, null, request.skip(), request.limit());
            }
        }
        return ResponseDTO.of(QueryModelsResponseDTO.of(models));
    }
}