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

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadInfo;
import java.lang.management.ThreadMXBean;

import io.netty.buffer.ByteBuf;
import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.QueryThreadDumpsResponseDTO;
import im.turms.server.common.infra.thread.ThreadDumpFormatter;

import static im.turms.server.common.infra.http.MediaTypeConst.TEXT_PLAIN_UTF_8;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_MONITOR_THREAD)
public class ThreadController extends BaseApiController {

    private final ThreadMXBean threadBean;

    public ThreadController(ApplicationContext context) {
        super(context);
        threadBean = ManagementFactory.getThreadMXBean();
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY)
    public ResponseDTO<QueryThreadDumpsResponseDTO> queryThreadDumps() {
        ThreadInfo[] threadInfos = threadBean.dumpAllThreads(true, true);
        return ResponseDTO.of(QueryThreadDumpsResponseDTO.of(threadInfos));
    }

    @ApiEndpoint(
            value = "as-plain-text",
            action = ApiEndpointAction.QUERY,
            produces = TEXT_PLAIN_UTF_8)
    public ByteBuf queryThreadDumpsAsPlainText() {
        ThreadInfo[] threadInfos = threadBean.dumpAllThreads(true, true);
        return ThreadDumpFormatter.format(threadInfos);
    }

}