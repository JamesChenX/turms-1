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

import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.Objects;
import jakarta.annotation.Nullable;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.mongodb.client.result.DeleteResult;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import reactor.core.publisher.Mono;

import im.turms.server.common.access.common.ResponseStatusCode;

/**
 * @author James Chen
 */
@Accessors(fluent = true)
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@Data
public class ResponseDTO<T extends im.turms.server.common.domain.common.access.dto.ResponseDTO> {

    @JsonIgnore
    @Schema(hidden = true)
    private int httpStatusCode;

    @Schema(description = "The status code")
    private int code;

    @Schema(description = "The description describes the code")
    @Nullable
    private String description;

    @Schema(description = "The unix timestamp in millis when the response is sent")
    private Date timestamp;

    @Schema(description = "The time spent in millis to process the request")
    private long took;

    @Schema(
            description = "The error. If an error occurs, the error field will be present. "
                    + "It is recommended to check if a request is successful by check if the error field is present")
    @Nullable
    private Error error;

    @Schema(
            description = "The data. "
                    + "Note that if the request supports the \"continueOnError\" parameter (the feature is not yet published) "
                    + "and it is specified as true, "
                    + "the data field may still be present. "
                    + "Otherwise, the data field will not exist if an error occurs")
    @Nullable
    private T data;

    public static final ResponseDTO<DeleteResultDTO> DELETE_RESULT_0 = of(DeleteResultDTO.COUNT_0);
    public static final ResponseDTO<DeleteResultDTO> DELETE_RESULT_1 = of(DeleteResultDTO.COUNT_1);
    public static final ResponseDTO<UpdateResultDTO> UPDATE_RESULT_0 =
            of(UpdateResultDTO.MODIFIED_COUNT_0);
    public static final ResponseDTO<UpdateResultDTO> UPDATE_RESULT_1 =
            of(UpdateResultDTO.MODIFIED_COUNT_1);

    public static final Mono<ResponseDTO<DeleteResultDTO>> DELETE_RESULT_0_MONO =
            Mono.just(DELETE_RESULT_0);
    public static final Mono<ResponseDTO<DeleteResultDTO>> DELETE_RESULT_1_MONO =
            Mono.just(DELETE_RESULT_1);
    public static final Mono<ResponseDTO<UpdateResultDTO>> UPDATE_RESULT_0_MONO =
            Mono.just(UPDATE_RESULT_0);
    public static final Mono<ResponseDTO<UpdateResultDTO>> UPDATE_RESULT_1_MONO =
            Mono.just(UPDATE_RESULT_1);

    public ResponseDTO(ResponseStatusCode responseStatusCode) {
        this(responseStatusCode.getHttpStatusCode(),
                responseStatusCode.getBusinessCode(),
                responseStatusCode.getReason(),
                null,
                new Date(),
                null);
    }

    public ResponseDTO(ResponseStatusCode responseStatusCode, @Nullable String reason) {
        this(responseStatusCode.getHttpStatusCode(),
                responseStatusCode.getBusinessCode(),
                reason == null
                        ? responseStatusCode.getReason()
                        : reason,
                null,
                new Date(),
                null);
    }

    public ResponseDTO(
            ResponseStatusCode responseStatusCode,
            @Nullable String reason,
            @Nullable Throwable throwable) {
        this(responseStatusCode.getHttpStatusCode(),
                responseStatusCode.getBusinessCode(),
                reason == null
                        ? responseStatusCode.getReason()
                        : reason,
                throwable == null
                        ? null
                        : throwable.toString(),
                new Date(),
                null);
    }

    public ResponseDTO(ResponseStatusCode responseStatusCode, @Nullable T data) {
        this(responseStatusCode
                .getBusinessCode(), responseStatusCode.getReason(), null, new Date(), data);
    }

    public static final ResponseDTO<Void> RESPONSE_OK = HttpHandlerResult
            .create(HttpResponseStatus.OK, new ResponseDTO<>(ResponseStatusCode.OK, null));

    public static final ResponseDTO<Collection<?>> RESPONSE_EMPTY =
            HttpHandlerResult.create(HttpResponseStatus.OK,
                    new ResponseDTO<>(ResponseStatusCode.OK, Collections.emptyList()));

    public static final ResponseDTO<DeleteResultDTO> RESPONSE_DELETE_RESULT_0 =
            HttpHandlerResult.create(HttpResponseStatus.OK,
                    new ResponseDTO<>(ResponseStatusCode.OK, new DeleteResultDTO(0L)));

    public static final ResponseDTO<?> RESPONSE_NO_CONTENT =
            HttpHandlerResult.create(ResponseStatusCode.NO_CONTENT.getHttpStatusCode(),
                    new ResponseDTO<>(ResponseStatusCode.NO_CONTENT, null));

    public static final Mono<ResponseDTO<DeleteResultDTO>> MONO_RESPONSE_DELETE_RESULT_0 =
            Mono.just(HttpHandlerResult.RESPONSE_DELETE_RESULT_0);

    public static <T> ResponseDTO<Collection<T>> empty() {
        return (HttpHandlerResult) RESPONSE_EMPTY;
    }

//    public static <T>T>
//
//    create(
//            HttpResponseStatus status,
//            @Nullable Map<String, String> headers,
//            @Nullable T body) {
//        return new > (status,headers, body);
//    }
//
//    public static <T>T>
//
//    create(
//            int status,
//            @Nullable Map<String, String> headers,
//            @Nullable T body) {
//        return new > (HttpResponseStatus.valueOf(status),headers, body);
//    }
//
//    public static <T>T>
//
//    create(HttpResponseStatus status) {
//        return new > (status,null, null);
//    }
//
//    public static <T>T>
//
//    create(
//            HttpResponseStatus status,
//            @Nullable Map<String, String> headers) {
//        return new > (status,headers, null);
//    }
//
//    public static <T>T>
//
//    create(HttpResponseStatus status, @Nullable T body) {
//        return new > (status,null, body);
//    }
//
//    public static <T>T>
//
//    create(int status, @Nullable T body) {
//        return new > (HttpResponseStatus.valueOf(status),null, body);
//    }
//
//    public static Response<?>>
//
//    unauthorized(String reason) {
//        return HttpHandlerResult.create(HttpResponseStatus.UNAUTHORIZED,
//                new Response<>(ResponseStatusCode.UNAUTHORIZED, reason));
//    }
//
//    public static Response<?>>
//
//    badRequest(String reason) {
//        return HttpHandlerResult.create(HttpResponseStatus.BAD_REQUEST,
//                new Response<>(ResponseStatusCode.ILLEGAL_ARGUMENT, reason));
//    }
//
//    public static Response<?>>
//
//    internalServerError(String reason) {
//        return HttpHandlerResult.create(HttpResponseStatus.INTERNAL_SERVER_ERROR,
//                new Response<>(ResponseStatusCode.SERVER_INTERNAL_ERROR, reason));
//    }
//
//    public static <T>Response<PaginationDTO<T>>>
//
//    page(
//            long total,
//            Collection<T> data) {
//        if (total <= 0) {
//            throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
//        }
//        PaginationDTO<T> pagination = new PaginationDTO<>(total, data);
//        return of(pagination);
//    }
//
//    public static <T>Mono<Response<PaginationDTO<T>>>>
//
//    page(
//            Mono<Long> totalMono,
//            Flux<T> data) {
//        Mono<PaginationDTO<T>> mono =
//                Mono.zip(totalMono, data.collect(CollectorUtil.toChunkedList()))
//                        .map(tuple -> {
//                            Long total = tuple.getT1();
//                            if (total <= 0L) {
//                                throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
//                            }
//                            return new PaginationDTO<>(total, tuple.getT2());
//                        });
//        return of(mono);
//    }
//
//    public static <T>Mono<Response<PaginationDTO<T>>>>
//
//    page(
//            Mono<Long> totalMono,
//            Mono<List<T>> data) {
//        Mono<PaginationDTO<T>> mono = Mono.zip(totalMono, data)
//                .map(tuple -> {
//                    Long total = tuple.getT1();
//                    if (total <= 0L) {
//                        throw ResponseException.get(ResponseStatusCode.NO_CONTENT);
//                    }
//                    return new PaginationDTO<>(total, tuple.getT2());
//                });
//        return of(mono);
//    }
//
//    public static Mono<Response<UpdateResultDTO>>>
//
//    updateResult(
//            Mono<UpdateResult> data) {
//        return of(data.map(UpdateResultDTO::from));
//    }
//
//    public static Response<UpdateResultDTO>>
//
//    updateResult(long modifiedCount) {
//        return of(new UpdateResultDTO(modifiedCount, modifiedCount));
//    }
//
//    public static Mono<Response<UpdateResultDTO>>>
//
//    updateResultByIntegerMono(
//            Mono<Integer> data) {
//        return of(data.map(number -> {
//            Long count = number.longValue();
//            return new UpdateResultDTO(count, count);
//        }));
//    }
//
//    public static Mono<Response<UpdateResultDTO>>>
//
//    updateResultByLongMono(
//            Mono<Long> data) {
//        return of(data.map(number -> new UpdateResultDTO(number, number)));
//    }
//
//    public static Mono<Response<DeleteResultDTO>>>
//
//    deleteResult(
//            Mono<DeleteResult> data) {
//        return of(data.map(DeleteResultDTO::from));
//    }
//
//    public static Mono<Response<DeleteResultDTO>>>
//
//    deleteResultByLongMono(
//            Mono<Long> data) {
//        return of(data.map(DeleteResultDTO::new));
//    }
//
//    public static Response<DeleteResultDTO>>
//
//    deleteResult(long deletedCount) {
//        return of(new DeleteResultDTO(deletedCount));
//    }
//
//    public static Mono<Response<DeleteResultDTO>>>
//
//    deleteResult0Mono() {
//        return MONO_RESPONSE_DELETE_RESULT_0;
//    }
//
//    public static <T>Mono<Response<Collection<T>>>>
//
//    of(Flux<T> data) {
//        return data.collect(CollectorUtil.toChunkedList())
//                .map(HttpHandlerResult::okIfTruthy);
//    }
//
//    public static <T>Mono<Response<Collection<T>>>>

//    of(
//            Flux<T> data,
//            int estimatedSize) {
//        return data.collect(CollectorUtil.toList(estimatedSize))
//                .map(HttpHandlerResult::okIfTruthy);
//    }
//
//    public static <T>Mono<Response<T>>>
//
//    of(Mono<T> dataMono) {
//        return dataMono
//                .map(data -> HttpHandlerResult.create(HttpResponseStatus.OK,
//                        new Response<>(ResponseStatusCode.OK, data)))
//                .switchIfEmpty(ResponseExceptionPublisherPool.noContent());
//    }

    public static <T extends im.turms.server.common.domain.common.access.dto.ResponseDTO> ResponseDTO<T> of(
            T data) {
        return new ResponseDTO(
                HttpResponseStatus.OK.code(),
                new ResponseDTO<>(ResponseStatusCode.OK, data));
    }

    public static <T extends im.turms.server.common.domain.common.access.dto.ResponseDTO> Mono<ResponseDTO<T>> of(
            Mono<T> mono) {
        return mono.map();
    }

//    public static <T> Response<Collection<T>>> of(Collection<T> data) {
//        if (data == null || data.isEmpty()) {
//            return (HttpHandlerResult) RESPONSE_NO_CONTENT;
//        }
//        return HttpHandlerResult.create(HttpResponseStatus.OK,
//                new Response<>(ResponseStatusCode.OK, data));
//    }

    public static ResponseDTO<UpdateResultDTO> updateResult0() {
        return UPDATE_RESULT_0;
    }

    public static ResponseDTO<UpdateResultDTO> updateResult1() {
        return UPDATE_RESULT_1;
    }

    public static ResponseDTO<DeleteResultDTO> deleteResult0() {
        return DELETE_RESULT_0;
    }

    public static ResponseDTO<DeleteResultDTO> deleteResult1() {
        return DELETE_RESULT_1;
    }

    public static Mono<ResponseDTO<UpdateResultDTO>> updateResult0Mono() {
        return UPDATE_RESULT_0_MONO;
    }

    public static Mono<ResponseDTO<UpdateResultDTO>> updateResult1Mono() {
        return UPDATE_RESULT_1_MONO;
    }

    public static Mono<ResponseDTO<DeleteResultDTO>> deleteResult0Mono() {
        return DELETE_RESULT_0_MONO;
    }

    public static Mono<ResponseDTO<DeleteResultDTO>> deleteResult1Mono() {
        return DELETE_RESULT_1_MONO;
    }

    public static Mono<ResponseDTO<DeleteResultDTO>> deleteResultMono(Mono<Integer> mono) {
        return mono.map(number -> of(new DeleteResultDTO(number.longValue())));
    }

    public static ResponseDTO<DeleteResultDTO> deleteResult(long deletedCount) {
        return of(new DeleteResultDTO(deletedCount));
    }

    public static Mono<ResponseDTO<DeleteResultDTO>> deleteResult(
            Mono<DeleteResult> deleteResultMono) {
        return deleteResultMono
                .map(deleteResult -> ResponseDTO.deleteResult(deleteResult.getDeletedCount()));
    }

    public static Mono<ResponseDTO<DeleteResultDTO>> deleteResultFromLongMono(
            Mono<Long> deletedCountMono) {
        return deletedCountMono.map(ResponseDTO::deleteResult);
    }

    public static Mono<ResponseDTO<DeleteResultDTO>> deleteResultFromIntegerMono(
            Mono<Integer> deletedCountMono) {
        return deletedCountMono.map(ResponseDTO::deleteResult);
    }

    public static ResponseDTO<UpdateResultDTO> updateResult(long modifiedCount) {
        return of(new UpdateResultDTO(modifiedCount, modifiedCount));
    }

    public static Mono<ResponseDTO<UpdateResultDTO>> updateResultFromIntegerMono(
            Mono<Integer> updatedCountMono) {
        return updatedCountMono.map(ResponseDTO::updateResult);
    }

    public static Mono<ResponseDTO<UpdateResultDTO>> updateResultFromLongMono(
            Mono<Long> updatedCountMono) {
        return updatedCountMono.map(ResponseDTO::updateResult);
    }

}