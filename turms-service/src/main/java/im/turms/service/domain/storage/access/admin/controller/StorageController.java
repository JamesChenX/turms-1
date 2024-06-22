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

package im.turms.service.domain.storage.access.admin.controller;

import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.infra.property.TurmsPropertiesManager;
import im.turms.service.domain.common.access.admin.controller.BaseController;
import im.turms.service.domain.storage.service.StorageService;

/**
 * @author James Chen
 */
@ApiController("storage-resource")
public class StorageController extends BaseController {

    private final StorageService storageService;

    public StorageController(
            ApplicationContext context,
            TurmsPropertiesManager propertiesManager,
            StorageService storageService) {
        super(context, propertiesManager);
        this.storageService = storageService;
    }
}