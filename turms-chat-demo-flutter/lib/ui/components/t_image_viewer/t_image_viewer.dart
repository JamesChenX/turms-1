import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../themes/theme_config.dart';
import '../t_dialog/t_dialog.dart';
import '../t_title_bar/t_title_bar.dart';

class TImageViewer extends StatefulWidget {
  const TImageViewer({Key? key, required this.image}) : super(key: key);

  final ImageProvider image;

  @override
  State<TImageViewer> createState() => _TImageViewerState();
}

class _TImageViewerState extends State<TImageViewer> {
  @override
  void dispose() {
    final image = widget.image;
    image.obtainKey(ImageConfiguration.empty).then((key) {
      if (PaintingBinding.instance.imageCache.containsKey(key)) {
        Timer(const Duration(seconds: 10), () {
          PaintingBinding.instance.imageCache.evict(key, includeLive: false);
        });
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 540,
      width: 720,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topRight,
            child: TTitleBar(
              displayCloseOnly: true,
              popOnCloseTapped: true,
              backgroundColor: ThemeConfig.homePageBackgroundColor,
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: InteractiveViewer(
                minScale: 0.25,
                maxScale: 5,
                scaleFactor: 500,
                child: Image(
                  image: widget.image,
                  gaplessPlayback: true,
                  fit: BoxFit.contain,
                  isAntiAlias: true,
                ),
              ),
            ),
          ),
        ],
      ));
}

Future<void> showImageViewerDialog(BuildContext context, ImageProvider image) =>
    showCustomTDialog(
        routeName: '/image-viewer-dialog',
        context: context,
        child: TImageViewer(
          image: image,
        ));
