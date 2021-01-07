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

package im.turms.turms.workflow.service.impl.conversation;

import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.Multimap;
import com.mongodb.client.result.DeleteResult;
import im.turms.server.common.cluster.node.Node;
import im.turms.server.common.constant.TurmsStatusCode;
import im.turms.server.common.exception.TurmsBusinessException;
import im.turms.server.common.property.env.service.business.conversation.ReadReceiptProperties;
import im.turms.server.common.util.AssertUtil;
import im.turms.server.common.util.MapUtil;
import im.turms.turms.constant.DaoConstant;
import im.turms.turms.workflow.dao.domain.conversation.GroupConversation;
import im.turms.turms.workflow.dao.domain.conversation.PrivateConversation;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.data.mongodb.core.ReactiveMongoOperations;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import javax.annotation.Nullable;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.PastOrPresent;
import java.util.*;

/**
 * @author James Chen
 */
@Log4j2
@Service
public class ConversationService {

    private final Node node;
    private final ReactiveMongoTemplate mongoTemplate;

    public ConversationService(
            Node node,
            @Qualifier("conversationMongoTemplate") ReactiveMongoTemplate mongoTemplate) {
        this.node = node;
        this.mongoTemplate = mongoTemplate;
    }

    // TODO: authenticate
    public Mono<Void> authAndUpsertGroupConversationReadDate(@NotNull Long groupId,
                                                             @NotNull Long memberId,
                                                             @Nullable @PastOrPresent Date readDate) {
        ReadReceiptProperties properties = node.getSharedProperties().getService().getConversation().getReadReceipt();
        if (!properties.isEnabled()) {
            return Mono.error(TurmsBusinessException.get(TurmsStatusCode.UPDATING_READ_DATE_IS_DISABLED));
        }
        if (properties.isUseServerTime()) {
            readDate = new Date();
        }
        return upsertGroupConversationReadDate(groupId, memberId, readDate);
    }

    // TODO: authenticate
    public Mono<Void> authAndUpsertPrivateConversationReadDate(@NotNull Long ownerId,
                                                               @NotNull Long targetId,
                                                               @Nullable @PastOrPresent Date readDate) {
        ReadReceiptProperties properties = node.getSharedProperties().getService().getConversation().getReadReceipt();
        if (!properties.isEnabled()) {
            return Mono.error(TurmsBusinessException.get(TurmsStatusCode.UPDATING_READ_DATE_IS_DISABLED));
        }
        if (properties.isUseServerTime()) {
            readDate = new Date();
        }
        return upsertPrivateConversationReadDate(ownerId, targetId, readDate);
    }

    public Mono<Void> upsertGroupConversationReadDate(@NotNull Long groupId,
                                                      @NotNull Long memberId,
                                                      @Nullable @PastOrPresent Date readDate) {
        try {
            AssertUtil.notNull(groupId, "groupId");
            AssertUtil.notNull(memberId, "memberId");
            AssertUtil.pastOrPresent(readDate, "readDate");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        if (readDate == null) {
            readDate = new Date();
        }
        String fieldKey = GroupConversation.Fields.MEMBER_ID_AND_READ_DATE + "." + memberId;
        Query query = new Query()
                .addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).is(groupId));
        if (!node.getSharedProperties().getService().getConversation().getReadReceipt().isAllowMoveReadDateForward()) {
            query.addCriteria(new Criteria().orOperator(
                    Criteria.where(fieldKey).is(null),
                    Criteria.where(fieldKey).lt(readDate)));
        }
        Update update = new Update().set(fieldKey, readDate);
        return mongoTemplate.upsert(query, update, GroupConversation.class, GroupConversation.COLLECTION_NAME).then();
    }

    public Mono<Void> upsertGroupConversationsReadDate(@NotNull Set<GroupConversation.GroupConversionMemberKey> keys,
                                                       @Nullable @PastOrPresent Date readDate) {
        try {
            AssertUtil.notNull(keys, "keys");
            AssertUtil.pastOrPresent(readDate, "readDate");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        if (keys.isEmpty()) {
            return Mono.empty();
        }
        if (readDate == null) {
            readDate = new Date();
        }
        Multimap<Long, Long> multimap = ArrayListMultimap.create(1, keys.size());
        for (GroupConversation.GroupConversionMemberKey key : keys) {
            multimap.put(key.getGroupId(), key.getMemberId());
        }
        Set<Map.Entry<Long, Collection<Long>>> entries = multimap.asMap().entrySet();
        List<Mono<Void>> upsertMonos = new ArrayList<>(entries.size());
        for (Map.Entry<Long, Collection<Long>> entry : entries) {
            Long groupId = entry.getKey();
            Collection<Long> memberIds = entry.getValue();
            Query query = new Query()
                    .addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).is(groupId));
            Update update = new Update();
            for (Long memberId : memberIds) {
                String fieldKey = GroupConversation.Fields.MEMBER_ID_AND_READ_DATE + "." + memberId;
                // Ignore isAllowMoveReadDateForward()
                update.set(fieldKey, readDate);
            }
            upsertMonos.add(mongoTemplate.upsert(query, update, GroupConversation.class, GroupConversation.COLLECTION_NAME).then());
        }
        return Mono.when(upsertMonos);
    }

    public Mono<Void> upsertPrivateConversationReadDate(@NotNull Long ownerId,
                                                        @NotNull Long targetId,
                                                        @Nullable @PastOrPresent Date readDate) {
        try {
            AssertUtil.notNull(ownerId, "ownerId");
            AssertUtil.notNull(targetId, "targetId");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        return upsertPrivateConversationsReadDate(Set.of(new PrivateConversation.Key(ownerId, targetId)), readDate);
    }

    public Mono<Void> upsertPrivateConversationsReadDate(@NotNull Set<PrivateConversation.Key> keys,
                                                         @Nullable @PastOrPresent Date readDate) {
        try {
            AssertUtil.notNull(keys, "keys");
            AssertUtil.pastOrPresent(readDate, "readDate");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        if (readDate == null) {
            readDate = new Date();
        }
        Query query = new Query()
                .addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).in(keys));
        if (!node.getSharedProperties().getService().getConversation().getReadReceipt().isAllowMoveReadDateForward()) {
            query.addCriteria(new Criteria().orOperator(
                    Criteria.where(PrivateConversation.Fields.READ_DATE).is(null),
                    Criteria.where(PrivateConversation.Fields.READ_DATE).lt(readDate)));
        }
        Update update = new Update()
                .set(PrivateConversation.Fields.READ_DATE, readDate);
        return mongoTemplate.upsert(query, update, PrivateConversation.class, PrivateConversation.COLLECTION_NAME).then();
    }

    public Flux<GroupConversation> queryGroupConversations(@NotNull Collection<Long> groupIds) {
        try {
            AssertUtil.notNull(groupIds, "groupIds");
        } catch (TurmsBusinessException e) {
            return Flux.error(e);
        }
        if (groupIds.isEmpty()) {
            return Flux.empty();
        }
        Query query = new Query().addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).in(groupIds));
        return mongoTemplate.find(query, GroupConversation.class, GroupConversation.COLLECTION_NAME);
    }

    public Flux<PrivateConversation> queryPrivateConversationsByOwnerIds(
            @NotNull Set<Long> ownerIds) {
        try {
            AssertUtil.notNull(ownerIds, "ownerIds");
        } catch (TurmsBusinessException e) {
            return Flux.error(e);
        }
        if (ownerIds.isEmpty()) {
            return Flux.empty();
        }
        Query query = new Query()
                .addCriteria(Criteria.where(PrivateConversation.Fields.ID_OWNER_ID).in(ownerIds));
        return mongoTemplate.find(query, PrivateConversation.class, PrivateConversation.COLLECTION_NAME);
    }

    public Flux<PrivateConversation> queryPrivateConversations(
            @NotNull Long ownerId,
            @NotNull Collection<Long> targetIds) {
        try {
            AssertUtil.notNull(ownerId, "ownerId");
            AssertUtil.notNull(targetIds, "targetIds");
        } catch (TurmsBusinessException e) {
            return Flux.error(e);
        }
        int size = targetIds.size();
        if (size == 0) {
            return Flux.empty();
        }
        Set<PrivateConversation.Key> keys = new HashSet<>(MapUtil.getCapability(size));
        for (Long targetId : targetIds) {
            keys.add(new PrivateConversation.Key(ownerId, targetId));
        }
        return queryPrivateConversations(keys);
    }

    public Flux<PrivateConversation> queryPrivateConversations(@NotNull Set<PrivateConversation.Key> keys) {
        try {
            AssertUtil.notNull(keys, "keys");
        } catch (TurmsBusinessException e) {
            return Flux.error(e);
        }
        Query query = new Query().addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).in(keys));
        return mongoTemplate.find(query, PrivateConversation.class, PrivateConversation.COLLECTION_NAME);
    }

    public Mono<DeleteResult> deletePrivateConversations(@NotNull Set<PrivateConversation.Key> keys) {
        try {
            AssertUtil.notNull(keys, "keys");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        Query query = new Query().addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).in(keys));
        return mongoTemplate.remove(query, PrivateConversation.class, PrivateConversation.COLLECTION_NAME);
    }

    public Mono<DeleteResult> deletePrivateConversations(@NotNull Set<Long> userIds, @Nullable ReactiveMongoOperations operations) {
        try {
            AssertUtil.notNull(userIds, "userIds");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        Query query = new Query().addCriteria(Criteria.where(PrivateConversation.Fields.ID_OWNER_ID).in(userIds));
        ReactiveMongoOperations mongoOperations = operations == null
                ? mongoTemplate
                : operations;
        return mongoOperations.remove(query, PrivateConversation.class, PrivateConversation.COLLECTION_NAME);
    }

    public Mono<DeleteResult> deleteGroupConversations(@NotNull Set<Long> groupIds, @Nullable ReactiveMongoOperations operations) {
        try {
            AssertUtil.notNull(groupIds, "groupIds");
        } catch (TurmsBusinessException e) {
            return Mono.error(e);
        }
        Query query = new Query().addCriteria(Criteria.where(DaoConstant.ID_FIELD_NAME).in(groupIds));
        ReactiveMongoOperations mongoOperations = operations == null
                ? mongoTemplate
                : operations;
        return mongoOperations.remove(query, GroupConversation.class, GroupConversation.COLLECTION_NAME);
    }

}