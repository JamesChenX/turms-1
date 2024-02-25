import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:pixel_snap/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../client/models/type.dart';
import '../../l10n/l10n.dart';
import '../../shared_states.dart';
import '../../theme.dart';
import '../../tools/debouncer.dart';

class GiphySearchBar extends ConsumerStatefulWidget {
  GiphySearchBar({Key? key, this.queryText}) : super(key: key);

  final String? queryText;

  @override
  _GiphySearchBarState createState() => _GiphySearchBarState();
}

class _GiphySearchBarState extends ConsumerState<GiphySearchBar> {
  late TextEditingController _textEditingController;

  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();

    _focus.addListener(_focusListener);

    _textEditingController = TextEditingController(text: widget.queryText);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _debouncer = Debouncer(
        delay: const Duration(
          milliseconds: 350,
        ),
      );
      _textEditingController.addListener(() {
        _debouncer.call(() {
          final text = _textEditingController.text;
          final queryText = ref.read(queryTextProvider);
          if (queryText != text) {
            ref.read(queryTextProvider.notifier).state = text;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
        child: _buildSearchWidget(),
      );

  Widget _buildSearchWidget() {
    final l = GiphyGetUILocalizations.labelsOf(context);
    return Column(
      children: [
        ref.watch(tabTypeProvider) == GiphyType.emoji
            ? Container()
            : SizedBox(
                height: 40,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      autofocus: ref.read(sheetInitialExtentProvider) ==
                          sheetMaxExtent,
                      focusNode: _focus,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        prefixIcon: _searchIcon(),
                        hintText: l.searchInputLabel,
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color!,
                            ),
                            onPressed: () {
                              _textEditingController.clear();
                              setState(() {});
                            }),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      autocorrect: false,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _searchIcon() {
    if (kIsWeb) {
      return const Icon(Icons.search);
    }
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFFFF6666),
          Color(0xFF9933FF),
        ],
      ).createShader(bounds),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
    );
  }

  void _focusListener() {
    // Set to max extent height if TextField has focus
    if (_focus.hasFocus &&
        ref.read(sheetInitialExtentProvider) == sheetMinExtent) {
      ref.read(sheetInitialExtentProvider.notifier).state = sheetMaxExtent;
    }
  }
}
