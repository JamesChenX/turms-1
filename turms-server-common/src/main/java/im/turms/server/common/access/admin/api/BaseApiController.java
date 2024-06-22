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

import java.util.List;

import org.springframework.context.ApplicationContext;

import im.turms.server.common.domain.common.access.dto.QueryRequestWithPaginationDTO;
import im.turms.server.common.infra.collection.CollectionUtil;

/**
 * @author James Chen
 * @implNote 1. We require all controllers to extend {@link BaseApiController} so that developers
 *           can know what controllers we have easily by showing its class hierarchy, and that's how
 *           Turms makes the code clear.
 *           <p>
 *           2. We don't call it "ApiController" to not conflict with {@link ApiController}, and we
 *           follow the same naming convention for the base classes representing controllers,
 *           services, repositories, etc.
 */
public abstract class BaseApiController {

    /**
     * Though we haven't used {@link ApplicationContext}, we require subclasses to pass it to the
     * constructor so that we can avoid introducing breaking changes when we need to add new
     * features based on other beans in this controller in the future.
     */
    protected final ApplicationContext applicationContext;

    protected BaseApiController(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    /**
     * @implNote We don't check if skip and limit is negative because it should be validated when
     *           the request is deserialized.
     */
    protected <T> List<T> applySkipAndLimit(
            QueryRequestWithPaginationDTO<?> request,
            List<T> records) {
        Integer skip = request.skip();
        Integer limit = request.limit();
        return CollectionUtil.applySkipAndLimit(records, skip, limit);
    }
}