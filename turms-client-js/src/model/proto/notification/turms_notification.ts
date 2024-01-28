/* eslint-disable */
import Long from "long";
import _m0 from "protobufjs/minimal";
import { LongsWithVersion } from "../model/common/longs_with_version";
import { StringsWithVersion } from "../model/common/strings_with_version";
import { Conversations } from "../model/conversation/conversations";
import { GroupInvitationsWithVersion } from "../model/group/group_invitations_with_version";
import { GroupJoinQuestionsAnswerResult } from "../model/group/group_join_questions_answer_result";
import { GroupJoinQuestionsWithVersion } from "../model/group/group_join_questions_with_version";
import { GroupJoinRequestsWithVersion } from "../model/group/group_join_requests_with_version";
import { GroupMembersWithVersion } from "../model/group/group_members_with_version";
import { GroupsWithVersion } from "../model/group/groups_with_version";
import { Messages } from "../model/message/messages";
import { MessagesWithTotalList } from "../model/message/messages_with_total_list";
import { StorageResourceInfos } from "../model/storage/storage_resource_infos";
import { NearbyUsers } from "../model/user/nearby_users";
import { UserFriendRequestsWithVersion } from "../model/user/user_friend_requests_with_version";
import { UserInfosWithVersion } from "../model/user/user_infos_with_version";
import { UserOnlineStatuses } from "../model/user/user_online_statuses";
import { UserRelationshipGroupsWithVersion } from "../model/user/user_relationship_groups_with_version";
import { UserRelationshipsWithVersion } from "../model/user/user_relationships_with_version";
import { UserSession } from "../model/user/user_session";
import { TurmsRequest } from "../request/turms_request";

export const protobufPackage = "im.turms.proto";

export interface TurmsNotification {
  /** Common => [1, 3] */
  timestamp: string;
  /**
   * Response => [4, 9]
   * "request_id" is used to tell the client that
   * this notification is a response to the specific request
   */
  requestId?: string | undefined;
  code?: number | undefined;
  reason?: string | undefined;
  data?:
    | TurmsNotification_Data
    | undefined;
  /**
   * Notification => [10, 15]
   * "requester_id" only exists when a requester triggers a notification to its recipients
   * Note: Do not move "requester_id" to TurmsRequest because it requires rebuilding
   * a new TurmsNotification when recipients need "requester_id".
   */
  requesterId?: string | undefined;
  closeStatus?: number | undefined;
  relayedRequest?: TurmsRequest | undefined;
}

export interface TurmsNotification_Data {
  /** Common */
  long?: string | undefined;
  string?: string | undefined;
  longsWithVersion?: LongsWithVersion | undefined;
  stringsWithVersion?:
    | StringsWithVersion
    | undefined;
  /** Conversation */
  conversations?:
    | Conversations
    | undefined;
  /** Message */
  messages?: Messages | undefined;
  messagesWithTotalList?:
    | MessagesWithTotalList
    | undefined;
  /** User */
  userSession?: UserSession | undefined;
  userInfosWithVersion?: UserInfosWithVersion | undefined;
  userOnlineStatuses?: UserOnlineStatuses | undefined;
  userFriendRequestsWithVersion?: UserFriendRequestsWithVersion | undefined;
  userRelationshipGroupsWithVersion?: UserRelationshipGroupsWithVersion | undefined;
  userRelationshipsWithVersion?: UserRelationshipsWithVersion | undefined;
  nearbyUsers?:
    | NearbyUsers
    | undefined;
  /** Group */
  groupInvitationsWithVersion?: GroupInvitationsWithVersion | undefined;
  groupJoinQuestionAnswerResult?: GroupJoinQuestionsAnswerResult | undefined;
  groupJoinRequestsWithVersion?: GroupJoinRequestsWithVersion | undefined;
  groupJoinQuestionsWithVersion?: GroupJoinQuestionsWithVersion | undefined;
  groupMembersWithVersion?: GroupMembersWithVersion | undefined;
  groupsWithVersion?:
    | GroupsWithVersion
    | undefined;
  /** Storage */
  storageResourceInfos?: StorageResourceInfos | undefined;
}

function createBaseTurmsNotification(): TurmsNotification {
  return {
    timestamp: "0",
    requestId: undefined,
    code: undefined,
    reason: undefined,
    data: undefined,
    requesterId: undefined,
    closeStatus: undefined,
    relayedRequest: undefined,
  };
}

export const TurmsNotification = {
  encode(message: TurmsNotification, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.timestamp !== "0") {
      writer.uint32(8).int64(message.timestamp);
    }
    if (message.requestId !== undefined) {
      writer.uint32(32).int64(message.requestId);
    }
    if (message.code !== undefined) {
      writer.uint32(40).int32(message.code);
    }
    if (message.reason !== undefined) {
      writer.uint32(50).string(message.reason);
    }
    if (message.data !== undefined) {
      TurmsNotification_Data.encode(message.data, writer.uint32(58).fork()).ldelim();
    }
    if (message.requesterId !== undefined) {
      writer.uint32(80).int64(message.requesterId);
    }
    if (message.closeStatus !== undefined) {
      writer.uint32(88).int32(message.closeStatus);
    }
    if (message.relayedRequest !== undefined) {
      TurmsRequest.encode(message.relayedRequest, writer.uint32(98).fork()).ldelim();
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): TurmsNotification {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseTurmsNotification();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 8) {
            break;
          }

          message.timestamp = longToString(reader.int64() as Long);
          continue;
        case 4:
          if (tag !== 32) {
            break;
          }

          message.requestId = longToString(reader.int64() as Long);
          continue;
        case 5:
          if (tag !== 40) {
            break;
          }

          message.code = reader.int32();
          continue;
        case 6:
          if (tag !== 50) {
            break;
          }

          message.reason = reader.string();
          continue;
        case 7:
          if (tag !== 58) {
            break;
          }

          message.data = TurmsNotification_Data.decode(reader, reader.uint32());
          continue;
        case 10:
          if (tag !== 80) {
            break;
          }

          message.requesterId = longToString(reader.int64() as Long);
          continue;
        case 11:
          if (tag !== 88) {
            break;
          }

          message.closeStatus = reader.int32();
          continue;
        case 12:
          if (tag !== 98) {
            break;
          }

          message.relayedRequest = TurmsRequest.decode(reader, reader.uint32());
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },
};

function createBaseTurmsNotification_Data(): TurmsNotification_Data {
  return {
    long: undefined,
    string: undefined,
    longsWithVersion: undefined,
    stringsWithVersion: undefined,
    conversations: undefined,
    messages: undefined,
    messagesWithTotalList: undefined,
    userSession: undefined,
    userInfosWithVersion: undefined,
    userOnlineStatuses: undefined,
    userFriendRequestsWithVersion: undefined,
    userRelationshipGroupsWithVersion: undefined,
    userRelationshipsWithVersion: undefined,
    nearbyUsers: undefined,
    groupInvitationsWithVersion: undefined,
    groupJoinQuestionAnswerResult: undefined,
    groupJoinRequestsWithVersion: undefined,
    groupJoinQuestionsWithVersion: undefined,
    groupMembersWithVersion: undefined,
    groupsWithVersion: undefined,
    storageResourceInfos: undefined,
  };
}

export const TurmsNotification_Data = {
  encode(message: TurmsNotification_Data, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.long !== undefined) {
      writer.uint32(8).int64(message.long);
    }
    if (message.string !== undefined) {
      writer.uint32(18).string(message.string);
    }
    if (message.longsWithVersion !== undefined) {
      LongsWithVersion.encode(message.longsWithVersion, writer.uint32(26).fork()).ldelim();
    }
    if (message.stringsWithVersion !== undefined) {
      StringsWithVersion.encode(message.stringsWithVersion, writer.uint32(34).fork()).ldelim();
    }
    if (message.conversations !== undefined) {
      Conversations.encode(message.conversations, writer.uint32(42).fork()).ldelim();
    }
    if (message.messages !== undefined) {
      Messages.encode(message.messages, writer.uint32(50).fork()).ldelim();
    }
    if (message.messagesWithTotalList !== undefined) {
      MessagesWithTotalList.encode(message.messagesWithTotalList, writer.uint32(58).fork()).ldelim();
    }
    if (message.userSession !== undefined) {
      UserSession.encode(message.userSession, writer.uint32(66).fork()).ldelim();
    }
    if (message.userInfosWithVersion !== undefined) {
      UserInfosWithVersion.encode(message.userInfosWithVersion, writer.uint32(74).fork()).ldelim();
    }
    if (message.userOnlineStatuses !== undefined) {
      UserOnlineStatuses.encode(message.userOnlineStatuses, writer.uint32(82).fork()).ldelim();
    }
    if (message.userFriendRequestsWithVersion !== undefined) {
      UserFriendRequestsWithVersion.encode(message.userFriendRequestsWithVersion, writer.uint32(90).fork()).ldelim();
    }
    if (message.userRelationshipGroupsWithVersion !== undefined) {
      UserRelationshipGroupsWithVersion.encode(message.userRelationshipGroupsWithVersion, writer.uint32(98).fork())
        .ldelim();
    }
    if (message.userRelationshipsWithVersion !== undefined) {
      UserRelationshipsWithVersion.encode(message.userRelationshipsWithVersion, writer.uint32(106).fork()).ldelim();
    }
    if (message.nearbyUsers !== undefined) {
      NearbyUsers.encode(message.nearbyUsers, writer.uint32(114).fork()).ldelim();
    }
    if (message.groupInvitationsWithVersion !== undefined) {
      GroupInvitationsWithVersion.encode(message.groupInvitationsWithVersion, writer.uint32(122).fork()).ldelim();
    }
    if (message.groupJoinQuestionAnswerResult !== undefined) {
      GroupJoinQuestionsAnswerResult.encode(message.groupJoinQuestionAnswerResult, writer.uint32(130).fork()).ldelim();
    }
    if (message.groupJoinRequestsWithVersion !== undefined) {
      GroupJoinRequestsWithVersion.encode(message.groupJoinRequestsWithVersion, writer.uint32(138).fork()).ldelim();
    }
    if (message.groupJoinQuestionsWithVersion !== undefined) {
      GroupJoinQuestionsWithVersion.encode(message.groupJoinQuestionsWithVersion, writer.uint32(146).fork()).ldelim();
    }
    if (message.groupMembersWithVersion !== undefined) {
      GroupMembersWithVersion.encode(message.groupMembersWithVersion, writer.uint32(154).fork()).ldelim();
    }
    if (message.groupsWithVersion !== undefined) {
      GroupsWithVersion.encode(message.groupsWithVersion, writer.uint32(162).fork()).ldelim();
    }
    if (message.storageResourceInfos !== undefined) {
      StorageResourceInfos.encode(message.storageResourceInfos, writer.uint32(402).fork()).ldelim();
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): TurmsNotification_Data {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseTurmsNotification_Data();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 8) {
            break;
          }

          message.long = longToString(reader.int64() as Long);
          continue;
        case 2:
          if (tag !== 18) {
            break;
          }

          message.string = reader.string();
          continue;
        case 3:
          if (tag !== 26) {
            break;
          }

          message.longsWithVersion = LongsWithVersion.decode(reader, reader.uint32());
          continue;
        case 4:
          if (tag !== 34) {
            break;
          }

          message.stringsWithVersion = StringsWithVersion.decode(reader, reader.uint32());
          continue;
        case 5:
          if (tag !== 42) {
            break;
          }

          message.conversations = Conversations.decode(reader, reader.uint32());
          continue;
        case 6:
          if (tag !== 50) {
            break;
          }

          message.messages = Messages.decode(reader, reader.uint32());
          continue;
        case 7:
          if (tag !== 58) {
            break;
          }

          message.messagesWithTotalList = MessagesWithTotalList.decode(reader, reader.uint32());
          continue;
        case 8:
          if (tag !== 66) {
            break;
          }

          message.userSession = UserSession.decode(reader, reader.uint32());
          continue;
        case 9:
          if (tag !== 74) {
            break;
          }

          message.userInfosWithVersion = UserInfosWithVersion.decode(reader, reader.uint32());
          continue;
        case 10:
          if (tag !== 82) {
            break;
          }

          message.userOnlineStatuses = UserOnlineStatuses.decode(reader, reader.uint32());
          continue;
        case 11:
          if (tag !== 90) {
            break;
          }

          message.userFriendRequestsWithVersion = UserFriendRequestsWithVersion.decode(reader, reader.uint32());
          continue;
        case 12:
          if (tag !== 98) {
            break;
          }

          message.userRelationshipGroupsWithVersion = UserRelationshipGroupsWithVersion.decode(reader, reader.uint32());
          continue;
        case 13:
          if (tag !== 106) {
            break;
          }

          message.userRelationshipsWithVersion = UserRelationshipsWithVersion.decode(reader, reader.uint32());
          continue;
        case 14:
          if (tag !== 114) {
            break;
          }

          message.nearbyUsers = NearbyUsers.decode(reader, reader.uint32());
          continue;
        case 15:
          if (tag !== 122) {
            break;
          }

          message.groupInvitationsWithVersion = GroupInvitationsWithVersion.decode(reader, reader.uint32());
          continue;
        case 16:
          if (tag !== 130) {
            break;
          }

          message.groupJoinQuestionAnswerResult = GroupJoinQuestionsAnswerResult.decode(reader, reader.uint32());
          continue;
        case 17:
          if (tag !== 138) {
            break;
          }

          message.groupJoinRequestsWithVersion = GroupJoinRequestsWithVersion.decode(reader, reader.uint32());
          continue;
        case 18:
          if (tag !== 146) {
            break;
          }

          message.groupJoinQuestionsWithVersion = GroupJoinQuestionsWithVersion.decode(reader, reader.uint32());
          continue;
        case 19:
          if (tag !== 154) {
            break;
          }

          message.groupMembersWithVersion = GroupMembersWithVersion.decode(reader, reader.uint32());
          continue;
        case 20:
          if (tag !== 162) {
            break;
          }

          message.groupsWithVersion = GroupsWithVersion.decode(reader, reader.uint32());
          continue;
        case 50:
          if (tag !== 402) {
            break;
          }

          message.storageResourceInfos = StorageResourceInfos.decode(reader, reader.uint32());
          continue;
      }
      if ((tag & 7) === 4 || tag === 0) {
        break;
      }
      reader.skipType(tag & 7);
    }
    return message;
  },
};

function longToString(long: Long) {
  return long.toString();
}

if (_m0.util.Long !== Long) {
  _m0.util.Long = Long as any;
  _m0.configure();
}