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

import jakarta.annotation.Nullable;

import org.springframework.context.ConfigurableApplicationContext;
import reactor.core.scheduler.Schedulers;

import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.domain.application.access.admin.dto.request.UpdateApplicationStatusRequestDTO;

/**
 * @author James Chen
 */
@ApiController("application/status")
public class StatusController extends BaseApiController {

    private final ConfigurableApplicationContext context;

    public StatusController(ConfigurableApplicationContext context) {
        super(context);
        this.context = context;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = AdminPermission.APPLICATION_STATUS)
    public ResponseDTO<UpdateResultDTO> updateStatus(
            @Nullable UpdateApplicationStatusRequestDTO request) {
        if (request == null) {
            return ResponseDTO.UPDATE_RESULT_0;
        }
        UpdateApplicationStatusRequestDTO.UpdateDTO update = request.update();
        if (update == null) {
            return ResponseDTO.UPDATE_RESULT_0;
        }
        UpdateApplicationStatusRequestDTO.Status status = update.status();
        if (status == null) {
            return ResponseDTO.UPDATE_RESULT_0;
        }
        return switch (status) {
            case STOPPED -> {
                Schedulers.boundedElastic()
                        .schedule(context::stop);
                yield ResponseDTO.UPDATE_RESULT_1;
            }
        };
    }

}