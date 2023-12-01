import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../../infra/ui/color_extensions.dart';

class FileIcon extends StatelessWidget {
  const FileIcon({super.key, required this.fileFormat});

  final String fileFormat;

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: FileIconPainter(fileFormat),
        size: const Size(21, 28),
      );
}

class FileIconPainter extends CustomPainter {
  FileIconPainter(this.fileFormat);

  final String fileFormat;

  @override
  void paint(Canvas canvas, Size size) {
    final length = size.width * 0.35;
    final left = size.width - length;
    const color = Color.fromARGB(255, 230, 67, 64);
    canvas
      ..clipPath(Path()
        ..lineTo(left, 0)
        ..lineTo(size.width, length)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close())
      ..drawRRect(
          RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height),
              const Radius.circular(4)),
          Paint()..color = color)
      ..drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(left, -length, length * 2, length * 2),
              const Radius.circular(2)),
          Paint()..color = color.darken(0.2));

    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      ),
    )
      ..pushStyle(ui.TextStyle(
        color: Colors.white,
        fontSize: 10,
      ))
      ..addText(fileFormat.toUpperCase());
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: size.width));
    canvas.drawParagraph(
        paragraph,
        Offset((size.width - paragraph.width) / 2,
            (size.height - paragraph.height) / 2));
  }

  @override
  bool shouldRepaint(FileIconPainter oldDelegate) =>
      fileFormat != oldDelegate.fileFormat;
}