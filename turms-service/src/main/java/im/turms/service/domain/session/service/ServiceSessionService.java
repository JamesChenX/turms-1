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

package im.turms.service.domain.session.service;

import org.springframework.stereotype.Service;

/**
 * @author James Chen
 */
@Service
public class ServiceSessionService {

//    private final OutboundMessageService outboundMessageService;
//    private final UserRelationshipService userRelationshipService;
//
//    public SessionService(OutboundMessageService outboundMessageService,
//                          UserRelationshipService userRelationshipService) {
//        this.outboundMessageService = outboundMessageService;
//        this.userRelationshipService = userRelationshipService;
//    }

//    @Override
//    public Mono<Void> notifySessionsStatusChange(Long userId, UserStatus userStatus) {
//        return userRelationshipService.queryRelationshipKeys(Set.of(userId), false)
//                .collectList()
//                .flatMap(keys -> {
////                    Set<Map.Entry<Long, Set<Long>>> entries = ownerIdToRelatedUserIds.entrySet();
////                    List<Mono<?>> forwardNotifications = new ArrayList<>(entries.size());
//                    TurmsNotification.Builder notificationBuilder = ClientMessagePool
//                            .getTurmsNotificationBuilder();
//                    TurmsRequest.Builder requestBuilder = ClientMessagePool
//                            .getTurmsRequestBuilder();
//                    UpdateUserOnlineStatusRequest.Builder updateUserOnlineStatusRequestBuilder = ClientMessagePool
//                            .getUpdateUserOnlineStatusRequestBuilder();
//                    TurmsNotification.Builder request = notificationBuilder
//                            .clear()
//                            .setRelayedRequest(requestBuilder
//                                    .clear()
//                                    .setRequestId(userId)
//                                    .setUpdateUserOnlineStatusRequest(
//                                            // TODO: cahce
//                                            updateUserOnlineStatusRequestBuilder
//                                                    .clear()
//                                                    .setUserStatus(userStatus)));
//                    outboundMessageService.forwardNotification(
//                            request, keys.stream().map(key -> key.getKey()).collect(CollectionUtil.toSet()));
//                });
//    }

}