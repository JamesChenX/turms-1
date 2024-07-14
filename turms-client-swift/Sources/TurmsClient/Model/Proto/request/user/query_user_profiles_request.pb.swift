// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: request/user/query_user_profiles_request.proto
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

public struct QueryUserProfilesRequest {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    public var userIds: [Int64] = []

    public var lastUpdatedDate: Int64 {
        get { return _lastUpdatedDate ?? 0 }
        set { _lastUpdatedDate = newValue }
    }

    /// Returns true if `lastUpdatedDate` has been explicitly set.
    public var hasLastUpdatedDate: Bool { return _lastUpdatedDate != nil }
    /// Clears the value of `lastUpdatedDate`. Subsequent reads from it will return its default value.
    public mutating func clearLastUpdatedDate() { _lastUpdatedDate = nil }

    public var name: String {
        get { return _name ?? String() }
        set { _name = newValue }
    }

    /// Returns true if `name` has been explicitly set.
    public var hasName: Bool { return _name != nil }
    /// Clears the value of `name`. Subsequent reads from it will return its default value.
    public mutating func clearName() { _name = nil }

    public var skip: Int32 {
        get { return _skip ?? 0 }
        set { _skip = newValue }
    }

    /// Returns true if `skip` has been explicitly set.
    public var hasSkip: Bool { return _skip != nil }
    /// Clears the value of `skip`. Subsequent reads from it will return its default value.
    public mutating func clearSkip() { _skip = nil }

    public var limit: Int32 {
        get { return _limit ?? 0 }
        set { _limit = newValue }
    }

    /// Returns true if `limit` has been explicitly set.
    public var hasLimit: Bool { return _limit != nil }
    /// Clears the value of `limit`. Subsequent reads from it will return its default value.
    public mutating func clearLimit() { _limit = nil }

    public var fieldsToHighlight: [Int32] = []

    public var customAttributes: [Value] = []

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}

    fileprivate var _lastUpdatedDate: Int64?
    fileprivate var _name: String?
    fileprivate var _skip: Int32?
    fileprivate var _limit: Int32?
}

#if swift(>=5.5) && canImport(_Concurrency)
    extension QueryUserProfilesRequest: @unchecked Sendable {}
#endif // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

private let _protobuf_package = "im.turms.proto"

extension QueryUserProfilesRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    public static let protoMessageName: String = _protobuf_package + ".QueryUserProfilesRequest"
    public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .standard(proto: "user_ids"),
        2: .standard(proto: "last_updated_date"),
        3: .same(proto: "name"),
        10: .same(proto: "skip"),
        11: .same(proto: "limit"),
        12: .standard(proto: "fields_to_highlight"),
        15: .standard(proto: "custom_attributes"),
    ]

    public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try decoder.decodeRepeatedInt64Field(value: &userIds)
            case 2: try decoder.decodeSingularInt64Field(value: &_lastUpdatedDate)
            case 3: try decoder.decodeSingularStringField(value: &_name)
            case 10: try decoder.decodeSingularInt32Field(value: &_skip)
            case 11: try decoder.decodeSingularInt32Field(value: &_limit)
            case 12: try decoder.decodeRepeatedInt32Field(value: &fieldsToHighlight)
            case 15: try decoder.decodeRepeatedMessageField(value: &customAttributes)
            default: break
            }
        }
    }

    public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every if/case branch local when no optimizations
        // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
        // https://github.com/apple/swift-protobuf/issues/1182
        if !userIds.isEmpty {
            try visitor.visitPackedInt64Field(value: userIds, fieldNumber: 1)
        }
        try { if let v = self._lastUpdatedDate {
            try visitor.visitSingularInt64Field(value: v, fieldNumber: 2)
        } }()
        try { if let v = self._name {
            try visitor.visitSingularStringField(value: v, fieldNumber: 3)
        } }()
        try { if let v = self._skip {
            try visitor.visitSingularInt32Field(value: v, fieldNumber: 10)
        } }()
        try { if let v = self._limit {
            try visitor.visitSingularInt32Field(value: v, fieldNumber: 11)
        } }()
        if !fieldsToHighlight.isEmpty {
            try visitor.visitPackedInt32Field(value: fieldsToHighlight, fieldNumber: 12)
        }
        if !customAttributes.isEmpty {
            try visitor.visitRepeatedMessageField(value: customAttributes, fieldNumber: 15)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    public static func == (lhs: QueryUserProfilesRequest, rhs: QueryUserProfilesRequest) -> Bool {
        if lhs.userIds != rhs.userIds { return false }
        if lhs._lastUpdatedDate != rhs._lastUpdatedDate { return false }
        if lhs._name != rhs._name { return false }
        if lhs._skip != rhs._skip { return false }
        if lhs._limit != rhs._limit { return false }
        if lhs.fieldsToHighlight != rhs.fieldsToHighlight { return false }
        if lhs.customAttributes != rhs.customAttributes { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}
