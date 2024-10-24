// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.5.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

import '../frb_generated.dart';

List<DiskSpaceInfo> getDiskSpaceInfos() =>
    RustLib.instance.api.crateApiSystemGetDiskSpaceInfos();

class DiskSpaceInfo {
  const DiskSpaceInfo({
    required this.path,
    required this.total,
    required this.available,
  });
  final String path;
  final BigInt total;
  final BigInt available;

  @override
  int get hashCode => path.hashCode ^ total.hashCode ^ available.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiskSpaceInfo &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          total == other.total &&
          available == other.available;
}