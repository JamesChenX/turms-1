import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../built_in_types/built_in_type_helpers.dart';

class ProcessUtils {
  ProcessUtils._();

  static Future<File> getPidFile(String processName) async {
    final tmp = await getTemporaryDirectory();
    return File('${tmp.path}/$processName.pid');
  }

  /// TODO: Wait for official solutions:
  /// https://github.com/dart-lang/sdk/issues/21478
  /// https://github.com/dart-lang/sdk/issues/42912
  static Future<File?> registerProcessIfNotExists() async {
    final processName = await getProcessName(pid);
    final pidFile = await getPidFile(processName!);
    if (await pidFile.exists()) {
      final existingPid = int.parse(await pidFile.readAsString());
      final existingProcessName = await getProcessName(existingPid);
      if (processName == existingProcessName) {
        return null;
      }
    }
    return _writeProcessNameToPidFile(processName);
  }

  static Future<void> unregisterProcessIfNotExists(File pidFile) async {
    await pidFile.delete();
  }

  static Future<String?> getProcessName(int pid) {
    if (Platform.isLinux || Platform.isMacOS) {
      return _getLinuxProcessName(pid);
    } else if (Platform.isWindows) {
      return _getWindowsProcessName(pid);
    }
    throw UnsupportedError('Unsupported platform');
  }

  static Future<File> _writeProcessNameToPidFile(String processName) async {
    final pidFile = await getPidFile(processName);
    await pidFile.writeAsString('$pid');
    return pidFile;
  }

  static Future<String?> _getLinuxProcessName(int pid) async {
    final result = await Process.run('ps', ['-s', '-p', pid.toString()]);

    // Example:
    // If found:
    // ```
    //  PID TTY        STIME COMMAND
    //  xxx ?          xx:xx:xx process_name
    // ```
    // If not found:
    // ```
    //  PID TTY        STIME COMMAND
    // ```
    final output = result.stdout.toString().trim();
    if (output.isEmpty) {
      return null;
    }
    var lines = output.split('\n');
    if (lines.isEmpty) {
      return null;
    }
    lines = lines.last.split(' ');
    if (lines.isEmpty || lines.last.isEmpty) {
      return null;
    }
    return lines.last;
  }

  static Future<String?> _getWindowsProcessName(int pid) async {
    final result = await Process.run('tasklist', ['/fi', 'PID eq $pid']);

    // Example:
    // If found:
    // ```
    // Image Name                     PID Session Name        Session#    Mem Usage
    // ========================= ======== ================ =========== ============
    // process_name.exe               xxx xx                    x      xxx xxx x
    // ```
    // If not found:
    // ```
    // INFO: No tasks are running which match the specified criteria.
    // ```
    var output = result.stdout.toString().trim();
    final lines = output.split('\n');
    if (lines.length != 3) {
      return null;
    }
    output = lines.last;
    return output.splitFirst(' ').$1.replaceAll('.exe', '');
  }
}
