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

package im.turms.service.domain.cluster.access.admin.dto.response;

import java.util.Date;
import jakarta.annotation.Nullable;

import im.turms.server.common.infra.cluster.node.NodeType;
import im.turms.server.common.infra.cluster.service.config.entity.discovery.Member;

/**
 * @author James Chen
 */
public record MemberDTO(
        String clusterId,
        String nodeId,
        String zone,
        String name,
        String nodeVersion,
        NodeType nodeType,
        Boolean isSeed,
        Date registrationDate,
        Boolean leaderEligible,
        Integer priority,
        String memberHost,
        Integer memberPort,
        @Nullable String adminApiAddress,
        @Nullable String wsAddress,
        @Nullable String tcpAddress,
        @Nullable String udpAddress,
        MemberStatusDTO status
) {

    public static MemberDTO from(Member member) {
        Member.MemberStatus status = member.getStatus();
        return new MemberDTO(
                member.getClusterId(),
                member.getNodeId(),
                member.getZone(),
                member.getName(),
                member.getNodeVersion()
                        .toString(),
                member.getNodeType(),
                member.isSeed(),
                member.getRegistrationDate(),
                member.isLeaderEligible(),
                member.getPriority(),
                member.getMemberHost(),
                member.getMemberPort(),
                member.getAdminApiAddress(),
                member.getWsAddress(),
                member.getTcpAddress(),
                member.getUdpAddress(),
                new MemberStatusDTO(
                        status.hasJoinedCluster(),
                        status.isHealthy(),
                        status.isActive(),
                        status.getLastHeartbeatDate()));
    }

    public record MemberStatusDTO(
            boolean hasJoinedCluster,
            boolean healthy,
            boolean active,
            Date lastHeartbeatDate
    ) {
    }

}