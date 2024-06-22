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

package im.turms.service.domain.admin.repository;

import java.util.Set;
import jakarta.annotation.Nullable;

import com.mongodb.client.result.UpdateResult;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import im.turms.server.common.domain.admin.po.AdminUser;
import im.turms.server.common.domain.common.repository.BaseRepository;
import im.turms.server.common.storage.mongo.DomainFieldName;
import im.turms.server.common.storage.mongo.TurmsMongoClient;
import im.turms.server.common.storage.mongo.operation.option.Filter;
import im.turms.server.common.storage.mongo.operation.option.QueryOptions;
import im.turms.server.common.storage.mongo.operation.option.Update;

/**
 * @author James Chen
 */
@Repository
public class AdminUserRepository extends BaseRepository<AdminUser, String> {

    public AdminUserRepository(@Qualifier("adminMongoClient") TurmsMongoClient mongoClient) {
        super(mongoClient, AdminUser.class);
        this.mongoClient = mongoClient;
    }

    public Mono<UpdateResult> updateAdminUsers(
            Set<String> targetAccounts,
            @Nullable byte[] password,
            @Nullable String name,
            @Nullable Long roleId) {
        Filter filter = Filter.newBuilder(1)
                .in(DomainFieldName.ID, targetAccounts);
        Update update = Update.newBuilder(3)
                .setIfNotNull(AdminUser.Fields.PASSWORD, password)
                .setIfNotNull(AdminUser.Fields.NAME, name)
                .setIfNotNull(AdminUser.Fields.ROLE_ID, roleId);
        return mongoClient.updateMany(entityClass, filter, update);
    }

    public Mono<Long> countAdminUsers(@Nullable Set<String> accounts, @Nullable Set<Long> roleIds) {
        Filter filter = Filter.newBuilder(2)
                .inIfNotNull(DomainFieldName.ID, accounts)
                .inIfNotNull(AdminUser.Fields.ROLE_ID, roleIds);
        return mongoClient.count(entityClass, filter);
    }

    public Flux<AdminUser> findAdminUsers(
            @Nullable Set<String> accounts,
            @Nullable Set<Long> roleIds,
            @Nullable Integer page,
            @Nullable Integer size) {
        Filter filter = Filter.newBuilder(2)
                .inIfNotNull(DomainFieldName.ID, accounts)
                .inIfNotNull(AdminUser.Fields.ROLE_ID, roleIds);
        QueryOptions options = QueryOptions.newBuilder(2)
                .paginateIfNotNull(page, size);
        return mongoClient.findMany(entityClass, filter, options);
    }

}