import 'dart:convert';
import 'dart:io';

class Task {
  final String name;
  final String executable;
  final List<String> arguments;

  Task({required this.name, required this.executable, required this.arguments});
}

Future<void> runTask(
    String taskName, String executable, List<String>? arguments) async {
  if (arguments == null || arguments.isEmpty) {
    stdout.writeln("Start '$taskName' task. Running: $executable");
  } else {
    stdout.writeln(
        "Start '$taskName' task. Running: $executable ${arguments.join(' ')}");
  }
  final process =
      await Process.start(executable, arguments ?? [], runInShell: true);
  process.stdout.transform(utf8.decoder).listen(stdout.write);
  process.stderr.transform(utf8.decoder).listen(stderr.write);

  final exitCode = await process.exitCode;
  if (exitCode == 0) {
    stdout.writeln('Exit code: $exitCode');
  } else {
    stderr.writeln('Exit code: $exitCode');
  }
  await stdout.flush();
  await stderr.flush();
}

Future<void> main() async {
  for (final task in [
    Task(
        name: 'generate l10n dart files',
        executable: 'flutter',
        arguments: ['gen-l10n']),
    Task(
        name: 'generate assets and database dart files',
        executable: 'flutter',
        arguments: [
          'pub',
          'run',
          'build_runner',
          'build',
          '--delete-conflicting-outputs'
        ])
  ]) {
    await runTask(task.name, task.executable, task.arguments);
  }
}