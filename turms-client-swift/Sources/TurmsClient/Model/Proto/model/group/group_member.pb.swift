// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: model/group/group_member.proto
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

public struct GroupMember {
    // SwiftProtobuf.Message conformance is added in an extension below. See the
    // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
    // methods supported on all messages.

    public var groupID: Int64 {
        get { return _groupID ?? 0 }
        set { _groupID = newValue }
    }

    /// Returns true if `groupID` has been explicitly set.
    public var hasGroupID: Bool { return _groupID != nil }
    /// Clears the value of `groupID`. Subsequent reads from it will return its default value.
    public mutating func clearGroupID() { _groupID = nil }

    public var userID: Int64 {
        get { return _userID ?? 0 }
        set { _userID = newValue }
    }

    /// Returns true if `userID` has been explicitly set.
    public var hasUserID: Bool { return _userID != nil }
    /// Clears the value of `userID`. Subsequent reads from it will return its default value.
    public mutating func clearUserID() { _userID = nil }

    public var name: String {
        get { return _name ?? String() }
        set { _name = newValue }
    }

    /// Returns true if `name` has been explicitly set.
    public var hasName: Bool { return _name != nil }
    /// Clears the value of `name`. Subsequent reads from it will return its default value.
    public mutating func clearName() { _name = nil }

    public var role: GroupMemberRole {
        get { return _role ?? .owner }
        set { _role = newValue }
    }

    /// Returns true if `role` has been explicitly set.
    public var hasRole: Bool { return _role != nil }
    /// Clears the value of `role`. Subsequent reads from it will return its default value.
    public mutating func clearRole() { _role = nil }

    public var joinDate: Int64 {
        get { return _joinDate ?? 0 }
        set { _joinDate = newValue }
    }

    /// Returns true if `joinDate` has been explicitly set.
    public var hasJoinDate: Bool { return _joinDate != nil }
    /// Clears the value of `joinDate`. Subsequent reads from it will return its default value.
    public mutating func clearJoinDate() { _joinDate = nil }

    public var muteEndDate: Int64 {
        get { return _muteEndDate ?? 0 }
        set { _muteEndDate = newValue }
    }

    /// Returns true if `muteEndDate` has been explicitly set.
    public var hasMuteEndDate: Bool { return _muteEndDate != nil }
    /// Clears the value of `muteEndDate`. Subsequent reads from it will return its default value.
    public mutating func clearMuteEndDate() { _muteEndDate = nil }

    public var userStatus: UserStatus {
        get { return _userStatus ?? .available }
        set { _userStatus = newValue }
    }

    /// Returns true if `userStatus` has been explicitly set.
    public var hasUserStatus: Bool { return _userStatus != nil }
    /// Clears the value of `userStatus`. Subsequent reads from it will return its default value.
    public mutating func clearUserStatus() { _userStatus = nil }

    public var usingDeviceTypes: [DeviceType] = []

    public var customAttributes: [Value] = []

    public var unknownFields = SwiftProtobuf.UnknownStorage()

    public init() {}

    fileprivate var _groupID: Int64?
    fileprivate var _userID: Int64?
    fileprivate var _name: String?
    fileprivate var _role: GroupMemberRole?
    fileprivate var _joinDate: Int64?
    fileprivate var _muteEndDate: Int64?
    fileprivate var _userStatus: UserStatus?
}

#if swift(>=5.5) && canImport(_Concurrency)
    extension GroupMember: @unchecked Sendable {}
#endif // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

private let _protobuf_package = "im.turms.proto"

extension GroupMember: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
    public static let protoMessageName: String = _protobuf_package + ".GroupMember"
    public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
        1: .standard(proto: "group_id"),
        2: .standard(proto: "user_id"),
        3: .same(proto: "name"),
        4: .same(proto: "role"),
        5: .standard(proto: "join_date"),
        6: .standard(proto: "mute_end_date"),
        7: .standard(proto: "user_status"),
        8: .standard(proto: "using_device_types"),
        15: .standard(proto: "custom_attributes"),
    ]

    public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
        while let fieldNumber = try decoder.nextFieldNumber() {
            // The use of inline closures is to circumvent an issue where the compiler
            // allocates stack space for every case branch when no optimizations are
            // enabled. https://github.com/apple/swift-protobuf/issues/1034
            switch fieldNumber {
            case 1: try decoder.decodeSingularInt64Field(value: &_groupID)
            case 2: try decoder.decodeSingularInt64Field(value: &_userID)
            case 3: try decoder.decodeSingularStringField(value: &_name)
            case 4: try decoder.decodeSingularEnumField(value: &_role)
            case 5: try decoder.decodeSingularInt64Field(value: &_joinDate)
            case 6: try decoder.decodeSingularInt64Field(value: &_muteEndDate)
            case 7: try decoder.decodeSingularEnumField(value: &_userStatus)
            case 8: try decoder.decodeRepeatedEnumField(value: &usingDeviceTypes)
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
        try { if let v = self._groupID {
            try visitor.visitSingularInt64Field(value: v, fieldNumber: 1)
        } }()
        try { if let v = self._userID {
            try visitor.visitSingularInt64Field(value: v, fieldNumber: 2)
        } }()
        try { if let v = self._name {
            try visitor.visitSingularStringField(value: v, fieldNumber: 3)
        } }()
        try { if let v = self._role {
            try visitor.visitSingularEnumField(value: v, fieldNumber: 4)
        } }()
        try { if let v = self._joinDate {
            try visitor.visitSingularInt64Field(value: v, fieldNumber: 5)
        } }()
        try { if let v = self._muteEndDate {
            try visitor.visitSingularInt64Field(value: v, fieldNumber: 6)
        } }()
        try { if let v = self._userStatus {
            try visitor.visitSingularEnumField(value: v, fieldNumber: 7)
        } }()
        if !usingDeviceTypes.isEmpty {
            try visitor.visitPackedEnumField(value: usingDeviceTypes, fieldNumber: 8)
        }
        if !customAttributes.isEmpty {
            try visitor.visitRepeatedMessageField(value: customAttributes, fieldNumber: 15)
        }
        try unknownFields.traverse(visitor: &visitor)
    }

    public static func == (lhs: GroupMember, rhs: GroupMember) -> Bool {
        if lhs._groupID != rhs._groupID { return false }
        if lhs._userID != rhs._userID { return false }
        if lhs._name != rhs._name { return false }
        if lhs._role != rhs._role { return false }
        if lhs._joinDate != rhs._joinDate { return false }
        if lhs._muteEndDate != rhs._muteEndDate { return false }
        if lhs._userStatus != rhs._userStatus { return false }
        if lhs.usingDeviceTypes != rhs.usingDeviceTypes { return false }
        if lhs.customAttributes != rhs.customAttributes { return false }
        if lhs.unknownFields != rhs.unknownFields { return false }
        return true
    }
}
