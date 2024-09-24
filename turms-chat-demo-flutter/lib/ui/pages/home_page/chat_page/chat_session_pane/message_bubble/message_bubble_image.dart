import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../infra/env/env_vars.dart';
import '../../../../../components/t_image/t_image_broken.dart';
import '../../../../../components/t_image_viewer/t_image_viewer.dart';
import '../../../../../themes/theme_config.dart';
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
            return ClipRRect(
              borderRadius: ThemeConfig.borderRadius4,
              child: Padding(
                padding: const EdgeInsets.all(_imageBorderWidth),
                child: child,
              ),
            );
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