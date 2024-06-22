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

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import im.turms.server.common.domain.common.access.dto.BinaryRequestDTO;

/**
 * Use this annotation to indicate that the parameter is a request. The parameter type must be
 * {@link {@link im.turms.server.common.domain.common.access.dto.ResponseDTO}}.
 *
 * @author James Chen
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.PARAMETER)
public @interface Request {

    /**
     * If the content type is not specified, the default content type is used. If the parameter type
     * is {@link BinaryRequestDTO}, the default content type is "application/octet-stream".
     * Otherwise, the default content type is "application/json".
     */
    String contentType() default "";

}