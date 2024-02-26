part of 't_screenshot.dart';

class TScreenshotController {
  final _containerKey = GlobalKey();

  Future<Uint8List?> capture({int quality = 80}) async => compute((_) async {
        final boundary = _containerKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
        if (boundary == null) {
          return null;
        }
        final image = await boundary.toImage();
        final byteData = await image.toByteData();
        if (byteData == null) {
          return null;
        }
        final outputImage = img.Image.fromBytes(
            width: image.width, height: image.height, bytes: byteData.buffer);
        return img.encodeJpg(outputImage, quality: quality);
      }, null);
}
