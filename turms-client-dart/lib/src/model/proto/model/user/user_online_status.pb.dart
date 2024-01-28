//
//  Generated code. Do not modify.
//  source: model/user/user_online_status.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../constant/device_type.pbenum.dart' as $1;
import '../../constant/user_status.pbenum.dart' as $0;

class UserOnlineStatus extends $pb.GeneratedMessage {
  factory UserOnlineStatus({
    $fixnum.Int64? userId,
    $0.UserStatus? userStatus,
    $core.Iterable<$1.DeviceType>? usingDeviceTypes,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (userStatus != null) {
      $result.userStatus = userStatus;
    }
    if (usingDeviceTypes != null) {
      $result.usingDeviceTypes.addAll(usingDeviceTypes);
    }
    return $result;
  }
  UserOnlineStatus._() : super();
  factory UserOnlineStatus.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory UserOnlineStatus.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserOnlineStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'im.turms.proto'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'userId')
    ..e<$0.UserStatus>(
        2, _omitFieldNames ? '' : 'userStatus', $pb.PbFieldType.OE,
        defaultOrMaker: $0.UserStatus.AVAILABLE,
        valueOf: $0.UserStatus.valueOf,
        enumValues: $0.UserStatus.values)
    ..pc<$1.DeviceType>(
        3, _omitFieldNames ? '' : 'usingDeviceTypes', $pb.PbFieldType.KE,
        valueOf: $1.DeviceType.valueOf,
        enumValues: $1.DeviceType.values,
        defaultEnumValue: $1.DeviceType.DESKTOP)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  UserOnlineStatus clone() => UserOnlineStatus()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  UserOnlineStatus copyWith(void Function(UserOnlineStatus) updates) =>
      super.copyWith((message) => updates(message as UserOnlineStatus))
          as UserOnlineStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserOnlineStatus create() => UserOnlineStatus._();
  UserOnlineStatus createEmptyInstance() => create();
  static $pb.PbList<UserOnlineStatus> createRepeated() =>
      $pb.PbList<UserOnlineStatus>();
  @$core.pragma('dart2js:noInline')
  static UserOnlineStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserOnlineStatus>(create);
  static UserOnlineStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $0.UserStatus get userStatus => $_getN(1);
  @$pb.TagNumber(2)
  set userStatus($0.UserStatus v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserStatus() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$1.DeviceType> get usingDeviceTypes => $_getList(2);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
