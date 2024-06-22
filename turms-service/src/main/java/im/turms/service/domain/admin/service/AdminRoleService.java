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

package im.turms.service.domain.admin.service;

import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import org.apache.commons.lang3.tuple.Triple;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.admin.po.AdminRole;
import im.turms.server.common.domain.admin.service.BaseAdminRoleService;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.reactor.PublisherPool;
import im.turms.server.common.infra.recycler.Recyclable;
import im.turms.server.common.infra.recycler.SetRecycler;
import im.turms.server.common.infra.validation.NoWhitespace;
import im.turms.server.common.infra.validation.Validator;
import im.turms.server.common.storage.mongo.IMongoCollectionInitializer;
import im.turms.service.domain.admin.access.admin.dto.request.CreateAdminRolesRequestDTO;
import im.turms.service.domain.admin.repository.AdminRoleRepository;
import im.turms.service.storage.mongo.OperationResultPublisherPool;

import static im.turms.server.common.domain.admin.constant.AdminConst.ADMIN_ROLE_ROOT_ID;

/**
 * @author James Chen
 */
@Service
@DependsOn(IMongoCollectionInitializer.BEAN_NAME)
public class AdminRoleService extends BaseAdminRoleService {

    private static final int MIN_ROLE_NAME_LIMIT = 1;
    private static final int MAX_ROLE_NAME_LIMIT = 32;

    private static final String ERROR_UPDATE_ROLE_WITH_HIGHER_RANK =
            "Only a role with a lower rank compared to the one of the account can be created, updated, or deleted";
    private static final String ERROR_NO_PERMISSION = "The account does not have the permissions";

    private final Map<Long, AdminRole> idToRole = new ConcurrentHashMap<>(16);
    private final AdminRoleRepository adminRoleRepository;
    private final AdminUserService adminUserService;

    /**
     * @param adminUserService is lazy because: {@link AdminUserService} -> {@link AdminRoleService}
     *                         -> {@link AdminUserService}
     */
    public AdminRoleService(
            AdminRoleRepository adminRoleRepository,
            @Lazy AdminUserService adminUserService) {
        super(adminRoleRepository);
        this.adminRoleRepository = adminRoleRepository;
        this.adminUserService = adminUserService;
    }

    public Mono<AdminRole> authAndAddAdminRole(
            @NotNull String requesterAccount,
            @NotNull Long roleId,
            @NotNull @NoWhitespace @Size(
                    min = MIN_ROLE_NAME_LIMIT,
                    max = MAX_ROLE_NAME_LIMIT) String name,
            @NotEmpty Set<AdminPermission> permissions,
            @NotNull Integer rank) {
        try {
            Validator.notNull(roleId, "roleId");
            Validator.notNull(name, "name");
            Validator.noWhitespace(name, "name");
            Validator.length(name, "name", MIN_ROLE_NAME_LIMIT, MAX_ROLE_NAME_LIMIT);
            Validator.notEmpty(permissions, "permissions");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return isAccountRankHigherThanRank(requesterAccount, rank).flatMap(isHigher -> {
            if (isHigher) {
                return adminHasPermissions(requesterAccount, permissions)
                        .flatMap(hasPermissions -> hasPermissions
                                ? createAdminRole(roleId, name, permissions, rank)
                                : Mono.error(ResponseException.get(ResponseStatusCode.UNAUTHORIZED,
                                        ERROR_NO_PERMISSION)));
            }
            return Mono.error(ResponseException.get(ResponseStatusCode.UNAUTHORIZED,
                    ERROR_UPDATE_ROLE_WITH_HIGHER_RANK));
        });
    }

    public Mono<List<AdminRole>> authAndCreateAdminRoles(String adminUserAccount,
                                                         List<CreateAdminRolesRequestDTO.NewAdminRoleDTO> records) {
        request.id(),
                request.name(),
                request.permissions() == null
                        ? null
                        : AdminPermission.matchPermissions(request.permissions()),
                request.rank();

        request.id(),
                request.name(),
                request.permissions() == null
                        ? null
                        : AdminPermission.matchPermissions(request.permissions()),
                request.rank()
    }

    public Mono<AdminRole> createAdminRole(
            @NotNull Long roleId,
            @NotNull @NoWhitespace @Size(
                    min = MIN_ROLE_NAME_LIMIT,
                    max = MAX_ROLE_NAME_LIMIT) String name,
            @NotEmpty Set<AdminPermission> permissions,
            @NotNull Integer rank) {
        try {
            Validator.notNull(roleId, "roleId");
            Validator.notNull(name, "name");
            Validator.noWhitespace(name, "name");
            Validator.length(name, "name", MIN_ROLE_NAME_LIMIT, MAX_ROLE_NAME_LIMIT);
            Validator.notEmpty(permissions, "permissions");
            Validator.notNull(rank, "rank");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        if (roleId.equals(ADMIN_ROLE_ROOT_ID)) {
            return Mono.error(ResponseException.get(ResponseStatusCode.UNAUTHORIZED,
                    "The new role ID cannot be the root role ID"));
        }
        AdminRole adminRole = new AdminRole(roleId, name, permissions, rank, new Date());
        return adminRoleRepository.insert(adminRole)
                .then(Mono.fromCallable(() -> {
                    idToRole.put(adminRole.getId(), adminRole);
                    return adminRole;
                }));
    }

    public Mono<DeleteResult> authAndDeleteAdminRoles(
            @NotNull String requesterAccount,
            @Nullable Set<Long> roleIds) {
        if (CollectionUtil.isEmpty(roleIds)) {
            return Mono.just(DeleteResult.acknowledged(0));
        }
        return isAdminUserRankHigherThanRoles(requesterAccount, roleIds)
                .flatMap(isHigher -> isHigher
                        ? deleteAdminRoles(roleIds)
                        : Mono.error(ResponseException.get(ResponseStatusCode.UNAUTHORIZED,
                                ERROR_UPDATE_ROLE_WITH_HIGHER_RANK)));
    }

    public Mono<DeleteResult> deleteAdminRoles(@NotEmpty Set<Long> roleIds) {
        try {
            Validator.notEmpty(roleIds, "roleIds");
            Validator.notContains(roleIds,
                    ADMIN_ROLE_ROOT_ID,
                    "The root admin is reserved and cannot be deleted");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return adminRoleRepository.deleteByIds(roleIds)
                .map(result -> {
                    // Though the latest records will be synced in the watch callback,
                    // we still need to invalid dirty cache immediately, so the subsequent query
                    // won't get outdated records
                    for (Long id : roleIds) {
                        idToRole.remove(id);
                    }
                    return result;
                });
    }

    public Mono<UpdateResult> authAndUpdateAdminRoles(
            @NotNull String requesterAccount,
            @NotEmpty Set<Long> roleIds,
            @Nullable @NoWhitespace @Size(
                    min = MIN_ROLE_NAME_LIMIT,
                    max = MAX_ROLE_NAME_LIMIT) String name,
            @Nullable Set<AdminPermission> permissions,
            @Nullable Integer rank) {
        try {
            Validator.notEmpty(roleIds, "roleIds");
            Validator.noWhitespace(name, "name");
            Validator.length(name, "name", MIN_ROLE_NAME_LIMIT, MAX_ROLE_NAME_LIMIT);
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return isAdminUserRankHigherThanRoles(requesterAccount, roleIds).flatMap(isHigher -> {
            if (isHigher) {
                if (permissions == null) {
                    return updateAdminRoles(roleIds, name, null, rank);
                }
                return adminHasPermissions(requesterAccount, permissions)
                        .flatMap(hasPermissions -> hasPermissions
                                ? updateAdminRoles(roleIds, name, permissions, rank)
                                : Mono.error(ResponseException.get(ResponseStatusCode.UNAUTHORIZED,
                                        ERROR_NO_PERMISSION)));
            }
            return Mono.error(ResponseException.get(ResponseStatusCode.UNAUTHORIZED,
                    ERROR_UPDATE_ROLE_WITH_HIGHER_RANK));
        });
    }

    public Mono<UpdateResult> updateAdminRoles(
            @NotEmpty Set<Long> roleIds,
            @Nullable @NoWhitespace @Size(
                    min = MIN_ROLE_NAME_LIMIT,
                    max = MAX_ROLE_NAME_LIMIT) String newName,
            @Nullable Set<AdminPermission> permissions,
            @Nullable Integer rank) {
        try {
            Validator.notEmpty(roleIds, "roleIds");
            Validator.notContains(roleIds,
                    ADMIN_ROLE_ROOT_ID,
                    "The root admin is reserved and cannot be updated");
            Validator.noWhitespace(newName, "newName");
            Validator.length(newName, "newName", MIN_ROLE_NAME_LIMIT, MAX_ROLE_NAME_LIMIT);
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        if (Validator.areAllFalsy(newName, permissions, rank)) {
            return OperationResultPublisherPool.ACKNOWLEDGED_UPDATE_RESULT;
        }
        return adminRoleRepository.updateAdminRoles(roleIds, newName, permissions, rank)
                .doOnNext(updateResult -> {
                    // Though the latest records will be synced in the watch callback,
                    // we still need to invalid dirty cache immediately, so the subsequent query
                    // won't get outdated records
                    for (Long roleId : roleIds) {
                        idToRole.remove(roleId);
                    }
                });
    }

    public Flux<AdminRole> queryAdminRoles(
            @Nullable Set<Long> ids,
            @Nullable Set<String> names,
            @Nullable Set<AdminPermission> includedPermissions,
            @Nullable Set<Integer> ranks,
            @Nullable Integer skip,
            @Nullable Integer limit) {
        Flux<AdminRole> roleFlux = adminRoleRepository
                .findAdminRoles(ids, names, includedPermissions, ranks, skip, limit);
        if ((skip == null || skip < 1)
                && isRootAdminRoleMatched(ids, names, includedPermissions, ranks)) {
            Flux<AdminRole> adminRoleFlux = roleFlux.startWith(getRootRole());
            if (limit == null) {
                return adminRoleFlux;
            }
            return adminRoleFlux.take(limit);
        }
        return roleFlux;
    }

    public Mono<Long> countAdminRoles(
            @Nullable Set<Long> ids,
            @Nullable Set<String> names,
            @Nullable Set<AdminPermission> includedPermissions,
            @Nullable Set<Integer> ranks) {
        return adminRoleRepository.countAdminRoles(ids, names, includedPermissions, ranks)
                // Add 1 because of the builtin root role
                .map(number -> number + 1);
    }

    public Flux<Integer> queryRanksByAccounts(@NotEmpty Set<String> accounts) {
        try {
            Validator.notEmpty(accounts, "accounts");
        } catch (ResponseException e) {
            return Flux.error(e);
        }
        Recyclable<Set<Long>> recyclableSet = SetRecycler.obtain();
        return adminUserService.queryRoleIds(accounts)
                .collect(Collectors.toCollection(recyclableSet::getValue))
                .flatMapMany(this::queryRanksByRoles)
                .doFinally(signalType -> recyclableSet.recycle());
    }

    public Mono<Integer> queryRankByAccount(@NotNull String account) {
        try {
            Validator.notNull(account, "account");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return adminUserService.queryRoleId(account)
                .flatMap(this::queryRankByRole);
    }

    private Mono<Integer> queryHighestRank(@NotNull Collection<Long> roleIds) {
        try {
            Validator.notNull(roleIds, "roleIds");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        if (roleIds.contains(ADMIN_ROLE_ROOT_ID)) {
            return Mono.just(getRootRole().getRank());
        }
        return adminRoleRepository.findHighestRank(roleIds);
    }

    public Mono<Integer> queryRankByRole(@NotNull Long roleId) {
        try {
            Validator.notNull(roleId, "roleId");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        if (roleId.equals(ADMIN_ROLE_ROOT_ID)) {
            return Mono.just(getRootRole().getRank());
        }
        return adminRoleRepository.findRank(roleId);
    }

    public Flux<Integer> queryRanksByRoles(@NotEmpty Set<Long> roleIds) {
        try {
            Validator.notEmpty(roleIds, "roleIds");
        } catch (ResponseException e) {
            return Flux.error(e);
        }
        boolean containsRoot = roleIds.contains(ADMIN_ROLE_ROOT_ID);
        if (containsRoot && roleIds.size() == 1) {
            return Flux.just(getRootRole().getRank());
        }
        Flux<AdminRole> roleFlux = adminRoleRepository.findAdminRoles(roleIds);
        if (containsRoot) {
            roleFlux = roleFlux.startWith(getRootRole());
        }
        return roleFlux.map(AdminRole::getRank);
    }

    private Mono<Boolean> isAdminUserRankHigherThanRoles(
            @NotNull String account,
            @NotNull Collection<Long> roleIds) {
        return Mono.zip(queryRankByAccount(account), queryHighestRank(roleIds))
                .map(tuple -> tuple.getT1() > tuple.getT2())
                .defaultIfEmpty(false);
    }

    public Mono<Boolean> isAccountRankHigherThanRank(
            @NotNull String account,
            @NotNull Integer rank) {
        try {
            Validator.notNull(rank, "rank");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return queryRankByAccount(account).map(adminRank -> adminRank > rank)
                .defaultIfEmpty(false);
    }

    private Mono<Boolean> adminHasPermissions(
            @NotNull String account,
            @NotNull Set<AdminPermission> permissions) {
        try {
            Validator.notNull(account, "account");
            Validator.notNull(permissions, "permissions");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return permissions.isEmpty()
                ? PublisherPool.TRUE
                : queryPermissions(account)
                        .map(adminPermissions -> adminPermissions.containsAll(permissions))
                        .defaultIfEmpty(false);
    }

    /**
     * @return isAdminHigherThanAdmins, admin rank, admins ranks
     */
    public Mono<Triple<Boolean, Integer, Set<Integer>>> isAdminHigherThanAdmins(
            @NotNull String account,
            @NotEmpty Set<String> accounts) {
        try {
            Validator.notNull(account, "account");
            Validator.notEmpty(accounts, "accounts");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return queryRankByAccount(account).flatMap(rank -> {
            Recyclable<Set<Integer>> recyclableSet = SetRecycler.obtain();
            return queryRanksByAccounts(accounts)
                    .collect(Collectors.toCollection(recyclableSet::getValue))
                    .map(ranks -> {
                        for (int targetRank : ranks) {
                            if (targetRank >= rank) {
                                return Triple.of(false, rank, ranks);
                            }
                        }
                        return Triple.of(true, rank, ranks);
                    })
                    .doFinally(signalType -> recyclableSet.recycle());
        });
    }

    public Mono<AdminRole> queryAndCacheRole(@NotNull Long roleId) {
        try {
            Validator.notNull(roleId, "roleId");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return roleId.equals(ADMIN_ROLE_ROOT_ID)
                ? Mono.just(getRootRole())
                : adminRoleRepository.findById(roleId)
                        .doOnNext(role -> idToRole.put(roleId, role));
    }

    public Mono<Set<AdminPermission>> queryPermissions(@NotNull String account) {
        try {
            Validator.notNull(account, "account");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return adminUserService.queryRoleId(account)
                .flatMap(this::queryPermissions);
    }

    public Mono<Set<AdminPermission>> queryPermissions(@NotNull Long roleId) {
        try {
            Validator.notNull(roleId, "roleId");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        AdminRole role = idToRole.get(roleId);
        return role == null
                ? queryAndCacheRole(roleId).map(AdminRole::getPermissions)
                : Mono.just(role.getPermissions());
    }

    public Mono<Boolean> hasPermission(@NotNull Long roleId, @NotNull AdminPermission permission) {
        try {
            Validator.notNull(roleId, "roleId");
            Validator.notNull(permission, "permission");
        } catch (ResponseException e) {
            return Mono.error(e);
        }
        return queryPermissions(roleId).map(permissions -> permissions.contains(permission))
                .defaultIfEmpty(false);
    }

    private boolean isRootAdminRoleMatched(
            @Nullable Set<Long> ids,
            @Nullable Set<String> names,
            @Nullable Set<AdminPermission> includedPermissions,
            @Nullable Set<Integer> ranks) {
        AdminRole rootRole = getRootRole();
        if (ids != null && !ids.contains(rootRole.getId())) {
            return false;
        }
        if (names != null && !names.contains(rootRole.getName())) {
            return false;
        }
        if (includedPermissions != null
                && !includedPermissions.containsAll(rootRole.getPermissions())) {
            return false;
        }
        return ranks == null || ranks.contains(rootRole.getRank());
    }

}