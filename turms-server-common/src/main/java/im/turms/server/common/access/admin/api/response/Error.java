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

package im.turms.server.common.access.admin.api.response;

import java.util.List;
import jakarta.annotation.Nullable;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * @author James Chen
 */
public record Error(
        String type,
        String reason,
        @Schema(
                description = "The error array. If an error occurs, the write error will be returned. "
                        + "Note that if the request supports the \"continueOnError\" parameter (the feature is not yet published) "
                        + "and it is specified as true, "
                        + "the write errors will contain all write errors occur when creating the records. "
                        + "Otherwise, only the first write error will be return") @Nullable List<WriteError> errors
) {
}