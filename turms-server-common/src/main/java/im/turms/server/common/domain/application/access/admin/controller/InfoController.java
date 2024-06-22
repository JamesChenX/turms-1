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

package im.turms.server.common.domain.application.access.admin.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.application.access.admin.dto.response.QueryInfoResponseDTO;
import im.turms.server.common.infra.context.TurmsApplicationContext;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_APPLICATION_INFO)
public class InfoController extends BaseApiController {

    private final ResponseDTO<QueryInfoResponseDTO> info;

    public InfoController(ApplicationContext context, TurmsApplicationContext applicationContext) {
        super(context);
        info = new ResponseDTO<>(
                ResponseStatusCode.OK,
                new QueryInfoResponseDTO(applicationContext.getBuildProperties()));
    }

    @Operation(description = "Query the information of the server")
    @ApiEndpoint(action = ApiEndpointAction.QUERY)
    public ResponseDTO<QueryInfoResponseDTO> queryInfo() {
        return info;
    }
}