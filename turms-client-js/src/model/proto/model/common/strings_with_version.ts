/* eslint-disable */
import Long from "long";
import _m0 from "protobufjs/minimal";

export const protobufPackage = "im.turms.proto";

export interface StringsWithVersion {
  strings: string[];
  lastUpdatedDate?: string | undefined;
}

function createBaseStringsWithVersion(): StringsWithVersion {
  return { strings: [], lastUpdatedDate: undefined };
}

export const StringsWithVersion = {
  encode(message: StringsWithVersion, writer: _m0.Writer = _m0.Writer.create()): _m0.Writer {
    for (const v of message.strings) {
      writer.uint32(10).string(v!);
    }
    if (message.lastUpdatedDate !== undefined) {
      writer.uint32(16).int64(message.lastUpdatedDate);
    }
    return writer;
  },

  decode(input: _m0.Reader | Uint8Array, length?: number): StringsWithVersion {
    const reader = input instanceof _m0.Reader ? input : _m0.Reader.create(input);
    let end = length === undefined ? reader.len : reader.pos + length;
    const message = createBaseStringsWithVersion();
    while (reader.pos < end) {
      const tag = reader.uint32();
      switch (tag >>> 3) {
        case 1:
          if (tag !== 10) {
            break;
          }

          message.strings.push(reader.string());
          continue;
        case 2:
          if (tag !== 16) {
            break;
          }

          message.lastUpdatedDate = longToString(reader.int64() as Long);
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