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

package im.turms.server.common.domain.common.access.dto;

/**
 * @author James Chen
 * @implNote We use an abstract class instead of interface to force all subclasses to extend
 *           {@link ControllerDTO} and avoid subclasses declaring as {@link Record} because:
 *           <p>
 *           1. {@link Record} doesn't support inheritance. If subclasses declare as {@link Record},
 *           we cannot add new fields to the subclasses without breaking the compatibility, which
 *           means field changes in DTOs will break the DTOs provided by Turms plugins, even if we
 *           can introduce new fields as the default method in an interface, there is no fields to
 *           accept these new fields in request DTOs if clients pass them to us.
 *           <p>
 *           2. It is verbose to use the default methods of interface to force subclasses to
 *           implement new fields one by one, which will introduce a lot of boilerplate code.
 */
public abstract sealed class ControllerDTO permits RequestComponentDTO, RequestDTO {
}