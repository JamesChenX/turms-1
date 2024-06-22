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

package im.turms.server.common.domain.observation.access.admin.controller;

import java.util.Map;
import jakarta.annotation.Nullable;

import io.netty.buffer.ByteBuf;
import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.ApiEndpointInfo;
import im.turms.server.common.access.admin.api.ApiEndpointKey;
import im.turms.server.common.access.admin.api.ApiRequestDispatcher;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.infra.address.BaseServiceAddressManager;
import im.turms.server.common.infra.cluster.node.Node;
import im.turms.server.common.infra.context.TurmsApplicationContext;
import im.turms.server.common.infra.netty.ByteBufUtil;
import im.turms.server.common.infra.openapi.OpenApiBuilder;

import static im.turms.server.common.infra.http.ContentEncodingConst.GZIP;
import static im.turms.server.common.infra.http.MediaTypeConst.APPLICATION_JAVASCRIPT;
import static im.turms.server.common.infra.http.MediaTypeConst.APPLICATION_JSON;
import static im.turms.server.common.infra.http.MediaTypeConst.IMAGE_PNG;
import static im.turms.server.common.infra.http.MediaTypeConst.TEXT_CSS;
import static im.turms.server.common.infra.http.MediaTypeConst.TEXT_HTML;
import static im.turms.server.common.infra.openapi.OpenApiResourceConst.FAVICON_32x32;
import static im.turms.server.common.infra.openapi.OpenApiResourceConst.INDEX_CSS;
import static im.turms.server.common.infra.openapi.OpenApiResourceConst.INDEX_HTML;
import static im.turms.server.common.infra.openapi.OpenApiResourceConst.SWAGGER_UI_BUNDLE;
import static im.turms.server.common.infra.openapi.OpenApiResourceConst.SWAGGER_UI_CSS;
import static im.turms.server.common.infra.openapi.OpenApiResourceConst.SWAGGER_UI_STANDALONE_PRESET;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_OPENAPI)
public class OpenApiController extends BaseApiController {

    private static final String ENDPOINT_API_DOCS = "api-docs";
    private final ApplicationContext context;
    private volatile ByteBuf apiBuffer;
    private final ByteBuf swaggerInitializer;

    public OpenApiController(
            ApplicationContext context,
            BaseServiceAddressManager serviceAddressManager) {
        super(context);
        this.context = context;
        String url = serviceAddressManager.getAdminApiAddress()
                + "/"
                + ApiConst.RESOURCE_PATH_COMMON_OPENAPI
                + "/"
                + ENDPOINT_API_DOCS;
        swaggerInitializer = ByteBufUtil.getUnreleasableDirectBuffer(
                // language=JavaScript
                """
                        window.onload = function() {
                          window.ui = SwaggerUIBundle({
                            url: "%s",
                            dom_id: '#swagger-ui',
                            deepLinking: true,
                            presets: [
                              SwaggerUIBundle.presets.apis,
                              SwaggerUIStandalonePreset
                            ],
                            plugins: [
                              SwaggerUIBundle.plugins.DownloadUrl
                            ],
                            layout: "StandaloneLayout"
                          });
                        };
                        """.formatted(url));
    }

    @ApiEndpoint(
            value = ENDPOINT_API_DOCS,
            action = ApiEndpointAction.QUERY,
            produces = APPLICATION_JSON)
    public ByteBuf getApiDocs() {
        if (apiBuffer == null) {
            synchronized (this) {
                if (apiBuffer == null) {
                    updateApiBuffer(null);
                }
            }
        }
        return apiBuffer;
    }

    @ApiEndpoint(value = "ui", action = ApiEndpointAction.QUERY, produces = TEXT_HTML)
    public ByteBuf getIndexHtml() {
        return INDEX_HTML;
    }

    @ApiEndpoint(
            value = "ui/favicon-32x32.png",
            action = ApiEndpointAction.QUERY,
            produces = IMAGE_PNG)
    public ByteBuf getFavicon3232() {
        return FAVICON_32x32;
    }

    @ApiEndpoint(value = "ui/index.css", action = ApiEndpointAction.QUERY, produces = TEXT_CSS)
    public ByteBuf getIndexCss() {
        return INDEX_CSS;
    }

    @ApiEndpoint(value = "ui/swagger-ui.css", action = ApiEndpointAction.QUERY, produces = TEXT_CSS)
    public ByteBuf getSwaggerUiCss() {
        return SWAGGER_UI_CSS;
    }

    @ApiEndpoint(
            value = "ui/swagger-ui-bundle.js",
            action = ApiEndpointAction.QUERY,
            produces = APPLICATION_JAVASCRIPT,
            encoding = GZIP)
    public ByteBuf getSwaggerUiBundle() {
        return SWAGGER_UI_BUNDLE;
    }

    @ApiEndpoint(
            value = "ui/swagger-ui-standalone-preset.js",
            action = ApiEndpointAction.QUERY,
            produces = APPLICATION_JAVASCRIPT,
            encoding = GZIP)
    public ByteBuf getSwaggerUiStandalonePreset() {
        return SWAGGER_UI_STANDALONE_PRESET;
    }

    @ApiEndpoint(
            value = "ui/swagger-initializer.js",
            action = ApiEndpointAction.QUERY,
            produces = APPLICATION_JAVASCRIPT)
    public ByteBuf getSwaggerInitializer() {
        return swaggerInitializer;
    }

    private synchronized void updateApiBuffer(
            @Nullable Map<ApiEndpointKey, ApiEndpointInfo> keyToEndpoint) {
        ApiRequestDispatcher dispatcher = context.getBean(ApiRequestDispatcher.class);
        if (apiBuffer == null) {
            dispatcher.addEndpointChangeListener(this::updateApiBuffer);
        } else {
            apiBuffer.unwrap()
                    .release();
        }
        if (keyToEndpoint == null) {
            keyToEndpoint = dispatcher.getKeyToEndpoint();
        }
        byte[] bytes = OpenApiBuilder.build(context.getBean(TurmsApplicationContext.class)
                .getBuildProperties()
                .version(),
                context.getBean(Node.class)
                        .getNodeType()
                        .getDisplayName(),
                context.getBean(BaseServiceAddressManager.class)
                        .getAdminApiAddress(),
                keyToEndpoint);
        apiBuffer = ByteBufUtil.getUnreleasableDirectBuffer(bytes);
    }

}