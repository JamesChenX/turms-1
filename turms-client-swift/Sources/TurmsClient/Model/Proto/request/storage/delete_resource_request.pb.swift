// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: request/storage/delete_resource_request.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
private struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
    struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
    typealias Version = _2
}

public struct DeleteResourceRequest {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    public var type: StorageResourceType = .userProfilePicture

    public var idNum: Int64 {
        get { return _idNum ?? 0 }
        set { _idNum = newValue }
    }

    /// Returns true if `idNum` has been explicitly set.
    public var hasIDNum: Bool { return _idNum != nil }
    /// Clears the value of `idNum`. Subsequent reads from it will return its default value.
    public mutating func clearIDNum() { _idNum = nil }

    public var idStr: String {
        get { return _idStr ?? String() }
        set { _idStr = newValue }
    }

    /// Returns true if `idStr` has been explicitly set.
    public var hasIDStr: Bool { return _idStr != nil }
    /// Clears the value of `idStr`. Subsequent reads from it will return its default value.
    public mutating func clearIDStr() { _idStr = nil }

    public var extra: [String: String] = [:]

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}

    fileprivate var _idNum: Int64?
    fileprivate var _idStr: String?
}

#if swift(>=5.5) && canImport(_Concurrency)
    extension DeleteResourceRequest: @unchecked Sendable {}
#endif // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

private let _protobuf_package = "im.turms.proto"

extension DeleteResourceRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    public static let protoMessageName: String = _protobuf_package + ".DeleteResourceRequest"
    public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .same(proto: "type"),
        2: .standard(proto: "id_num"),
        3: .standard(proto: "id_str"),
        4: .same(proto: "extra"),
    ]

    public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try decoder.decodeSingularEnumField(value: &type)
            case 2: try decoder.decodeSingularInt64Field(value: &_idNum)
            case 3: try decoder.decodeSingularStringField(value: &_idStr)
            case 4: try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString, SwiftProtobuf.ProtobufString>.self, value: &extra)
            default: break
            }
        }
    }

    public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every if/case branch local when no optimizations
        // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
        // https://github.com/apple/swift-protobuf/issues/1182
        if type != .userProfilePicture {
            try visitor.visitSingularEnumField(value: type, fieldNumber: 1)
        }
        try { if let v = self._idNum {
            try visitor.visitSingularInt64Field(value: v, fieldNumber: 2)
        } }()
        try { if let v = self._idStr {
            try visitor.visitSingularStringField(value: v, fieldNumber: 3)
        } }()
        if !extra.isEmpty {
            try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufString, SwiftProtobuf.ProtobufString>.self, value: extra, fieldNumber: 4)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    public static func == (lhs: DeleteResourceRequest, rhs: DeleteResourceRequest) -> Bool {
        if lhs.type != rhs.type { return false }
        if lhs._idNum != rhs._idNum { return false }
        if lhs._idStr != rhs._idStr { return false }
        if lhs.extra != rhs.extra { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}
