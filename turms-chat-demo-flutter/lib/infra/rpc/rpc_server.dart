import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app/app_utils.dart';
import '../io/path_utils.dart';
import 'rpc_client.dart';

File getAppProcessFile() {
  final appProcessFilePath = PathUtils.joinPathInAppScope(['app-process.json']);
  return File(appProcessFilePath);
}

/// We don't use UNIX sockets because:
/// 1. Dart doesn't support UNIX sockets on Windows,
/// though we can implement and maintain it ourselves,
/// but it is unnecessarily painful.
/// 2. It is painful to build a robust RPC based on Unix sockets
/// because we need to manage the unix socket file ourselves.
/// e.g. 1. overcome the unix path length limitation: 108.
/// 2. Detect if the unix socket file is available.
/// 3. We rarely send RPC requests,
/// so we don't need to acquire extreme performance.
/// 2. Use WebSockets and JSON-RPC 2.0 so that it is quite easy to debug
/// and extend (e.g. use any tools that support
/// WebSockets and JSON-RPC 2.0 to communicate).
class RpcServer {
  RpcServer._(
      this._httpServer, this._appProcessFile, this._appProcessRandomAccessFile);

  static Future<bool> _checkIfApplicationIsAlive(File appProcessFile) async {
    final json = await appProcessFile.readAsString();
    int port;
    try {
      if (json.isEmpty) {
        return false;
      }
      final jsonMap = jsonDecode(json);
      port = jsonMap['rpcPort'] as int;
    } catch (e) {
      return false;
    }
    try {
      final client = await RpcClient.connect(port);
      return await client.sendHealthcheckRequest();
    } catch (e) {
      if (e is SocketException ||
          (e is HttpException &&
              e.message.toLowerCase().contains('connection closed'))) {
        return false;
      }
    }
    return true;
  }

  static Future<RpcServer> create({int port = 29510}) async {
    final appProcessFile = getAppProcessFile();
    if (await appProcessFile.exists()) {
      if (await _checkIfApplicationIsAlive(appProcessFile)) {
        throw Exception('An application is already running');
      } else {
        await appProcessFile.delete();
      }
    } else if (!await appProcessFile.parent.exists()) {
      await appProcessFile.parent.create(recursive: true);
    }

    final handler = webSocketHandler((WebSocketChannel channel) {
      final server = Server(channel.cast<String>())
        ..registerMethod('healthcheck', () => {'status': 'ok'})
        ..registerMethod('close', AppUtils.close);
      unawaited(server.listen());
    });

    var file = await appProcessFile.open(mode: FileMode.write);
    try {
      file = await file.lock();
    } catch (e) {
      try {
        await file.close();
      } catch (_) {}
      rethrow;
    }

    HttpServer server;
    var retry = 0;
    try {
      while (true) {
        try {
          server = await shelf_io.serve(handler, 'localhost', port,
              poweredByHeader: null);
        } on SocketException catch (e) {
          if (e.osError?.message == 'EADDRINUSE') {
            if (retry++ >= 10000) {
              rethrow;
            }
            port++;
            continue;
          } else {
            rethrow;
          }
        }
        break;
      }
      await file.writeString(jsonEncode({'pid': pid, 'rpcPort': port}));
    } catch (e) {
      await file.unlock();
      await file.close();
      rethrow;
    }

    return RpcServer._(server, appProcessFile, file);
  }

  final HttpServer _httpServer;
  final File _appProcessFile;
  final RandomAccessFile _appProcessRandomAccessFile;

  int get port => _httpServer.port;

  Future<void> close() async {
    await _appProcessRandomAccessFile.unlock();
    await _appProcessRandomAccessFile.close();
    await _appProcessFile.delete();
    return _httpServer.close();
  }
}
