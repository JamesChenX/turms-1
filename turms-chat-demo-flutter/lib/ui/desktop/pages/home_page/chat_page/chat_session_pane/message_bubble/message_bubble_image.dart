import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../infra/env/env_vars.dart';
import '../../../../../components/index.dart';
import '../../../../../../themes/theme_config.dart';
import 'message_image_provider.dart';

const _imageBorderWidth = 1.0;

class MessageBubbleImage extends StatefulWidget {
  const MessageBubbleImage({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  State<MessageBubbleImage> createState() => _MessageBubbleImageState();
}

class _MessageBubbleImageState extends State<MessageBubbleImage> {
  late MessageImageProvider originalImageProvider;

  @override
  void initState() {
    super.initState();
    originalImageProvider = MessageImageProvider(widget.url, false);
  }

  @override
  void dispose() {
    // Dispose the original image provider to save memory promptly.
    originalImageProvider.dispose();
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
  Widget _buildError() => const SizedBox(
        width: 100,
        height: 100,
        child: TImageBroken(),
      );

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