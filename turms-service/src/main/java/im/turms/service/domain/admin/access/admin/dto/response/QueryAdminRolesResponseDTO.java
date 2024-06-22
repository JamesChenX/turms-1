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

package im.turms.service.domain.admin.access.admin.dto.response;

import java.util.ArrayList;
import java.util.List;

import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.domain.admin.po.AdminRole;
import im.turms.server.common.domain.common.access.dto.QueryRecordsResponseDTO;
import im.turms.server.common.infra.collection.CollectorUtil;

/**
 * @author James Chen
 */
public record QueryAdminRolesResponseDTO(
        long total,
        List<AdminRoleDTO> records
) implements QueryRecordsResponseDTO<AdminRoleDTO> {
    public static Mono<QueryAdminRolesResponseDTO> from(
            Mono<Long> count,
            Flux<AdminRole> adminRoleFlux) {
        return Mono.zip(count, adminRoleFlux.collect(CollectorUtil.toChunkedList()))
                .map(tuple -> {
                    List<AdminRole> adminRoles = tuple.getT2();
                    List<AdminRoleDTO> list = new ArrayList<>(adminRoles.size());
                    for (AdminRole adminRole : adminRoles) {
                        list.add(AdminRoleDTO.from(adminRole));
                    }
                    return new QueryAdminRolesResponseDTO(tuple.getT1(), list);
                });
    }
}