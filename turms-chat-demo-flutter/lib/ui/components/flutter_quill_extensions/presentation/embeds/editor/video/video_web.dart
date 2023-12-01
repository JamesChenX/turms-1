import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../../flutter_quill/flutter_quill.dart';
import '../../../models/config/editor/video/video_web.dart';
import '../../../utils/web_utils.dart';
import '../shims/dart_ui_fake.dart'
    if (dart.library.html) '../shims/dart_ui_real.dart' as ui;

class QuillEditorWebVideoEmbedBuilder extends EmbedBuilder {
  const QuillEditorWebVideoEmbedBuilder({
    required this.configurations,
  });

  final QuillEditorWebVideoEmbedConfigurations configurations;

  @override
  String get key => BlockEmbed.videoType;

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final videoUrl = node.value.data as String;

    final (height, width, margin, alignment) = getWebElementAttributes(node);

    ui.PlatformViewRegistry().registerViewFactory(
      videoUrl,
      (id) => html.IFrameElement()
        ..style.width = width
        ..style.height = height
        ..src = videoUrl
        ..style.border = 'none'
        ..style.margin = margin
        ..style.alignSelf = alignment
        ..attributes['loading'] = 'lazy',
    );

    return SizedBox(
      height: 500,
      child: HtmlElementView(
        viewType: videoUrl,
      ),
    );
  }
}