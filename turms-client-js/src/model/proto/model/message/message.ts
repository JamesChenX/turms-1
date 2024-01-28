/* eslint-disable */
import Long from "long";
import _m0 from "protobufjs/minimal";

export const protobufPackage = "im.turms.proto";

export interface Message {
  id?: string | undefined;
  deliveryDate?: string | undefined;
  modificationDate?: string | undefined;
  text?: string | undefined;
  senderId?: string | undefined;
  groupId?: string | undefined;
  isSystemMessage?: boolean | undefined;
  recipientId?: string | undefined;
  records: Uint8Array[];
  sequenceId?: number | undefined;
  preMessageId?: string | undefined;
}

function createBaseMessage(): Message {
  return {
    id: undefined,
    deliveryDate: undefined,
    modificationDate: undefined,
    text: undefined,
    senderId: undefined,
    groupId: undefined,
    isSystemMessage: undefined,
    recipientId: undefined,
    records: [],
    sequenceId: undefined,
    preMessageId: undefined,
  };
}

export const Message = {
  encode(message: Message, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    if (message.id !== undefined) {
      writer.uint32(8).int64(message.id);
    }
    if (message.deliveryDate !== undefined) {
      writer.uint32(16).int64(message.deliveryDate);
    }
    if (message.modificationDate !== undefined) {
      writer.uint32(24).int64(message.modificationDate);
    }
    if (message.text !== undefined) {
      writer.uint32(34).string(message.text);
    }
    if (message.senderId !== undefined) {
      writer.uint32(40).int64(message.senderId);
    }
    if (message.groupId !== undefined) {
      writer.uint32(48).int64(message.groupId);
    }
    if (message.isSystemMessage !== undefined) {
      writer.uint32(56).bool(message.isSystemMessage);
    }
    if (message.recipientId !== undefined) {
      writer.uint32(64).int64(message.recipientId);
    }
    for (const v of message.records) {
      writer.uint32(74).bytes(v!);
    }
    if (message.sequenceId !== undefined) {
      writer.uint32(80).int32(message.sequenceId);
    }
    if (message.preMessageId !== undefined) {
      writer.uint32(88).int64(message.preMessageId);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): Message {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseMessage();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 8) {
            break;
          }

          message.id = longToString(reader.int64() as Long);
          continue;
        case 2:
          if (tag !== 16) {
            break;
          }

          message.deliveryDate = longToString(reader.int64() as Long);
          continue;
        case 3:
          if (tag !== 24) {
            break;
          }

          message.modificationDate = longToString(reader.int64() as Long);
          continue;
        case 4:
          if (tag !== 34) {
            break;
          }

          message.text = reader.string();
          continue;
        case 5:
          if (tag !== 40) {
            break;
          }

          message.senderId = longToString(reader.int64() as Long);
          continue;
        case 6:
          if (tag !== 48) {
            break;
          }

          message.groupId = longToString(reader.int64() as Long);
          continue;
        case 7:
          if (tag !== 56) {
            break;
          }

          message.isSystemMessage = reader.bool();
          continue;
        case 8:
          if (tag !== 64) {
            break;
          }

          message.recipientId = longToString(reader.int64() as Long);
          continue;
        case 9:
          if (tag !== 74) {
            break;
          }

          message.records.push(reader.bytes());
          continue;
        case 10:
          if (tag !== 80) {
            break;
          }

          message.sequenceId = reader.int32();
          continue;
        case 11:
          if (tag !== 88) {
            break;
          }

          message.preMessageId = longToString(reader.int64() as Long);
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