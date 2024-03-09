import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../../infra/env/env_vars.dart';
import '../../../../../components/components.dart';
import '../../../../../components/giphy/client/models/gif.dart';
import '../../../../../components/giphy/giphy_picker.dart';
import '../../../../../components/t_button/t_icon_button.dart';
import '../../../../../components/t_lazy_indexed_stack.dart';
import '../../../../../themes/theme_config.dart';
import 'emoji_picker_pane.dart';

const _containerColorHovered = const Color.fromARGB(255, 242, 242, 242);
final _isGiphyEnabled = EnvVars.giphyApiKey.isNotBlank;

class StickerPicker extends StatefulWidget {
  const StickerPicker(
      {super.key,
      required this.onGiphyGifSelected,
      required this.onEmojiSelected});

  final ValueChanged<GiphyGif> onGiphyGifSelected;
  final ValueChanged<String> onEmojiSelected;

  @override
  State<StickerPicker> createState() => _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker> {
  _Tab _currentTab = _Tab.emoji;

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
          child: _isGiphyEnabled
              ? Column(
                  children: [
                    Flexible(
                        child: TLazyIndexedStack(
                      index: switch (_currentTab) {
                        _Tab.emoji => 0,
                        _Tab.giphy => 1,
                      },
                      children: [
                        EmojiPickerPane(
                          onEmojiSelected: widget.onEmojiSelected,
                        ),
                        GiphyPicker(
                          onSelected: widget.onGiphyGifSelected,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          TIconButton(
                            iconData: Symbols.emoji_emotions_rounded,
                            addContainer: false,
                            containerColorHovered: _containerColorHovered,
                            onTap: () {
                              _currentTab = _Tab.emoji;
                              setState(() {});
                            },
                          ),
                          TIconButton(
                            iconData: Symbols.search_rounded,
                            addContainer: false,
                            containerColorHovered: _containerColorHovered,
                            onTap: () {
                              _currentTab = _Tab.giphy;
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    )
                  ],
                )
              : EmojiPickerPane(
                  onEmojiSelected: widget.onEmojiSelected,
                ),
        ),
      );
}

enum _Tab { emoji, giphy }
