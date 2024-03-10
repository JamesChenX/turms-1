import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/infra/native/app_host_api.g.dart',
  cppOptions: CppOptions(namespace: 'turms_chat_demo'),
  cppHeaderOut: 'windows/runner/app_host_api.g.h',
  cppSourceOut: 'windows/runner/app_host_api.g.cpp',
  swiftOut: 'macos/Runner/AppHostApi.g.swift',
  dartPackageName: 'turms_chat_demo',
))
@HostApi()
abstract class AppHostApi {
  DiskSpaceInfo getDiskSpace(String path);
}

class DiskSpaceInfo {
  DiskSpaceInfo(
      {required this.total, required this.free, required this.usable});

  final int total;
  final int free;
  final int usable;
}
