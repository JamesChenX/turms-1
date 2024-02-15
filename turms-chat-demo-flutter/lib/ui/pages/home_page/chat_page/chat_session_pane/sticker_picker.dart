import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../themes/theme_config.dart';

typedef EmojiCallback = void Function(String emoji);

const emoticons = [
  '😀',
  '😁',
  '😂',
  '😃',
  '😄',
  '😅',
  '😆',
  '😇',
  '😈',
  '😉',
  '😊',
  '😋',
  '😌',
  '😍',
  '😎',
  '😏',
  '😐',
  '😑',
  '😒',
  '😓',
  '😔',
  '😕',
  '😖',
  '😗',
  '😘',
  '😙',
  '😚',
  '😛',
  '😜',
  '😝',
  '😞',
  '😟',
  '😠',
  '😡',
  '😢',
  '😣',
  '😤',
  '😥',
  '😦',
  '😧',
  '😨',
  '😩',
  '😪',
  '😫',
  '😬',
  '😭',
  '😮',
  '😯',
  '😰',
  '😱',
  '😲',
  '😳',
  '😴',
  '😵',
  '😶',
  '😷',
  '😸',
  '😹',
  '😺',
  '😻',
  '😼',
  '😽',
  '😾',
  '😿',
  '🙀',
  '🙁',
  '🙂',
  '🙃',
  '🙄',
  '🙅',
  '🙆',
  '🙇',
  '🙈',
  '🙉',
  '🙊',
  '🙋',
  '🙌',
  '🙍',
  '🙎',
  '🙏'
];

class StickerPicker extends StatelessWidget {
  const StickerPicker({
    super.key,
    required this.emojiCallback,
  });

  final EmojiCallback emojiCallback;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: Container(
          height: 460,
          width: 460,
          padding: const EdgeInsets.only(top: 16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: ThemeConfig.borderRadius8,
              boxShadow: ThemeConfig.boxShadow),
          child: Column(
            children: [
              Flexible(
                  child: GridView.builder(
                itemCount: emoticons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final text = emoticons[index];
                  return TTextButton(
                      text: text,
                      textStyle: TextStyle(
                        fontFamily: ThemeConfig.emojiFontFamily,
                        fontFamilyFallback: ThemeConfig.emojiFontFamilyFallback,
                        fontSize: 26,
                      ),
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.white,
                      backgroundColorHovered:
                          const Color.fromARGB(255, 242, 242, 242),
                      onTap: () {
                        emojiCallback(text);
                        // _controller.document.format(
                        //     _controller.selection.start,
                        //     1,
                        //     StyleAttribute(
                        //         "mobileWidth: ${_imageSize!.width}; mobileHeight: ${_imageSize!.height}; mobileMargin: 10; mobileAlignment: center"));
                      });
                  // return Container(
                  //   // width: 80,
                  //   // height: 80,
                  //     width: 40,
                  //     height: 40,
                  //     color: Color.fromARGB(255, 242, 242, 242),
                  //     alignment: Alignment.center,
                  //     child: Text(
                  //       '😊',
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontFamily: 'NotoColorEmoji',
                  //         fontSize: 26,
                  //       ),
                  //     ));
                },
              )),
              // SizedBox(
              //   height: 50,
              //   child: Row(
              //     children: [
              //       Icon(
              //         Symbols.emoji_emotions,
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      );
}