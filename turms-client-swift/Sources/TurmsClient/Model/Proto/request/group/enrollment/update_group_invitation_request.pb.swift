// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: request/group/enrollment/update_group_invitation_request.proto
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

public struct UpdateGroupInvitationRequest {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    /// Query filter
    public var invitationID: Int64 = 0

    /// Update
    public var responseAction: ResponseAction = .accept

    public var reason: String {
        get { return _reason ?? String() }
        set { _reason = newValue }
    }

    /// Returns true if `reason` has been explicitly set.
    public var hasReason: Bool { return _reason != nil }
    /// Clears the value of `reason`. Subsequent reads from it will return its default value.
    public mutating func clearReason() { _reason = nil }

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}

    fileprivate var _reason: String?
}

#if swift(>=5.5) && canImport(_Concurrency)
    extension UpdateGroupInvitationRequest: @unchecked Sendable {}
#endif // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

private let _protobuf_package = "im.turms.proto"

extension UpdateGroupInvitationRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    public static let protoMessageName: String = _protobuf_package + ".UpdateGroupInvitationRequest"
    public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .standard(proto: "invitation_id"),
        2: .standard(proto: "response_action"),
        3: .same(proto: "reason"),
    ]

    public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try decoder.decodeSingularInt64Field(value: &invitationID)
            case 2: try decoder.decodeSingularEnumField(value: &responseAction)
            case 3: try decoder.decodeSingularStringField(value: &_reason)
            default: break
            }
        }
    }

    public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every if/case branch local when no optimizations
        // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
        // https://github.com/apple/swift-protobuf/issues/1182
        if invitationID != 0 {
            try visitor.visitSingularInt64Field(value: invitationID, fieldNumber: 1)
        }
        if responseAction != .accept {
            try visitor.visitSingularEnumField(value: responseAction, fieldNumber: 2)
        }
        try { if let v = self._reason {
            try visitor.visitSingularStringField(value: v, fieldNumber: 3)
        } }()
        try unknownFields.traverse(visitor: &visitor)
    }

    public static func == (lhs: UpdateGroupInvitationRequest, rhs: UpdateGroupInvitationRequest) -> Bool {
        if lhs.invitationID != rhs.invitationID { return false }
        if lhs.responseAction != rhs.responseAction { return false }
        if lhs._reason != rhs._reason { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}