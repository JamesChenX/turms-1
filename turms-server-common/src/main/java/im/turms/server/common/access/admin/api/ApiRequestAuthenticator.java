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

import java.util.Arrays;
import java.util.Base64;
import jakarta.annotation.Nullable;

import io.netty.handler.codec.http.HttpHeaderNames;
import io.netty.handler.codec.http.HttpHeaders;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.domain.admin.service.BaseAdminService;
import im.turms.server.common.infra.codec.Base64Util;
import im.turms.server.common.infra.lang.AsciiCode;
import im.turms.server.common.infra.lang.Pair;
import im.turms.server.common.infra.lang.StringUtil;

/**
 * @author James Chen
 */
public class ApiRequestAuthenticator {

    private static final String BASIC_AUTH_PREFIX = "Basic ";

    private final BaseAdminService adminService;

    public ApiRequestAuthenticator(BaseAdminService adminService) {
        this.adminService = adminService;
    }

    public Mono<Credentials> authenticate(
            ApiEndpointParameter[] params,
            Object[] paramValues,
            HttpHeaders headers,
            AdminPermission[] requiredPermissions) {
        if (requiredPermissions.length == 0) {
            return Mono.just(Credentials.EMPTY);
        }
        Credentials credentials = parseCredentials(headers);
        if (credentials == null) {
            return Mono.error(new HttpResponseException(
                    HttpHandlerResult
                            .unauthorized("Could not find valid credentials from the header: \""
                                    + HttpHeaderNames.AUTHORIZATION
                                    + "\"")));
        }
        return adminService.authenticate(credentials.account(), credentials.password())
                .flatMap(authenticated -> {
                    if (authenticated) {
                        return adminService
                                .isAdminAuthorized(params,
                                        paramValues,
                                        credentials.account(),
                                        requiredPermissions)
                                .flatMap(authorized -> {
                                    if (authorized) {
                                        return Mono.just(credentials);
                                    }
                                    return Mono.error(new HttpResponseException(
                                            HttpHandlerResult.unauthorized(
                                                    "Unauthorized to access the resource. Required permissions: "
                                                            + Arrays.toString(
                                                                    requiredPermissions))));
                                });
                    }
                    return Mono.error(new HttpResponseException(
                            HttpHandlerResult.unauthorized("Unauthenticated")));
                });
    }

    @Nullable
    private Credentials parseCredentials(HttpHeaders headers) {
        String authorization = headers.get(HttpHeaderNames.AUTHORIZATION);
        if (authorization == null || !authorization.startsWith(BASIC_AUTH_PREFIX)) {
            return null;
        }
        try {
            String encodedCredentials = authorization.substring(BASIC_AUTH_PREFIX.length());
            byte[] decode = Base64Util..getDecoder()
                    .decode(StringUtil.getBytes(encodedCredentials));
            Pair<String, String> accountAndPassword =
                    StringUtil.splitLatin1(StringUtil.newLatin1String(decode), AsciiCode.COLON);
            if (accountAndPassword == null) {
                return null;
            }
            return new Credentials(accountAndPassword.first(), accountAndPassword.second());
        } catch (Exception e) {
            return null;
        }
    }

}