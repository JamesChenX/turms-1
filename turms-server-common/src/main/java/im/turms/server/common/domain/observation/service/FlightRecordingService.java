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

package im.turms.server.common.domain.observation.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.atomic.AtomicLong;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.Min;

import jdk.jfr.Configuration;
import jdk.jfr.FlightRecorder;
import jdk.jfr.Recording;
import org.jctools.maps.NonBlockingHashMapLong;
import org.jctools.queues.MpscUnboundedArrayQueue;
import org.springframework.stereotype.Service;

import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.NewRecordingDTO;
import im.turms.server.common.domain.observation.model.RecordingSession;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.context.TurmsApplicationContext;
import im.turms.server.common.infra.exception.IncompatibleJvmException;
import im.turms.server.common.infra.exception.WriteRecordsException;
import im.turms.server.common.infra.io.FileResource;
import im.turms.server.common.infra.io.FileUtil;
import im.turms.server.common.infra.io.InputOutputException;
import im.turms.server.common.infra.logging.core.logger.Logger;
import im.turms.server.common.infra.logging.core.logger.LoggerFactory;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.server.common.infra.property.env.common.FlightRecorderProperties;
import im.turms.server.common.infra.task.CronConst;
import im.turms.server.common.infra.task.TaskManager;
import im.turms.server.common.infra.validation.Validator;

/**
 * @author James Chen
 */
@Service
public class FlightRecordingService {

    private static final Logger LOGGER = LoggerFactory.getLogger(FlightRecordingService.class);
    private static final Path JFR_DIR = Path.of("jfr");
    private static final AtomicLong TEMP_FLIGHT_RECORDING_FILE_ID = new AtomicLong(0);

    private final Path jfrDir;
    private final Map<String, String> defaultConfigs;
    private final int closedRecordingRetentionPeriod;

    /**
     * Includes not deleted recording sessions
     */
    private final NonBlockingHashMapLong<RecordingSession> idToSession =
            new NonBlockingHashMapLong<>(16);
    private final MpscUnboundedArrayQueue<Long> closedNotDeletedSessionIds;

    public FlightRecordingService(
            TurmsApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            TaskManager taskManager) {
        if (!FlightRecorder.isAvailable()) {
            throw new IncompatibleJvmException("The flight recorder is unavailable");
        }
        Map<String, String> localDefaultConfigs = null;
        for (Configuration config : Configuration.getConfigurations()) {
            if (config.getName()
                    .equals("default")) {
                localDefaultConfigs = config.getSettings();
                break;
            }
        }
        if (localDefaultConfigs == null) {
            throw new IncompatibleJvmException("No default flight recorder configuration found");
        } else {
            defaultConfigs = localDefaultConfigs;
        }
        jfrDir = context.getHome()
                .resolve("./jfr");
        createJfrDir();
        for (Recording recording : FlightRecorder.getFlightRecorder()
                .getRecordings()) {
            long id = recording.getId();
            idToSession.put(id, new RecordingSession(id, recording, null));
        }
        FlightRecorderProperties recorderProperties = propertiesManager.getLocalProperties()
                .getFlightRecorder();
        closedRecordingRetentionPeriod = recorderProperties.getClosedRecordingRetentionPeriod();
        if (closedRecordingRetentionPeriod <= 0) {
            closedNotDeletedSessionIds = null;
            return;
        }
        closedNotDeletedSessionIds = new MpscUnboundedArrayQueue<>(16);
        taskManager.reschedule("closedRecordingCleanup",
                CronConst.CLOSED_RECORDINGS_CLEANUP_CRON,
                () -> {
                    List<Long> pendingSessionIds = null;
                    Long sessionId;
                    while ((sessionId = closedNotDeletedSessionIds.relaxedPoll()) != null) {
                        RecordingSession session = idToSession.remove(sessionId);
                        if (session == null) {
                            continue;
                        }
                        try {
                            session.deleteFile();
                        } catch (Exception e) {
                            // The file may be in use
                            LOGGER.error("Failed to delete the recording file of the session: {}",
                                    sessionId,
                                    e);
                            if (session.checkIfFileExists()) {
                                if (pendingSessionIds == null) {
                                    pendingSessionIds = new ArrayList<>();
                                }
                                pendingSessionIds.add(sessionId);
                                idToSession.put(sessionId, session);
                            }
                        }
                    }
                    if (pendingSessionIds != null) {
                        closedNotDeletedSessionIds.addAll(pendingSessionIds);
                    }
                });
    }

    private void createJfrDir() {
        try {
            Files.createDirectories(jfrDir);
        } catch (IOException e) {
            throw new InputOutputException(
                    "Failed to create the JFR directory: "
                            + jfrDir.normalize(),
                    e);
        }
    }

    public List<RecordingSession> startRecordings(@Nullable List<NewRecordingDTO> newRecordings) {
        int count = CollectionUtil.getSize(newRecordings);
        if (count == 0) {
            return Collections.emptyList();
        }
        for (int i = 0; i < count; i++) {
            NewRecordingDTO recording = newRecordings.get(i);
            try {
                validateCreateRecordingParams(recording.duration(),
                        recording.maxAge(),
                        recording.maxSize(),
                        recording.delay());
            } catch (Exception e) {
                throw new WriteRecordsException(i, e);
            }
        }
        List<RecordingSession> newSessions = new ArrayList<>(count);
        for (int i = 0; i < count; i++) {
            NewRecordingDTO recording = newRecordings.get(i);
            RecordingSession session;
            try {
                session = startRecording0(recording.duration(),
                        recording.maxAge(),
                        recording.maxSize(),
                        recording.delay(),
                        recording.settings(),
                        recording.description());
            } catch (Exception e) {
                throw new WriteRecordsException(i, e);
            }
            newSessions.add(session);
        }
        return newSessions;
    }

    public RecordingSession startRecording(
            @Nullable @Min(0) Long duration,
            @Nullable @Min(0) Long maxAge,
            @Nullable @Min(0) Long maxSize,
            @Nullable @Min(0) Long delay,
            @Nullable Map<String, String> customSettings,
            @Nullable String description) {
        validateCreateRecordingParams(duration, maxAge, maxSize, delay);
        return startRecording0(duration, maxAge, maxSize, delay, customSettings, description);
    }

    private RecordingSession startRecording0(
            @Nullable Long duration,
            @Nullable Long maxAge,
            @Nullable Long maxSize,
            @Nullable Long delay,
            @Nullable Map<String, String> customSettings,
            @Nullable String description) {
        if (customSettings == null || customSettings.isEmpty()) {
            customSettings = defaultConfigs;
        } else {
            customSettings.putAll(defaultConfigs);
        }
        Recording recording = new Recording(customSettings);
        long id = recording.getId();
        String name = "custom-"
                + id
                + ".jfr";
        recording.setName(name);

        // Ensure the directory exists because it may be deleted by users unexpectedly
        createJfrDir();
        Path tempFile = jfrDir.resolve(name);
        try {
            Files.createFile(tempFile);
        } catch (IOException e) {
            throw new InputOutputException(
                    "Failed to create the JFR file: "
                            + tempFile,
                    e);
        }
        try {
            recording.setDestination(tempFile);
            recording.setToDisk(true);
            if (duration != null) {
                recording.setDuration(Duration.of(duration, ChronoUnit.MILLIS));
            }
            if (maxAge != null) {
                recording.setMaxAge(Duration.of(maxAge, ChronoUnit.MILLIS));
            }
            if (maxSize != null) {
                recording.setMaxSize(maxSize);
            }
            if (delay == null) {
                recording.start();
            } else {
                recording.scheduleStart(Duration.of(delay, ChronoUnit.MILLIS));
            }
            RecordingSession session = new RecordingSession(id, recording, description);
            idToSession.put(id, session);
            return session;
        } catch (Exception e) {
            try {
                recording.close();
            } catch (Exception ignored) {
                // ignore
            }
            try {
                Files.deleteIfExists(tempFile);
            } catch (IOException ex) {
                e.addSuppressed(ex);
            }
            throw new RuntimeException("Failed to start a recording", e);
        }
    }

    private void validateCreateRecordingParams(
            @Nullable Long duration,
            @Nullable Long maxAge,
            @Nullable Long maxSize,
            @Nullable Long delay) {
        Validator.min(duration, "duration", 0);
        Validator.min(maxAge, "maxAge", 0);
        Validator.min(maxSize, "maxSize", 0);
        Validator.min(delay, "delay", 0);
    }

    public UpdateResultDTO closeRecordings() {
        long matchedCount = 0;
        long modifiedCount = 0;
        for (RecordingSession session : idToSession.values()) {
            matchedCount++;
            if (session.isRunning()) {
                closeSession(session);
                modifiedCount++;
            }
        }
        return new UpdateResultDTO(matchedCount, modifiedCount);
    }

    public UpdateResultDTO closeRecordings(Set<Long> ids) {
        long matchedCount = 0;
        long modifiedCount = 0;
        for (Long id : ids) {
            RecordingSession session = idToSession.get(id);
            if (session == null) {
                continue;
            }
            matchedCount++;
            if (session.isRunning()) {
                closeSession(session);
                modifiedCount++;
            }
        }
        return new UpdateResultDTO(matchedCount, modifiedCount);
    }

    public void closeRecording(Long id) {
        RecordingSession session = idToSession.get(id);
        if (session == null) {
            return;
        }
        if (session.isRunning()) {
            closeSession(session);
        }
    }

    public List<FileResource> getRecordingFiles() {
        Collection<RecordingSession> sessions = idToSession.values();
        if (sessions.isEmpty()) {
            return Collections.emptyList();
        }
        List<FileResource> resources = new ArrayList<>(sessions.size());
        for (RecordingSession session : sessions) {
            try {
                if (session.canBeDumped()) {
                    FileResource resource = dump(session);
                    resources.add(resource);
                }
            } catch (Exception e) {
                for (FileResource resource : resources) {
                    try {
                        resource.cleanup(null);
                    } catch (Exception ex) {
                        e.addSuppressed(new RuntimeException(
                                "Caught an error when cleaning up the file resource: "
                                        + resource.getFile(),
                                ex));
                    }
                }
                throw e;
            }
        }
        return resources;
    }

    public List<FileResource> getRecordingFiles(Collection<Long> ids) {
        Validator.notNull(ids, "ids");
        if (ids.isEmpty()) {
            return Collections.emptyList();
        }
        List<RecordingSession> sessions = new ArrayList<>(ids.size());
        for (Long id : ids) {
            RecordingSession session = idToSession.get(id);
            if (session == null) {
                continue;
            }
            session.throwIfCannotBeDumped();
            sessions.add(session);
        }
        List<FileResource> resources = new ArrayList<>(sessions.size());
        for (RecordingSession session : sessions) {
            try {
                resources.add(dump(session));
            } catch (Exception e) {
                for (FileResource resource : resources) {
                    try {
                        resource.cleanup(null);
                    } catch (Exception ex) {
                        e.addSuppressed(new RuntimeException(
                                "Caught an error when cleaning up the file resource: "
                                        + resource.getFile(),
                                ex));
                    }
                }
                throw e;
            }
        }
        return resources;
    }

    @Nullable
    public FileResource getRecordingFile(Long id, boolean close) {
        RecordingSession session = idToSession.get(id);
        if (session == null) {
            return null;
        }
        String fileName = id
                + ".jfr";
        if (close) {
            session.close(true);
            return new FileResource(fileName, session.getFilePath(), throwable -> {
                if (throwable == null) {
                    closeRecording(id);
                } else {
                    LOGGER.error("Failed to close the recording session: {}", id, throwable);
                }
            });
        }
        session.throwIfCannotBeDumped();
        return dump(session);
    }

    private FileResource dump(RecordingSession session) {
        Long id = session.id();
        String fileName = id
                + ".jfr";
        String name = id
                + "-"
                + TEMP_FLIGHT_RECORDING_FILE_ID.getAndIncrement()
                + ".jfr";
        Path tempFile = FileUtil.createTempFile(JFR_DIR, name);
        try {
            Path filePath = session.getFilePath(tempFile);
            return new FileResource(fileName, filePath);
        } catch (Exception e) {
            try {
                Files.deleteIfExists(tempFile);
            } catch (IOException ex) {
                e.addSuppressed(new InputOutputException(
                        "Caught an error when deleting the temp file: "
                                + tempFile,
                        ex));
            }
            throw e;
        }
    }

    public int deleteRecordings() {
        int deletedCount = 0;
        Iterator<RecordingSession> iterator = idToSession.values()
                .iterator();
        while (iterator.hasNext()) {
            RecordingSession session = iterator.next();
            session.close(false);
            deletedCount++;
            iterator.remove();
        }
        return deletedCount;
    }

    public int deleteRecordings(Set<Long> ids) {
        int deletedCount = 0;
        for (Long id : ids) {
            RecordingSession session = idToSession.remove(id);
            if (session == null) {
                continue;
            }
            session.close(false);
            deletedCount++;
        }
        return deletedCount;
    }

    public Collection<RecordingSession> getSessions() {
        return idToSession.values();
    }

    public List<RecordingSession> getSessions(Set<Long> ids) {
        if (ids.isEmpty()) {
            return Collections.emptyList();
        }
        List<RecordingSession> sessions = new ArrayList<>(ids.size());
        for (Long id : ids) {
            RecordingSession session = idToSession.get(id);
            if (session != null) {
                sessions.add(session);
            }
        }
        return sessions;
    }

    private void closeSession(RecordingSession session) {
        if (closedRecordingRetentionPeriod > 0) {
            session.close(true);
            closedNotDeletedSessionIds.offer(session.id());
        } else if (closedRecordingRetentionPeriod == 0) {
            session.close(false);
            idToSession.remove(session.id(), session);
        } else {
            session.close(true);
        }
    }
}