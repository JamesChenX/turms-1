/* eslint-disable */
import Long from "long";
import _m0 from "protobufjs/minimal";

export const protobufPackage = "im.turms.proto";

export interface QueryMessagesRequest {
  /** Filter */
  ids: string[];
  areGroupMessages?: boolean | undefined;
  areSystemMessages?: boolean | undefined;
  fromIds: string[];
  deliveryDateStart?: string | undefined;
  deliveryDateEnd?:
    | string
    | undefined;
  /** Option */
  maxCount?:
    | number
    | undefined;
  /** Command */
  withTotal: boolean;
  /**
   * Option
   * TODO: reorder
   */
  descending?: boolean | undefined;
}

function createBaseQueryMessagesRequest(): QueryMessagesRequest {
  return {
    ids: [],
    areGroupMessages: undefined,
    areSystemMessages: undefined,
    fromIds: [],
    deliveryDateStart: undefined,
    deliveryDateEnd: undefined,
    maxCount: undefined,
    withTotal: false,
    descending: undefined,
  };
}

export const QueryMessagesRequest = {
  encode(message: QueryMessagesRequest, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    writer.uint32(10).fork();
    for (const v of message.ids) {
      writer.int64(v);
    }
    writer.ldelim();
    if (message.areGroupMessages !== undefined) {
      writer.uint32(16).bool(message.areGroupMessages);
    }
    if (message.areSystemMessages !== undefined) {
      writer.uint32(24).bool(message.areSystemMessages);
    }
    writer.uint32(34).fork();
    for (const v of message.fromIds) {
      writer.int64(v);
    }
    writer.ldelim();
    if (message.deliveryDateStart !== undefined) {
      writer.uint32(40).int64(message.deliveryDateStart);
    }
    if (message.deliveryDateEnd !== undefined) {
      writer.uint32(48).int64(message.deliveryDateEnd);
    }
    if (message.maxCount !== undefined) {
      writer.uint32(56).int32(message.maxCount);
    }
    if (message.withTotal === true) {
      writer.uint32(64).bool(message.withTotal);
    }
    if (message.descending !== undefined) {
      writer.uint32(72).bool(message.descending);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): QueryMessagesRequest {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseQueryMessagesRequest();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag === 8) {
            message.ids.push(longToString(reader.int64() as Long));

            continue;
          }

          if (tag === 10) {
            const end2 = reader.uint32() + reader.pos;
            while (reader.pos < end2) {
              message.ids.push(longToString(reader.int64() as Long));
            }

            continue;
          }

          break;
        case 2:
          if (tag !== 16) {
            break;
          }

          message.areGroupMessages = reader.bool();
          continue;
        case 3:
          if (tag !== 24) {
            break;
          }

          message.areSystemMessages = reader.bool();
          continue;
        case 4:
          if (tag === 32) {
            message.fromIds.push(longToString(reader.int64() as Long));

            continue;
          }

          if (tag === 34) {
            const end2 = reader.uint32() + reader.pos;
            while (reader.pos < end2) {
              message.fromIds.push(longToString(reader.int64() as Long));
            }

            continue;
          }

          break;
        case 5:
          if (tag !== 40) {
            break;
          }

          message.deliveryDateStart = longToString(reader.int64() as Long);
          continue;
        case 6:
          if (tag !== 48) {
            break;
          }

          message.deliveryDateEnd = longToString(reader.int64() as Long);
          continue;
        case 7:
          if (tag !== 56) {
            break;
          }

          message.maxCount = reader.int32();
          continue;
        case 8:
          if (tag !== 64) {
            break;
          }

          message.withTotal = reader.bool();
          continue;
        case 9:
          if (tag !== 72) {
            break;
          }

          message.descending = reader.bool();
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