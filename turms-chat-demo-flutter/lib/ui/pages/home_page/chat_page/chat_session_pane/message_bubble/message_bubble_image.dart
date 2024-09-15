import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

import '../../../../../../infra/crypto/crypto_utils.dart';
import '../../../../../../infra/env/env_vars.dart';
import '../../../../../../infra/http/http_utils.dart';
import '../../../../../../infra/http/resource_not_found_exception.dart';
import '../../../../../../infra/io/path_utils.dart';
import '../../../../../../infra/media/corrupted_media_file_exception.dart';
import '../../../../../../infra/media/future_memory_image_provider.dart';
import '../../../../../../infra/task/task_utils.dart';
import '../../../../../../infra/units/file_size_extensions.dart';
import '../../../../../../infra/worker/worker_manager.dart';
import '../../../../../components/t_image/t_image_broken.dart';
import '../../../../../components/t_image_viewer/t_image_viewer.dart';
import '../../../../../themes/theme_config.dart';
import '../message_media_file.dart';
import 'message_image_provider.dart';

const _imageBorderWidth = 1.0;

class MessageBubbleImage extends StatefulWidget {
  const MessageBubbleImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleImage> createState() => _MessageBubbleImageState();
}

class _MessageBubbleImageState extends State<MessageBubbleImage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
          onTap: () async {
            // TODO: show a tip to let user know if the original image has been deleted.
            unawaited(showImageViewerDialog(
                context, MessageImageProvider(widget.url, false)));
          },
          child: _buildThumbnail()));

  Image _buildThumbnail() => Image(
        isAntiAlias: true,
        gaplessPlayback: true,
        image: MessageImageProvider(widget.url, true),
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: ThemeConfig.borderRadius4,
                    border: Border.all(
                        color: ThemeConfig.borderColor,
                        width: _imageBorderWidth)),
                child: ClipRRect(
                  borderRadius: ThemeConfig.borderRadius4,
                  child: Padding(
                    padding: const EdgeInsets.all(_imageBorderWidth),
                    child: child,
                  ),
                ));
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              SizedBox(
                width: EnvVars.messageImageThumbnailSizeWidth.toDouble(),
                height: EnvVars.messageImageThumbnailSizeHeight.toDouble(),
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12),
                ),
              ),
              const Center(
                child: RepaintBoundary(child: CupertinoActivityIndicator()),
              )
            ],
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildError(),
      );

// todo: click to download
  // handle different cases
  Widget _buildError() => const TImageBroken();

// Stack _buildError() => Stack(
//       children: [
//         SizedBox(
//           width: EnvVars.messageImageThumbnailSizeWidth.toDouble(),
//           height: EnvVars.messageImageThumbnailSizeWidth.toDouble(),
//           child: const DecoratedBox(
//             decoration: BoxDecoration(color: Colors.black12),
//           ),
//         ),
//         const Center(
//           child: Icon(Symbols.image_not_supported_rounded),
//         )
//       ],
//     );
}