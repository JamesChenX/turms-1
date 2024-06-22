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

package im.turms.plugin.minio.dto;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonProperty;

import im.turms.server.common.domain.common.access.dto.ControllerDTO;

/**
 * @author James Chen
 */
public record HandleEventNotificationRequestDTO(
        @JsonProperty("EventName") String eventName,
        @JsonProperty("Records") List<Record> records,
        @JsonProperty("Key") String key,
        Map<String, String> other
) implements ControllerDTO {

    public HandleEventNotificationRequestDTO {
        if (other == null) {
            other = new ConcurrentHashMap<>(16);
        }
    }

    @JsonAnyGetter
    public Map<String, String> any() {
        return other;
    }

    @JsonAnySetter
    public void set(String name, String value) {
        other.put(name, value);
    }

    public record Record(
            String eventVersion,
            String eventSource,
            String awsRegion,
            Date eventTime,
            String eventName,
            UserIdentity userIdentity,
            RequestParameters requestParameters,
            ResponseElements responseElements,
            S3 s3,
            Source source
    ) {
    }

    public record UserIdentity(
            String principalId
    ) {
    }

    public record RequestParameters(
            String principalId,
            String region,
            @JsonProperty("sourceIPAddress") String sourceIpAddress
    ) {
    }

    public record ResponseElements(
            @JsonProperty("x-amz-id-2") String xAmzId2,
            @JsonProperty("x-amz-request-id") String xAmzRequestId,
            @JsonProperty("x-minio-deployment-id") String xMinioDeploymentId,
            @JsonProperty("x-minio-origin-endpoint") String xMinioOriginEndpoint
    ) {
    }

    public record S3(
            String s3SchemaVersion,
            String configurationId,
            Bucket bucket,
            Object object
    ) {
    }

    public record Bucket(
            String name,
            OwnerIdentity ownerIdentity,
            String arn
    ) {
    }

    public record Object(
            String key,
            int size,
            String eTag,
            String contentType,
            UserMetadata userMetadata,
            String sequencer
    ) {
    }

    public record UserMetadata(
            @JsonProperty("content-type") String contentType
    ) {
    }

    public record OwnerIdentity(
            String principalId
    ) {
    }

    public record Source(
            String host,
            String port,
            String userAgent
    ) {
    }
}