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

package im.turms.plugin.antispam.controller;

import java.util.Collections;
import java.util.List;
import jakarta.annotation.Nullable;

import org.springframework.context.ApplicationContext;

import im.turms.plugin.antispam.AntiSpamHandler;
import im.turms.plugin.antispam.core.exception.CorruptedTrieDataException;
import im.turms.plugin.antispam.dto.DetectTextResultRequestDTO;
import im.turms.plugin.antispam.dto.DetectTextResultResponseDTO;
import im.turms.plugin.antispam.dto.UpdateTextTrieRequestDTO;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.admin.api.response.UpdateResultDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.FileDTO;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.exception.ThrowableUtil;
import im.turms.server.common.infra.exception.WriteRecordsException;
import im.turms.server.common.infra.io.FileHolder;
import im.turms.server.common.infra.lang.Pair;

/**
 * @author James Chen
 */
@ApiController("content-moderation")
public class ContentModerationController extends BaseApiController {

    private final AntiSpamHandler antiSpamHandler;

    public ContentModerationController(
            ApplicationContext context,
            AntiSpamHandler antiSpamHandler) {
        super(context);
        this.antiSpamHandler = antiSpamHandler;
    }

    @ApiEndpoint(value = "text", action = ApiEndpointAction.QUERY)
    ResponseDTO<DetectTextResultResponseDTO> detectUnwantedWords(
            @Nullable DetectTextResultRequestDTO request) {
        if (request == null) {
            return ResponseDTO.of(new DetectTextResultResponseDTO("", Collections.emptyList()));
        }
        Pair<String, List<String>> result = antiSpamHandler.detectUnwantedWords(request.text(),
                request.maxUnwantedWordCount(),
                request.mask());
        return ResponseDTO.of(new DetectTextResultResponseDTO(result.first(), result.second()));
    }

    @ApiEndpoint(value = "text/trie", action = ApiEndpointAction.UPDATE)
    ResponseDTO<UpdateResultDTO> updateTextTrie(UpdateTextTrieRequestDTO request) {
        FileDTO trieFile = request.update()
                .trie();
        FileHolder file = trieFile.fileHolder();
        String binFilePath = file.file()
                .toPath()
                .toAbsolutePath()
                .normalize()
                .toString();
        try {
            antiSpamHandler.updateTrie(binFilePath);
        } catch (Exception e) {
            if (ThrowableUtil.contains(e, CorruptedTrieDataException.class)) {
                throw ResponseException.get(ResponseStatusCode.ILLEGAL_ARGUMENT, e.getMessage());
            }
            throw new WriteRecordsException(0, e);
        }
        return ResponseDTO.updateResult1();
    }
}