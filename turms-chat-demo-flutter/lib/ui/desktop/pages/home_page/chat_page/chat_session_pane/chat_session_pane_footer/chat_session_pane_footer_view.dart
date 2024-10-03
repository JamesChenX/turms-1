import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../../../components/giphy/client/models/gif.dart';
import '../../../../../components/index.dart';
import '../attachment.dart';
import '../sticker_picker/sticker_picker.dart';
import 'chat_session_pane_footer_controller.dart';

class ChatSessionPaneFooterView extends StatelessWidget {
  const ChatSessionPaneFooterView(this.chatPageFooterController, {super.key});

  final ChatSessionPaneFooterController chatPageFooterController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = chatPageFooterController.appLocalizations;
    return Stack(
      children: [
        DropRegion(
            formats: Formats.standardFormats,
            onDropOver: chatPageFooterController.onDropOver,
            onDropEnter: (event) {
              chatPageFooterController.onDropEnter();
            },
            onDropLeave: (event) {
              chatPageFooterController.onDropLeave();
            },
            onPerformDrop: chatPageFooterController.onPerformDrop,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildEditor(context, appLocalizations),
            )),
        _buildDropZoneMask(appLocalizations)
      ],
    );
  }

  Widget _buildEditor(
          BuildContext context, AppLocalizations appLocalizations) =>
      Column(
        children: [
          Expanded(
            child: ColoredBox(
              color: ThemeConfig.homePageBackgroundColor,
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.enter):
                      chatPageFooterController.sendInputMessage
                },
                child: TEditor(
                  controller: chatPageFooterController.editorController,
                  autofocus: true,
                  focusNode: chatPageFooterController.editorFocusNode,
                  contentPadding: const EdgeInsets.only(top: 8),
                ),
              ),
            ),
          ),
          //   child: QuillEditor.basic(
          //       focusNode: chatPageFooterController.editorFocusNode,
          //       configurations: QuillEditorConfigurations(
          //         floatingCursorDisabled: true,
          //         embedBuilders: [
          //           // ...FlutterQuillEmbeds.defaultEditorBuilders(),
          //           EmojiEmbedBuilder(),
          //         ],
          //         onImagePaste: (imageFile) {
          //           // tryAddNewFile([imageFile]);
          //           return Future.value();
          //         },
          //         customStyles: DefaultStyles.getInstance(context),
          //         minHeight: 2000,
          //         expands: true,
          //         controller: chatPageFooterController.editorController,
          //       )),
          // )),
          if (chatPageFooterController.localFiles.isNotEmpty)
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                runSpacing: 4,
                spacing: 4,
                children: chatPageFooterController.localFiles
                    .map((file) => Attachment(
                          fileName: file.fileName ?? '',
                          onRemoveAttachmentTapped: () {
                            chatPageFooterController.removeFiles(file);
                          },
                        ))
                    .toList(growable: false),
              ),
            ),
          const SizedBox(
            height: 12,
          ),
          Container(
            // height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TPopup(
                        controller: chatPageFooterController
                            .stickerPickerPopupController,
                        targetAnchor: Alignment.topCenter,
                        followerAnchor: Alignment.bottomCenter,
                        offset: const Offset(-5, -5),
                        target: TIconButton(
                          iconData: Symbols.emoji_emotions_rounded,
                          iconColor: Colors.black54,
                          iconColorHovered: Colors.black87,
                          iconColorPressed: ThemeConfig.primary,
                          tooltip: appLocalizations.sticker,
                        ),
                        follower: StickerPicker(
                          onGiphyGifSelected: (GiphyGif value) {
                            final images = value.images;
                            final original = images?.original;
                            final previewWebp = images?.previewWebp;
                            if (original == null || previewWebp == null) {
                              return;
                            }
                            chatPageFooterController.sendImage(
                                original.webp ?? original.url,
                                previewWebp.url,
                                int.parse(original.width),
                                int.parse(original.height));
                          },
                          onEmojiSelected: chatPageFooterController.insertEmoji,
                        )),
                    TIconButton(
                      iconData: Symbols.folder_rounded,
                      iconColor: Colors.black54,
                      iconColorHovered: Colors.black87,
                      iconColorPressed: ThemeConfig.primary,
                      tooltip: appLocalizations.sticker,
                      onTap: () async {
                        final file = await chatPageFooterController.pickFile();
                      },
                    ),
                    TIconButton(
                      iconData: Symbols.history_rounded,
                      iconColor: Colors.black54,
                      iconColorHovered: Colors.black87,
                      iconColorPressed: ThemeConfig.primary,
                      tooltip: appLocalizations.chatHistory,
                      onTap: () async {
                        final file = await chatPageFooterController.pickFile();
                      },
                    )
                  ],
                ),
                TIconButton(
                    iconData: Symbols.send_rounded,
                    iconColorHovered: ThemeConfig.primary,
                    tooltip: appLocalizations.send,
                    onTap: chatPageFooterController.sendInputMessage)
              ],
            ),
          ),
        ],
      );

  IgnorePointer _buildDropZoneMask(AppLocalizations localizations) =>
      // Ignore pointer to not obstruct "DropRegion"
      IgnorePointer(
          child: AnimatedOpacity(
              opacity: chatPageFooterController.dragging ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Padding(
                padding: const EdgeInsets.only(right: 4, bottom: 4),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  dashPattern: [12, 10],
                  color: ThemeConfig.primary,
                  strokeWidth: 2,
                  radius: const Radius.circular(8),
                  child: ClipRRect(
                    child: ColoredBox(
                      color: Colors.white.withValues(alpha: 0.6),
                      child: Center(
                        child: Text(
                          localizations.dropFilesHere,
                          style: const TextStyle(color: ThemeConfig.primary),
                        ),
                      ),
                    ),
                  ),
                ),
              )));
}