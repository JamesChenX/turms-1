import 'package:flutter/material.dart';

import '../../../../../../themes/theme_config.dart';
import '../../../../../components/index.dart';

const _emoticons = [
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

const containerColorHovered = Color.fromARGB(255, 242, 242, 242);

class EmojiPickerPane extends StatelessWidget {
  const EmojiPickerPane({
    super.key,
    required this.onEmojiSelected,
  });

  final ValueChanged<String> onEmojiSelected;

  @override
  Widget build(BuildContext context) => GridView.builder(
        itemCount: _emoticons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final text = _emoticons[index];
          return TTextButton(
              text: text,
              textStyle: TextStyle(
                fontFamily: ThemeConfig.emojiFontFamily,
                fontFamilyFallback: ThemeConfig.emojiFontFamilyFallback,
                fontSize: 26,
              ),
              containerPadding: EdgeInsets.zero,
              containerColor: Colors.white,
              containerColorHovered: containerColorHovered,
              onTap: () {
                onEmojiSelected(text);
              });
        },
      );
}
