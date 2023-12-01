library flutter_quill_extensions;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart' show immutable;

import '../flutter_quill/flutter_quill.dart';
import 'presentation/embeds/editor/image/image.dart';
import 'presentation/embeds/editor/image/image_web.dart';
import 'presentation/embeds/editor/video/video.dart';
import 'presentation/embeds/editor/video/video_web.dart';
import 'presentation/models/config/editor/image/image.dart';
import 'presentation/models/config/editor/image/image_web.dart';
import 'presentation/models/config/editor/video/video.dart';
import 'presentation/models/config/editor/video/video_web.dart';

export 'logic/models/config/shared_configurations.dart';
export 'presentation/embeds/editor/image/image.dart';
export 'presentation/embeds/editor/image/image_web.dart';
export 'presentation/embeds/editor/unknown.dart';
export 'presentation/embeds/editor/video/video.dart';
export 'presentation/embeds/editor/video/video_web.dart';
export 'presentation/embeds/embed_types.dart';
export 'presentation/embeds/embed_types/image.dart';
export 'presentation/embeds/embed_types/video.dart';
export 'presentation/models/config/editor/image/image.dart';
export 'presentation/models/config/editor/image/image_web.dart';
export 'presentation/models/config/editor/video/video.dart';
export 'presentation/models/config/editor/video/video_web.dart';
export 'presentation/utils/utils.dart';

@immutable
class FlutterQuillEmbeds {
  const FlutterQuillEmbeds._();

  /// Returns a list of embed builders for QuillEditor.
  ///
  /// This method provides a collection of embed builders to enhance the
  /// functionality
  /// of a QuillEditor. It offers customization options for
  /// handling various types of
  /// embedded content, such as images, videos, and formulas.
  ///
  /// **Note:** This method is not intended for web usage.
  /// For web-specific embeds,
  /// use [editorWebBuilders].
  ///
  ///
  /// The method returns a list of [EmbedBuilder] objects that can be used with
  ///  QuillEditor
  /// to enable embedded content features like images, videos, and formulas.
  ///
  ///
  /// final quillEditor = QuillEditor(
  ///   // Other editor configurations
  ///   embedBuilders: embedBuilders,
  /// );
  /// ```
  ///
  /// if you don't want image embed in your quill editor then please pass null
  /// to [imageEmbedConfigurations]. same apply to [videoEmbedConfigurations]
  static List<EmbedBuilder> editorBuilders({
    QuillEditorImageEmbedConfigurations? imageEmbedConfigurations =
        const QuillEditorImageEmbedConfigurations(),
    QuillEditorVideoEmbedConfigurations? videoEmbedConfigurations =
        const QuillEditorVideoEmbedConfigurations(),
  }) {
    if (kIsWeb) {
      throw UnsupportedError(
        'The editorBuilders() is not for web, please use editorBuilders() '
        'instead',
      );
    }
    return [
      if (imageEmbedConfigurations != null)
        QuillEditorImageEmbedBuilder(
          configurations: imageEmbedConfigurations,
        ),
      if (videoEmbedConfigurations != null)
        QuillEditorVideoEmbedBuilder(
          configurations: videoEmbedConfigurations,
        ),
    ];
  }

  /// Returns a list of embed builders specifically designed for web support.
  ///
  /// [QuillEditorWebImageEmbedBuilder] is the embed builder for handling
  ///  images on the web.
  ///
  /// [QuillEditorWebVideoEmbedBuilder] is the embed builder for handling
  ///  videos iframe on the web.
  ///
  static List<EmbedBuilder> editorWebBuilders(
      {QuillEditorWebImageEmbedConfigurations? imageEmbedConfigurations =
          const QuillEditorWebImageEmbedConfigurations(),
      QuillEditorWebVideoEmbedConfigurations? videoEmbedConfigurations =
          const QuillEditorWebVideoEmbedConfigurations()}) {
    if (!kIsWeb) {
      throw UnsupportedError(
        'The editorsWebBuilders() is only for web, please use editorBuilders() '
        'instead for other platforms',
      );
    }
    return [
      if (imageEmbedConfigurations != null)
        QuillEditorWebImageEmbedBuilder(
          configurations: imageEmbedConfigurations,
        ),
      if (videoEmbedConfigurations != null)
        QuillEditorWebVideoEmbedBuilder(
          configurations: videoEmbedConfigurations,
        ),
    ];
  }

  /// Returns a list of default embed builders for QuillEditor.
  ///
  /// It will use [editorWebBuilders] for web and [editorBuilders] for others
  ///
  /// It's not customizable with minimal configurations
  static List<EmbedBuilder> defaultEditorBuilders() =>
      kIsWeb ? editorWebBuilders() : editorBuilders();
}