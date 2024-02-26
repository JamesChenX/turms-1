import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';

import '../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../infra/http/downloaded_file.dart';
import '../../../../../../infra/http/http_utils.dart';
import '../../../../../../infra/io/async_data_builder.dart';
import '../../../../../../infra/io/path_utils.dart';
import '../../../../../../infra/units/file_size_extensions.dart';

class MessageBubbleImage extends StatefulWidget {
  const MessageBubbleImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleImage> createState() => _MessageBubbleImageState();
}

const maxWidth = 200;
const maxHeight = 200;

class _MessageBubbleImageState extends State<MessageBubbleImage> {
  late Image image;

  late Future<DownloadedFile?> downloadFile;

  @override
  void initState() {
    super.initState();

    final url = widget.url;
    final urlStr = url.toString();
    final ext = extension(urlStr);
    final fileName = '${CryptoUtils.getSha256ByString(urlStr)}$ext';
    final filePath = PathUtils.joinAppPath(['files', fileName]);

    downloadFile = HttpUtils.downloadFileIfNotExists(
      uri: Uri.parse(url),
      filePath: filePath,
      maxBytes: 10.MB,
    );
    downloadFile.then((value) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TAsyncDataBuilder(
        future: downloadFile,
        builder: (context, snapshot) => snapshot.when(
          data: (data) {
            if (data == null) {
              return _buildError();
            }
            return Image(
              image: ResizeImage(FileImage(data.file),
                  width: maxWidth,
                  height: maxHeight,
                  policy: ResizeImagePolicy.fit),
              // cacheHeight: maxHeight,
              // cacheWidth: maxWidth,
              width: maxWidth.toDouble(),
              height: maxHeight.toDouble(),
              fit: BoxFit.contain,
            );
          },
          error: (error, stackTrace) => _buildError(),
          loading: () => Stack(
            children: [
              SizedBox(
                width: maxWidth.toDouble(),
                height: maxHeight.toDouble(),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),
              const Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      );

  // todo: click to download
  Stack _buildError() => Stack(
        children: [
          SizedBox(
            width: maxWidth.toDouble(),
            height: maxHeight.toDouble(),
            child: const DecoratedBox(
              decoration: BoxDecoration(color: Colors.black12),
            ),
          ),
          const Center(
            child: Icon(Symbols.image_not_supported_rounded),
          )
        ],
      );
}
