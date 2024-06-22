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

package im.turms.server.common.domain.plugin.access.admin.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.HttpResponseException;
import im.turms.server.common.access.admin.api.response.DeleteResultDTO;
import im.turms.server.common.access.admin.api.response.HttpHandlerResult;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.admin.permission.AdminPermission;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.FileDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.request.CreateJavaPluginsRequestDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.request.CreateJavaScriptPluginsRequestDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.request.DeletePluginsRequestDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.request.QueryPluginsRequestDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.request.UpdatePluginsRequestDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.response.CreatePluginsResponseDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.response.ExtensionDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.response.PluginDTO;
import im.turms.server.common.domain.plugin.access.admin.dto.response.QueryPluginsResponseDTO;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.io.FileHolder;
import im.turms.server.common.infra.plugin.ExtensionPoint;
import im.turms.server.common.infra.plugin.IncompatibleServerException;
import im.turms.server.common.infra.plugin.InvalidPluginException;
import im.turms.server.common.infra.plugin.InvalidPluginSourceException;
import im.turms.server.common.infra.plugin.JsPluginScript;
import im.turms.server.common.infra.plugin.Plugin;
import im.turms.server.common.infra.plugin.PluginDescriptor;
import im.turms.server.common.infra.plugin.PluginManager;
import im.turms.server.common.infra.plugin.TurmsExtension;
import im.turms.server.common.infra.plugin.UnsupportedSaveOperationException;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_PLUGIN)
public class PluginController extends BaseApiController {

    private final PluginManager pluginManager;

    public PluginController(ApplicationContext context, PluginManager pluginManager) {
        super(context);
        this.pluginManager = pluginManager;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.QUERY,
            requiredPermissions = AdminPermission.PLUGIN_QUERY)
    public ResponseDTO<QueryPluginsResponseDTO> queryPlugins(
            @Nullable QueryPluginsRequestDTO request) {
        List<Plugin> plugins;
        if (request == null) {
            plugins = CollectionUtil.sort(pluginManager.getPlugins());
        } else {
            if (request.hasFilter()) {
                LinkedHashSet<String> ids = request.filter()
                        .ids();
                if (ids == null) {
                    plugins = CollectionUtil.sort(pluginManager.getPlugins());
                } else if (ids.isEmpty()) {
                    return ResponseDTO.of(QueryPluginsResponseDTO.of(Collections.emptyList()));
                } else {
                    plugins = CollectionUtil.sort(pluginManager.getPlugins(ids));
                }
            } else {
                plugins = CollectionUtil.sort(pluginManager.getPlugins());
            }
            plugins = applySkipAndLimit(request, plugins);
        }
        List<PluginDTO> pluginInfoList = CollectionUtil.transformAsList(plugins, this::plugin2dto);
        return ResponseDTO.of(QueryPluginsResponseDTO.of(pluginInfoList));
    }

    @ApiEndpoint(
            action = ApiEndpointAction.UPDATE,
            requiredPermissions = AdminPermission.PLUGIN_UPDATE)
    public Mono<ResponseDTO<UpdateResultDTO>> updatePlugins(UpdatePluginsRequestDTO request) {
        UpdatePluginsRequestDTO.UpdateDTO update = request.update();
        UpdatePluginsRequestDTO.UpdateDTO.PluginStatus status = update.status();
        if (status == null) {
            return ResponseDTO.updateResult0Mono();
        }
        Mono<Integer> count;
        if (request.updateAll()) {
            count = switch (status) {
                case STARTED -> pluginManager.startPlugins();
                case STOPPED -> pluginManager.stopPlugins();
                case RESUMED -> pluginManager.resumePlugins();
                case PAUSED -> pluginManager.pausePlugins();
            };
        } else {
            Set<String> ids = request.filter()
                    .ids();
            if (ids.isEmpty()) {
                return ResponseDTO.updateResult0Mono();
            }
            count = switch (status) {
                case STARTED -> pluginManager.startPlugins(ids);
                case STOPPED -> pluginManager.stopPlugins(ids);
                case RESUMED -> pluginManager.resumePlugins(ids);
                case PAUSED -> pluginManager.pausePlugins(ids);
            };
        }
        return ResponseDTO.updateResultFromIntegerMono(count);
    }

    @ApiEndpoint(
            value = "java",
            action = ApiEndpointAction.CREATE,
            requiredPermissions = AdminPermission.PLUGIN_CREATE)
    public ResponseDTO<CreatePluginsResponseDTO> createJavaPlugins(
            CreateJavaPluginsRequestDTO request) {
        try {
            List<FileHolder> fileHolders =
                    CollectionUtil.transformAsList(request.records(), FileDTO::fileHolder);
            List<Plugin> plugins = pluginManager.loadJavaPlugins(fileHolders, request.save());
            List<PluginDTO> pluginInfoList =
                    CollectionUtil.transformAsList(plugins, this::plugin2dto);
            return ResponseDTO.of(CreatePluginsResponseDTO.of(pluginInfoList));
        } catch (IncompatibleServerException | InvalidPluginSourceException
                | InvalidPluginException e) {
            throw new HttpResponseException(ResponseStatusCode.ILLEGAL_ARGUMENT, e);
        } catch (UnsupportedSaveOperationException e) {
            throw new HttpResponseException(ResponseStatusCode.SAVING_JAVA_PLUGIN_IS_DISABLED, e);
        }
    }

    @ApiEndpoint(
            value = "javascript",
            action = ApiEndpointAction.CREATE,
            requiredPermissions = AdminPermission.PLUGIN_CREATE)
    public ResponseDTO<CreatePluginsResponseDTO> createJsPlugins(
            CreateJavaScriptPluginsRequestDTO request) {
        List<JsPluginScript> scripts = request.scripts();
        try {
            pluginManager.loadJsPlugins(scripts, save);
        } catch (IncompatibleServerException | InvalidPluginSourceException
                | InvalidPluginException e) {
            throw new HttpResponseException(ResponseStatusCode.ILLEGAL_ARGUMENT, e);
        } catch (UnsupportedSaveOperationException e) {
            throw new HttpResponseException(
                    ResponseStatusCode.SAVING_JAVASCRIPT_PLUGIN_IS_DISABLED,
                    e);
        } catch (UnsupportedOperationException e) {
            throw new HttpResponseException(ResponseStatusCode.JAVASCRIPT_PLUGIN_IS_DISABLED, e);
        }
        return HttpHandlerResult.RESPONSE_OK;
    }

    @ApiEndpoint(
            action = ApiEndpointAction.DELETE,
            requiredPermissions = AdminPermission.PLUGIN_DELETE)
    public Mono<ResponseDTO<DeleteResultDTO>> deletePlugins(DeletePluginsRequestDTO request) {
        if (request.deleteAll()) {
            return ResponseDTO.deleteResultFromIntegerMono(
                    pluginManager.deletePlugins(request.deleteLocalFiles()));
        }
        LinkedHashSet<String> ids = request.filter()
                .ids();
        if (ids.isEmpty()) {
            return ResponseDTO.deleteResult0Mono();
        }
        return ResponseDTO.deleteResultFromIntegerMono(
                pluginManager.deletePlugins(ids, request.deleteLocalFiles()));
    }

    private PluginDTO plugin2dto(Plugin plugin) {
        List<TurmsExtension> extensions = plugin.extensions();
        List<ExtensionDTO> extensionDTOs = new ArrayList<>(extensions.size());
        for (TurmsExtension extension : extensions) {
            List<Class<? extends ExtensionPoint>> classes =
                    pluginManager.getExtensionPoints(extension);
            List<String> classNames = new ArrayList<>(classes.size());
            for (Class<? extends ExtensionPoint> clazz : classes) {
                classNames.add(clazz.getName());
            }
            extensionDTOs.add(new ExtensionDTO(
                    extension.getClass()
                            .getName(),
                    extension.isStarted(),
                    extension.isRunning(),
                    classNames));
        }
        PluginDescriptor descriptor = plugin.descriptor();
        return new PluginDTO(
                descriptor.getId(),
                descriptor.getVersion(),
                descriptor.getProvider(),
                descriptor.getLicense(),
                descriptor.getDescription(),
                extensionDTOs);
    }

}