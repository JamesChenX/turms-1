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

package im.turms.server.common.domain.observation.access.admin.controller;

import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.domain.common.access.dto.BinaryResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.QueryHeapDumpRequestDTO;
import im.turms.server.common.domain.observation.service.HeapDumpService;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_MONITOR_HEAP)
public class HeapController extends BaseApiController {

    private final HeapDumpService heapDumpService;

    public HeapController(ApplicationContext context, HeapDumpService heapDumpService) {
        super(context);
        this.heapDumpService = heapDumpService;
    }

    @ApiEndpoint(value = "as-heap-dump-file", action = ApiEndpointAction.QUERY)
    public BinaryResponseDTO queryHeapDump(@Nullable QueryHeapDumpRequestDTO request) {
        boolean queryLiveObjectsOnly = request != null
                && request.hasFilter()
                && request.filter()
                        .liveness() == QueryHeapDumpRequestDTO.FilterDTO.Liveness.LIVE;
        return BinaryResponseDTO.of(heapDumpService.generateHeapDump(queryLiveObjectsOnly));
    }
}