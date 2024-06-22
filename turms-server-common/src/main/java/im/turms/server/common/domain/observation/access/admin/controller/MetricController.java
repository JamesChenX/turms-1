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

import java.io.IOException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.annotation.Nullable;

import io.micrometer.core.instrument.Meter;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Tag;
import io.micrometer.core.instrument.composite.CompositeMeterRegistry;
import io.micrometer.prometheusmetrics.PrometheusMeterRegistry;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufOutputStream;
import io.netty.buffer.PooledByteBufAllocator;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.context.ApplicationContext;

import im.turms.server.common.access.admin.api.ApiConst;
import im.turms.server.common.access.admin.api.ApiController;
import im.turms.server.common.access.admin.api.ApiEndpoint;
import im.turms.server.common.access.admin.api.ApiEndpointAction;
import im.turms.server.common.access.admin.api.BaseApiController;
import im.turms.server.common.access.admin.api.response.ResponseDTO;
import im.turms.server.common.access.common.ResponseStatusCode;
import im.turms.server.common.domain.common.access.dto.BinaryResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.QueryMetricsAsOpenMetricsTextRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.request.QueryMetricsRequestDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.MetricDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.MetricDTO.MeasurementDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.QueryMetricNamesResponseDTO;
import im.turms.server.common.domain.observation.access.admin.dto.response.QueryMetricsResponseDTO;
import im.turms.server.common.infra.cluster.node.NodeType;
import im.turms.server.common.infra.collection.CollectionUtil;
import im.turms.server.common.infra.exception.ResponseException;
import im.turms.server.common.infra.io.ByteBufFileResource;
import im.turms.server.common.infra.metrics.CsvReporter;
import im.turms.server.common.infra.metrics.MetricsPool;
import im.turms.server.common.infra.netty.ByteBufUtil;

import static im.turms.server.common.infra.http.MediaTypeConst.TEXT_CSV_UTF_8;
import static im.turms.server.common.infra.http.MediaTypeConst.TEXT_PLAIN_UTF_8;
import static im.turms.server.common.infra.unit.ByteSizeUnit.KB;

/**
 * @author James Chen
 */
@ApiController(ApiConst.RESOURCE_PATH_COMMON_MONITOR_METRIC)
public class MetricController extends BaseApiController {

    private static final String APPLICATION_OPENMETRICS_TEXT = "application/openmetrics-text";
    private static final ResponseDTO<QueryMetricsResponseDTO> QUERY_METRICS_RESPONSE_EMPTY =
            ResponseDTO.of(new QueryMetricsResponseDTO(Collections.emptyList()));
    private static final Comparator<Meter.Id> METER_ID_COMPARATOR = (o1, o2) -> {
        int result = o1.getName()
                .compareTo(o2.getName());
        if (result != 0) {
            return result;
        }
        Iterator<Tag> tag1Iterator = o1.getTagsAsIterable()
                .iterator();
        Iterator<Tag> tag2Iterator = o2.getTagsAsIterable()
                .iterator();
        while (true) {
            if (!tag1Iterator.hasNext()) {
                return tag2Iterator.hasNext()
                        ? -1
                        : 0;
            } else if (!tag2Iterator.hasNext()) {
                return 1;
            }
            result = tag1Iterator.next()
                    .compareTo(tag2Iterator.next());
            if (result != 0) {
                return result;
            }
        }
    };
    private final String nodeName;
    private final MetricsPool pool;
    private final PrometheusMeterRegistry prometheusMeterRegistry;

    private int expectedPrometheusDataSize = 8 * KB;

    public MetricController(
            ApplicationContext context,
            NodeType nodeType,
            CompositeMeterRegistry registry) {
        super(context);
        nodeName = nodeType.getDisplayName();
        pool = new MetricsPool(registry);
        PrometheusMeterRegistry found = null;
        for (MeterRegistry meterRegistry : registry.getRegistries()) {
            if (meterRegistry instanceof PrometheusMeterRegistry prometheusMeterRegistry) {
                found = prometheusMeterRegistry;
                break;
            }
        }
        if (found == null) {
            throw new RuntimeException(
                    "No "
                            + PrometheusMeterRegistry.class.getSimpleName()
                            + " instance found in the registry");
        }
        prometheusMeterRegistry = found;
    }

    @ApiEndpoint(action = ApiEndpointAction.QUERY)
    public ResponseDTO<QueryMetricsResponseDTO> queryMetrics(
            @Nullable QueryMetricsRequestDTO request) {
        if (request == null) {
            List<MetricDTO> list = collectionAllMetrics(false, false);
            list = CollectionUtil.sort(list);
            return ResponseDTO.of(new QueryMetricsResponseDTO(list));
        } else if (!request.hasFilter()) {
            List<MetricDTO> list = collectionAllMetrics(false, false);
            list = CollectionUtil.sort(list);
            list = applySkipAndLimit(request, list);
            return ResponseDTO.of(new QueryMetricsResponseDTO(list));
        }
        QueryMetricsRequestDTO.FilterDTO filter = request.filter();
        LinkedHashSet<String> names = filter.names();
        LinkedHashSet<String> tags = filter.tags();
        boolean returnDescription = request.returnDescription();
        boolean returnAvailableTags = request.returnAvailableTags();
        if (names == null) {
            if (tags == null) {
                List<MetricDTO> list = collectionAllMetrics(returnDescription, returnAvailableTags);
                list = CollectionUtil.sort(list);
                list = applySkipAndLimit(request, list);
                return ResponseDTO.of(new QueryMetricsResponseDTO(list));
            } else {
                throw ResponseException.get(ResponseStatusCode.ILLEGAL_ARGUMENT,
                        "\"names\" must be specified if \"tags\" is specified");
            }
        } else if (names.isEmpty()) {
            return QUERY_METRICS_RESPONSE_EMPTY;
        }
        List<MetricDTO> list = new ArrayList<>(names.size());
        for (String name : names) {
            List<Meter> meters;
            try {
                meters = pool.findFirstMatchingMeters(name, tags);
            } catch (Throwable t) {
                throw ResponseException.get(ResponseStatusCode.ILLEGAL_ARGUMENT, t.getMessage());
            }
            if (!meters.isEmpty()) {
                list.add(meters2Dto(name, meters, returnDescription, returnAvailableTags));
            }
        }
        list = CollectionUtil.sort(list);
        list = applySkipAndLimit(request, list);
        return ResponseDTO.of(QueryMetricsResponseDTO.of(list));
    }

    @ApiEndpoint(value = "name", action = ApiEndpointAction.QUERY)
    public ResponseDTO<QueryMetricNamesResponseDTO> getMetricNames() {
        Set<String> sortedNames = pool.collectSortedNames();
        return ResponseDTO.of(QueryMetricNamesResponseDTO.of(sortedNames));
    }

    @ApiEndpoint(value = "as-csv", action = ApiEndpointAction.QUERY, produces = TEXT_CSV_UTF_8)
    public BinaryResponseDTO getCsv(Set<String> names) {
        ByteBuf csv = CsvReporter.scrape(pool, names);
        return BinaryResponseDTO.of(new ByteBufFileResource(
                nodeName
                        + "_"
                        + Instant.now()
                        + ".csv",
                csv));
    }

    @ApiEndpoint(
            value = "as-openmetrics-text",
            action = ApiEndpointAction.QUERY,
            produces = TEXT_PLAIN_UTF_8)
    @Schema(implementation = String.class)
    public ByteBuf scrape(@Nullable QueryMetricsAsOpenMetricsTextRequestDTO request)
            throws IOException {
        Set<String> names;
        boolean hasNames = false;
        if (request == null || !request.hasFilter()) {
            names = null;
        } else {
            names = request.filter()
                    .names();
            if (names != null) {
                if (names.isEmpty()) {
                    return ByteBufUtil.EMPTY_BUFFER;
                } else {
                    hasNames = true;
                }
            }
        }
        ByteBuf buffer = PooledByteBufAllocator.DEFAULT.directBuffer(expectedPrometheusDataSize);
        ByteBufOutputStream outputStream = new ByteBufOutputStream(buffer);
        if (hasNames) {
            prometheusMeterRegistry.scrape(outputStream, APPLICATION_OPENMETRICS_TEXT, names);
        } else {
            prometheusMeterRegistry.scrape(outputStream, APPLICATION_OPENMETRICS_TEXT);
        }
        int actualLength = buffer.readableBytes();
        if (actualLength > expectedPrometheusDataSize) {
            expectedPrometheusDataSize = actualLength + 100;
        } else if (actualLength < (expectedPrometheusDataSize << 1)) {
            expectedPrometheusDataSize <<= 1;
        }
        return buffer;
    }

    private List<MetricDTO> collectionAllMetrics(
            boolean returnDescription,
            boolean returnAvailableTags) {
        Collection<Meter> allMeters = pool.findAllMeters();
        int count = 0;
        Map<Meter.Id, List<Meter>> idToMeters =
                CollectionUtil.newMapWithExpectedSize(allMeters.size());
        for (Meter meter : allMeters) {
            idToMeters.computeIfAbsent(meter.getId(), key -> new ArrayList<>(16))
                    .add(meter);
            count++;
        }
        List<MetricDTO> list = new ArrayList<>(count);
        for (List<Meter> meters : idToMeters.values()) {
            list.add(meters2Dto(meters.getFirst()
                    .getId()
                    .getName(), meters, returnDescription, returnAvailableTags));
        }
        return list;
    }

    private MetricDTO meters2Dto(
            String name,
            Collection<Meter> meters,
            boolean returnDescription,
            boolean returnAvailableTags) {
        Meter.Id meterId = meters.iterator()
                .next()
                .getId();
        String description = returnDescription
                ? meterId.getDescription()
                : null;
        Map<String, Set<String>> availableTags = returnAvailableTags
                ? pool.getAvailableTags(meters)
                : null;
        List<MeasurementDTO> measurements = new ArrayList<>(meters.size());
        for (Meter meter : meters) {
            List<Tag> tags = meter.getId()
                    .getTags();
            List<String> tagNames = new ArrayList<>(tags.size());
            for (Tag tag : tags) {
                tagNames.add(tag.getKey()
                        + ":"
                        + tag.getValue());
            }
            measurements.add(new MeasurementDTO(tagNames, pool.getMeasurements(meter)));
        }
        measurements.sort(null);
        return new MetricDTO(name, description, meterId.getBaseUnit(), measurements, availableTags);
    }

}