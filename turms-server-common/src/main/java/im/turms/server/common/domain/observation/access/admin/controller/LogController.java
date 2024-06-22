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

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Stream;
import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.BinaryResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.QueryLogsAsFilesRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.QueryLogPathsResponseDTO;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.io.FileResource;
import im.turms.server.common.infra.io.InputOutputException;
import im.turms.server.common.infra.logging.core.appender.Appender;
import im.turms.server.common.infra.logging.core.appender.file.RollingFileAppender;
import im.turms.server.common.infra.logging.core.logger.LoggerFactory;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_MONITOR_LOG)
public class LogController extends BaseApiController {

    private static final ResponseDTO<QueryLogPathsResponseDTO> QUERY_LOG_PATHS_RESPONSE_EMPTY =
            ResponseDTO.of(new QueryLogPathsResponseDTO(Collections.emptyList()));

    @Nullable
    private final Path logDir;
    private final boolean isLogDirAvailable;

    public LogController(ApplicationContext context) {
        super(context);
        RollingFileAppender appender = findFileAppender();
        if (appender == null) {
            logDir = null;
            isLogDirAvailable = false;
        } else {
            logDir = appender.getFileDirectory()
                    .normalize()
                    .toAbsolutePath();
            isLogDirAvailable = Files.exists(logDir);
        }
    }

    @ApiEndpoint(
            value = "as-file",
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.LOG_QUERY)
    public BinaryResponseDTO queryLogsAsFiles(@Nullable QueryLogsAsFilesRequestDTO request) {
        if (!isLogDirAvailable) {
            throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
        }
        if (request == null || !request.hasFilter()) {
            return findAllLogs();
        }
        QueryLogsAsFilesRequestDTO.FilterDTO filter = request.filter();
        Set<String> paths = filter.paths();
        if (paths == null) {
            return findAllLogs();
        } else if (paths.isEmpty()) {
            throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
        }
        List<FileResource> resources = new ArrayList<>(paths.size());
        for (String path : paths) {
            Path logFilePath = Path.of(path);
            logFilePath = logDir.resolve(logFilePath)
                    .normalize();
            if (logFilePath.startsWith(logDir) && Files.exists(logFilePath)) {
                resources.add(new FileResource(
                        logFilePath.getFileName()
                                .toString(),
                        logFilePath));
            }
        }
        return BinaryResponseDTO.of(resources);
    }

    @ApiEndpoint(
            value = "path",
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.LOG_QUERY)
    public ResponseDTO<QueryLogPathsResponseDTO> getLogPaths() {
        if (!isLogDirAvailable) {
            return QUERY_LOG_PATHS_RESPONSE_EMPTY;
        }
        try (Stream<String> logFiles = getLogFilePathStream().map(path -> path.getFileName()
                .toString())) {
            return ResponseDTO.of(QueryLogPathsResponseDTO.from(logFiles.toList()));
        } catch (IOException e) {
            throw new InputOutputException("Failed to list log files", e);
        }
    }

    private Stream<Path> getLogFilePathStream() throws IOException {
        return Files.list(logDir)
                .filter(filePath -> !Files.isDirectory(filePath));
    }

    private BinaryResponseDTO findAllLogs() {
        // TODO: limit number
        try (Stream<FileResource> stream = getLogFilePathStream().map(path -> new FileResource(
                path.getFileName()
                        .toString(),
                path))) {
            return BinaryResponseDTO.of(stream.toList());
        } catch (IOException e) {
            throw ResponseException.get(ResponseStatusCode.SERVER_INTERNAL_ERROR,
                    "Failed to get the log files",
                    e);
        }
    }

    @Nullable
    private RollingFileAppender findFileAppender() {
        List<Appender> appenders = LoggerFactory.getDefaultAppenders();
        for (Appender appender : appenders) {
            if (appender instanceof RollingFileAppender fileAppender) {
                // We use the same dir for log files,
                // so we just need to find the first dir.
                return fileAppender;
            }
        }
        return null;
    }
}