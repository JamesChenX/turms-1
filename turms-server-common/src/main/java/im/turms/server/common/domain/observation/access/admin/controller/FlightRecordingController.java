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

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.HttpResponseException;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.BinaryResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.CreateFlightRecordingsRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.DeleteFlightRecordingsRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.QueryFlightRecordingsAsFilesRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.QueryFlightRecordingsRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.UpdateFlightRecordingsRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.CreateFlightRecordingsResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.QueryFlightRecordingsResponseDTO;
import im.turms.server.common.domain.observation.exception.DumpIllegalStateException;
import im.turms.server.common.domain.observation.model.RecordingSession;
import im.turms.server.common.domain.observation.service.FlightRecordingService;
import im.turms.server.common.infra.io.FileResource;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_MONITOR_FLIGHT_RECORDING)
public class FlightRecordingController extends BaseApiController {

    public static final Comparator<RecordingSession> RECORDING_SESSION_COMPARATOR =
            (o1, o2) -> Long.compare(o2.id(), o1.id());
    private final FlightRecordingService flightRecordingService;

    public FlightRecordingController(
            ApplicationContext context,
            FlightRecordingService flightRecordingService) {
        super(context);
        this.flightRecordingService = flightRecordingService;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.FLIGHT_RECORDING_QUERY)
    public ResponseDTO<QueryFlightRecordingsResponseDTO> queryFlightRecordings(
            @Nullable QueryFlightRecordingsRequestDTO request) {
        List<RecordingSession> sessions;
        if (request == null) {
            sessions = new ArrayList<>(flightRecordingService.getSessions());
            sessions.sort(RECORDING_SESSION_COMPARATOR);
        } else {
            if (request.hasFilter()) {
                LinkedHashSet<Long> ids = request.filter()
                        .ids();
                if (ids == null) {
                    sessions = new ArrayList<>(flightRecordingService.getSessions());
                } else {
                    sessions = flightRecordingService.getSessions(ids);
                }
            } else {
                sessions = new ArrayList<>(flightRecordingService.getSessions());
            }
            sessions.sort(RECORDING_SESSION_COMPARATOR);
            sessions = applySkipAndLimit(request, sessions);
        }
        return ResponseDTO.of(QueryFlightRecordingsResponseDTO.from(sessions));
    }

    @ApiEndpoint(
            action = ApiEndpointAction.CREATE,
            requiredPermissions = AdminPermission.FLIGHT_RECORDING_CREATE)
    public ResponseDTO<CreateFlightRecordingsResponseDTO> startFlightRecording(
            CreateFlightRecordingsRequestDTO request) {
        List<RecordingSession> sessions = flightRecordingService.startRecordings(request.records());
        return ResponseDTO.of(CreateFlightRecordingsResponseDTO.from(sessions));
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = AdminPermission.FLIGHT_RECORDING_DELETE)
    public ResponseDTO<DeleteResultDTO> deleteRecordings(DeleteFlightRecordingsRequestDTO request) {
        int deletedCount = request.hasFilter()
                ? flightRecordingService.deleteRecordings(request.filter()
                        .ids())
                : flightRecordingService.deleteRecordings();
        return ResponseDTO.deleteResult(deletedCount);
    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = AdminPermission.FLIGHT_RECORDING_UPDATE)
    public ResponseDTO<UpdateResultDTO> closeRecordings(UpdateFlightRecordingsRequestDTO request) {
        UpdateResultDTO result;
        if (request.hasFilter()) {
            Set<Long> ids = request.filter()
                    .ids();
            result = ids == null
                    ? flightRecordingService.closeRecordings()
                    : flightRecordingService.closeRecordings(ids);
        } else {
            result = flightRecordingService.closeRecordings();
        }
        return ResponseDTO.of(result);
    }

    @ApiEndpoint(
            value = "as-file",
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.FLIGHT_RECORDING_QUERY)
    public BinaryResponseDTO queryFlightRecordingsAsFiles(
            @Nullable QueryFlightRecordingsAsFilesRequestDTO request) {
        List<FileResource> resources;
        try {
            if (request == null) {
                resources = flightRecordingService.getRecordingFiles();
            } else {
                if (request.hasFilter()) {
                    LinkedHashSet<Long> ids = request.filter()
                            .ids();
                    if (ids == null) {
                        resources = flightRecordingService.getRecordingFiles();
                    } else {
                        resources = flightRecordingService.getRecordingFiles(ids);
                    }
                } else {
                    resources = flightRecordingService.getRecordingFiles();
                }
                resources = applySkipAndLimit(request, resources);
            }
        } catch (DumpIllegalStateException e) {
            throw new HttpResponseException(ResponseStatusCode.DUMP_JFR_IN_ILLEGAL_STATUS, e);
        }
        return BinaryResponseDTO.of(resources);
    }

}