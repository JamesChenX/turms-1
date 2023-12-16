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

package im.turms.server.common.testing.environment;

/**
 * @author James Chen
 */
public class ContainerTestEnvironmentPropertyConst {

    public static final String DOCKER_COMPOSE_TEST_FILE = "docker-compose.test.yml";

    public static final String MONGO = "mongodb-router";
    public static final String MONGO_SHARD = "mongodb-shard";
    public static final String MONGO_CONFIG = "mongodb-config";
    public static final String MONGO_SERVICE_NAME = "mongodb-router_1";
    public static final int MONGO_SERVICE_PORT = 27017;
    public static final String MONGO_SERVICE_PASSWORD = "turms";

    public static final String REDIS = "redis";
    public static final String REDIS_SERVICE_NAME = "redis_1";
    public static final int REDIS_SERVICE_PORT = 6379;

    public static final String TURMS_ADMIN = "turms-admin";

    public static final String TURMS_SERVICE = "turms-service";
    public static final String TURMS_SERVICE_JVM_OPTION_NAME = "TURMS_SERVICE_JVM_OPTS";
    public static final String TURMS_SERVICE_SERVICE_NAME = "turms-service_1";
    public static final int TURMS_SERVICE_ADMIN_HTTP_PORT = 8510;

    public static final String TURMS_GATEWAY = "turms-gateway";
    public static final String TURMS_GATEWAY_JVM_OPTION_NAME = "TURMS_GATEWAY_JVM_OPTS";
    public static final String TURMS_GATEWAY_SERVICE_NAME = "turms-gateway_1";
    public static final int TURMS_GATEWAY_SERVICE_ADMIN_HTTP_PORT = 9510;
    public static final int TURMS_GATEWAY_SERVICE_WEBSOCKET_PORT = 10510;

    private ContainerTestEnvironmentPropertyConst() {
    }

}