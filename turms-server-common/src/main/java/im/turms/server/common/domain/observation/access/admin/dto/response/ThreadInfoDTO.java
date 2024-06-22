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

package im.turms.server.common.domain.observation.access.admin.dto.response;

import java.lang.management.LockInfo;
import java.lang.management.MonitorInfo;
import java.lang.management.ThreadInfo;
import java.util.ArrayList;
import java.util.List;

/**
 * @author James Chen
 */
public record ThreadInfoDTO(
        String threadName,
        long threadId,
        long blockedTime,
        long blockedCount,
        long waitedTime,
        long waitedCount,
        LockInfoDTO lock,
        String lockName,
        long lockOwnerId,
        String lockOwnerName,
        boolean isDaemon,
        boolean inNative,
        boolean suspended,
        Thread.State threadState,
        int priority,
        List<StackTraceElementDTO> stackTraceElements,
        List<MonitorInfoDTO> lockedMonitors,
        List<LockInfoDTO> lockedSynchronizers
) {

    public static ThreadInfoDTO from(ThreadInfo threadInfo) {
        StackTraceElement[] stackTraceElements = threadInfo.getStackTrace();
        List<StackTraceElementDTO> stackTraceElementDTOs =
                new ArrayList<>(stackTraceElements.length);
        for (StackTraceElement stackTraceElement : stackTraceElements) {
            stackTraceElementDTOs.add(StackTraceElementDTO.from(stackTraceElement));
        }
        MonitorInfo[] monitorInfos = threadInfo.getLockedMonitors();
        List<MonitorInfoDTO> monitorInfoDTOs = new ArrayList<>(monitorInfos.length);
        for (MonitorInfo monitorInfo : monitorInfos) {
            monitorInfoDTOs.add(MonitorInfoDTO.from(monitorInfo));
        }
        LockInfo[] lockInfos = threadInfo.getLockedSynchronizers();
        List<LockInfoDTO> lockInfoDTOs = new ArrayList<>(lockInfos.length);
        for (LockInfo lockInfo : lockInfos) {
            lockInfoDTOs.add(LockInfoDTO.from(lockInfo));
        }
        return new ThreadInfoDTO(
                threadInfo.getThreadName(),
                threadInfo.getThreadId(),
                threadInfo.getBlockedTime(),
                threadInfo.getBlockedCount(),
                threadInfo.getWaitedTime(),
                threadInfo.getWaitedCount(),
                LockInfoDTO.from(threadInfo.getLockInfo()),
                threadInfo.getLockName(),
                threadInfo.getLockOwnerId(),
                threadInfo.getLockOwnerName(),
                threadInfo.isDaemon(),
                threadInfo.isInNative(),
                threadInfo.isSuspended(),
                threadInfo.getThreadState(),
                threadInfo.getPriority(),
                stackTraceElementDTOs,
                monitorInfoDTOs,
                lockInfoDTOs);
    }

}