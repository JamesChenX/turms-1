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

package im.turms.service.domain.cluster.access.admin.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashSet;
import java.util.List;
import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.annotation.QueryParam;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.infra.cluster.node.Node;
import im.turms.server.common.infra.cluster.node.NodeVersion;
import im.turms.server.common.infra.cluster.service.config.entity.discovery.Leader;
import im.turms.server.common.infra.cluster.service.config.entity.discovery.Member;
import im.turms.server.common.infra.cluster.service.discovery.DiscoveryService;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.cluster.access.admin.dto.request.AddMembersRequestDTO;
import im.turms.service.domain.cluster.access.admin.dto.request.NewMemberDTO;
import im.turms.service.domain.cluster.access.admin.dto.request.QueryMembersRequestDTO;
import im.turms.service.domain.cluster.access.admin.dto.request.RemoveMembersRequestDTO;
import im.turms.service.domain.cluster.access.admin.dto.request.UpdateMembersRequestDTO;
import im.turms.service.domain.cluster.access.admin.dto.response.AddMembersResponseDTO;
import im.turms.service.domain.cluster.access.admin.dto.response.QueryMembersResponseDTO;
import im.turms.service.domain.common.access.admin.controller.BaseController;

import static im.turms.server.common.access.admin.permission.AdminPermission.CLUSTER_LEADER_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLUSTER_LEADER_UPDATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLUSTER_MEMBER_CREATE;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLUSTER_MEMBER_DELETE;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLUSTER_MEMBER_QUERY;
import static im.turms.server.common.access.admin.permission.AdminPermission.CLUSTER_MEMBER_UPDATE;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_SERVICE_CLUSTER_MEMBER)
public class MemberController extends BaseController {

    private final DiscoveryService discoveryService;

    public MemberController(
            Node node,
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager) {
        super(context, propertiesManager);
        discoveryService = node.getDiscoveryService();
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY, requiredPermissions = CLUSTER_MEMBER_QUERY)
    public ResponseDTO<QueryMembersResponseDTO> queryMembers(
            @Nullable QueryMembersRequestDTO request) {
        if (request == null || !request.hasFilter()) {
            return ResponseDTO.of(QueryMembersResponseDTO.of(discoveryService.getAllKnownMembers()
                    .values()));
        }
        return ResponseDTO.of(QueryMembersResponseDTO.of(discoveryService.findMembers(
                request.filter()
                        .ids(),
                request.filter()
                        .role(),
                request.skip(),
                request.limit())));
    }

    @ApiEndpoint(action = ApiEndpointAction.DELETE, requiredPermissions = CLUSTER_MEMBER_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> removeMembers(RemoveMembersRequestDTO request) {
        Mono<Long> unregisterMembers;
        if (request.deleteAll()) {
            unregisterMembers = discoveryService.unregisterMembers();
        } else {
            LinkedHashSet<String> ids = request.filter()
                    .ids();
            if (ids.isEmpty()) {
                return ResponseDTO.deleteResult0Mono();
            }
            unregisterMembers = discoveryService.unregisterMembers(ids);
        }
        return ResponseDTO.deleteResultFromLongMono(unregisterMembers);
    }

    @ApiEndpoint(action = ApiEndpointAction.CREATE, requiredPermissions = CLUSTER_MEMBER_CREATE)
    public Mono<ResponseDTO<AddMembersResponseDTO>> addMembers(AddMembersRequestDTO request) {
        String clusterId = discoveryService.getLocalMember()
                .getClusterId();
        List<NewMemberDTO> newMembers = request.records();
        List<Member> members = new ArrayList<>(newMembers.size());
        for (NewMemberDTO newMember : newMembers) {
            Date registrationDate = newMember.registrationDate();
            Member member = new Member(
                    clusterId,
                    newMember.nodeId(),
                    newMember.zone(),
                    newMember.name(),
                    newMember.nodeType(),
                    NodeVersion.parse(newMember.version()),
                    newMember.isSeed(),
                    newMember.isLeaderEligible(),
                    registrationDate == null
                            ? new Date()
                            : registrationDate,
                    newMember.priority(),
                    newMember.memberHost(),
                    newMember.memberPort(),
                    newMember.adminApiAddress(),
                    newMember.wsAddress(),
                    newMember.tcpAddress(),
                    newMember.udpAddress(),
                    false,
                    newMember.isActive(),
                    newMember.isHealthy());
            members.add(member);
        }
        return discoveryService.registerMembers(members)
                .then(Mono.fromCallable(() -> ResponseDTO.of(AddMembersResponseDTO.of(members))));
    }

    @ApiEndpoint(action = ApiEndpointAction.UPDATE, requiredPermissions = CLUSTER_MEMBER_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updateMembers(UpdateMembersRequestDTO request) {
        UpdateMembersRequestDTO.UpdateMemberDTO update = request.update();
        if (update == null) {
            return ResponseDTO.updateResult0Mono();
        }
        Mono<Long> updateMembers = discoveryService.updateMembersInfo(request.hasFilter()
                ? request.filter()
                        .ids()
                : null,
                update.zone(),
                update.name(),
                update.isSeed(),
                update.isLeaderEligible(),
                update.isActive(),
                update.priority());
        return ResponseDTO.updateResultFromLongMono(updateMembers);
    }

    // Leader

    @ApiEndpoint(
            value = "leader",
            action = ApiEndpointAction.QUERY,
            requiredPermissions = CLUSTER_LEADER_QUERY)
    public ResponseDTO<Member> queryLeader() {
        Leader leader = discoveryService.getLeader();
        if (leader == null) {
            throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
        }
        String nodeId = leader.getNodeId();
        Member member = discoveryService.getAllKnownMembers()
                .get(nodeId);
        return HttpHandlerResult.okIfTruthy(member);
    }

    @ApiEndpoint(
            value = "leader",
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = CLUSTER_LEADER_UPDATE)
    public Mono<ResponseDTO<Member>> electNewLeader(@QueryParam(required = false) String id) {
        Mono<Member> leader = id == null
                ? discoveryService.electNewLeaderByPriority()
                : discoveryService.electNewLeaderByNodeId(id);
        return HttpHandlerResult.okIfTruthy(leader);
    }

}