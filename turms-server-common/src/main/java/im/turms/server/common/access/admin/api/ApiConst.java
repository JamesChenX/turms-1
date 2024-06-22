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

package im.turms.server.common.access.admin.api;

import reactor.core.publisher.Mono;

import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.infra.exception.ResponseException;

/**
 * @author James Chen
 */
public final class ApiConst {

    private ApiConst() {
    }

    // Common

    public static final String RESOURCE_PATH_COMMON_APPLICATION_INFO = "application/info";
    public static final String RESOURCE_PATH_COMMON_APPLICATION_SETTING = "application/setting";

    public static final String RESOURCE_PATH_COMMON_ADMIN_PERMISSION = "admin/permission";
    public static final String RESOURCE_PATH_COMMON_ADMIN_ROLE = "admin/role";
    public static final String RESOURCE_PATH_COMMON_ADMIN_USER = "admin/user";

    public static final String RESOURCE_PATH_COMMON_BLOCKED_CLIENT_IP = "blocked-client/ips";
    public static final String RESOURCE_PATH_COMMON_BLOCKED_CLIENT_USER = "blocked-client/user";

    public static final String RESOURCE_PATH_COMMON_DEBUG = "debug";

    public static final String RESOURCE_PATH_COMMON_MONITOR_FLIGHT_RECORDING =
            "monitor/flight-recording";
    public static final String RESOURCE_PATH_COMMON_MONITOR_HEATH = "monitor/health";
    public static final String RESOURCE_PATH_COMMON_MONITOR_HEAP = "monitor/heap";
    public static final String RESOURCE_PATH_COMMON_MONITOR_LOG = "monitor/log";
    public static final String RESOURCE_PATH_COMMON_MONITOR_METRIC = "monitor/metric";
    public static final String RESOURCE_PATH_COMMON_MONITOR_THREAD = "monitor/thread";

    public static final String RESOURCE_PATH_COMMON_OPENAPI = "openapi";

    public static final String RESOURCE_PATH_COMMON_PLUGIN = "plugin";

    public static final Mono ERROR_ILLEGAL_DELETE_ALL_REQUEST =
            Mono.error(ResponseException.get(ResponseStatusCode.ILLEGAL_ARGUMENT,
                    "To delete all records, \"filter\" must be null or empty, "
                            + "and \"deleteAll\" must be true"));

    // turms-ai-serving

    public static final String RESOURCE_PATH_AI_SERVING_OCR = "ocr";
    public static final String RESOURCE_PATH_AI_SERVING_MODEL = "model";

    // turms-gateway

    public static final String RESOURCE_PATH_GATEWAY_SESSION = "session";

    // turms-service

    public static final String RESOURCE_PATH_SERVICE_BUSINESS_CONVERSATION =
            "business/conversation";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP = "business/group";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP_BLOCKED_USER =
            "business/group/blocked-user";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP_INVITATION =
            "business/group/invitation";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP_JOIN_REQUEST =
            "business/group/join-request";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP_MEMBER =
            "business/group/member";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP_QUESTION =
            "business/group/question";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_GROUP_TYPE = "business/group/type";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_MESSAGE = "business/message";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_USER = "business/user";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_USER_FRIEND_REQUEST =
            "business/user/friend-request";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_USER_PERMISSION_GROUP =
            "business/user/online-info";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_USER_ONLINE_INFO =
            "business/user/permission-group";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_USER_RELATIONSHIP_GROUP =
            "business/user/relationship-group";
    public static final String RESOURCE_PATH_SERVICE_BUSINESS_USER_RELATIONSHIP_GROUP_RELATIONSHIP =
            "business/user/relationship-group/relationship";

    public static final String RESOURCE_PATH_SERVICE_CLUSTER_MEMBER = "cluster/member";
    public static final String RESOURCE_PATH_SERVICE_CLUSTER_SETTING = "cluster/setting";

}