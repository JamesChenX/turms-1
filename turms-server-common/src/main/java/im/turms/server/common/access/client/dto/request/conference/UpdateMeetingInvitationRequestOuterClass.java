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

package im.turms.server.common.access.client.dto.request.conference;

public final class UpdateMeetingInvitationRequestOuterClass {
    private UpdateMeetingInvitationRequestOuterClass() {
    }

    static {
        com.google.protobuf.RuntimeVersion.validateProtobufGencodeVersion(
                com.google.protobuf.RuntimeVersion.RuntimeDomain.PUBLIC,
                /* major= */ 4,
                /* minor= */ 26,
                /* patch= */ 1,
                /* suffix= */ "",
                UpdateMeetingInvitationRequestOuterClass.class.getName());
    }

    public static void registerAllExtensions(com.google.protobuf.ExtensionRegistryLite registry) {
    }

    public static void registerAllExtensions(com.google.protobuf.ExtensionRegistry registry) {
        registerAllExtensions((com.google.protobuf.ExtensionRegistryLite) registry);
    }

    static final com.google.protobuf.Descriptors.Descriptor internal_static_im_turms_proto_UpdateMeetingInvitationRequest_descriptor;
    static final com.google.protobuf.GeneratedMessage.FieldAccessorTable internal_static_im_turms_proto_UpdateMeetingInvitationRequest_fieldAccessorTable;

    public static com.google.protobuf.Descriptors.FileDescriptor getDescriptor() {
        return descriptor;
    }

    private static final com.google.protobuf.Descriptors.FileDescriptor descriptor;
    static {
        java.lang.String[] descriptorData = {"\n:request/conference/update_meeting_invi"
                + "tation_request.proto\022\016im.turms.proto\032\036co"
                + "nstant/response_action.proto\"\221\001\n\036UpdateM"
                + "eetingInvitationRequest\022\022\n\nmeeting_id\030\001 "
                + "\001(\003\022\025\n\010password\030\002 \001(\tH\000\210\001\001\0227\n\017response_a"
                + "ction\030\005 \001(\0162\036.im.turms.proto.ResponseAct"
                + "ionB\013\n\t_passwordBB\n;im.turms.server.comm"
                + "on.access.client.dto.request.conferenceP"
                + "\001\272\002\000b\006proto3"};
        descriptor = com.google.protobuf.Descriptors.FileDescriptor.internalBuildGeneratedFileFrom(
                descriptorData,
                new com.google.protobuf.Descriptors.FileDescriptor[]{
                        im.turms.server.common.access.client.dto.constant.ResponseActionOuterClass
                                .getDescriptor(),});
        internal_static_im_turms_proto_UpdateMeetingInvitationRequest_descriptor =
                getDescriptor().getMessageTypes()
                        .get(0);
        internal_static_im_turms_proto_UpdateMeetingInvitationRequest_fieldAccessorTable =
                new com.google.protobuf.GeneratedMessage.FieldAccessorTable(
                        internal_static_im_turms_proto_UpdateMeetingInvitationRequest_descriptor,
                        new java.lang.String[]{"MeetingId", "Password", "ResponseAction",});
        descriptor.resolveAllFeaturesImmutable();
        im.turms.server.common.access.client.dto.constant.ResponseActionOuterClass.getDescriptor();
    }

    // @@protoc_insertion_point(outer_class_scope)
}