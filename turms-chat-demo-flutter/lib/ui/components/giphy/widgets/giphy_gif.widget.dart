import 'dart:async';

import 'package:flutter/material.dart';

import '../client/models/gif.dart';
import '../l10n/l10n.dart';
import 'giphy_get.widget.dart';

class GiphyGifWidget extends StatefulWidget {
  const GiphyGifWidget({
    Key? key,
    required this.gif,
    required this.giphyGetWrapper,
    this.borderRadius,
    this.imageAlignment = Alignment.center,
    this.showGiphyLabel = true,
  }) : super(key: key);
  final GiphyGif gif;
  final GiphyGetWrapper giphyGetWrapper;
  final bool showGiphyLabel;
  final BorderRadius? borderRadius;
  final Alignment imageAlignment;

  @override
  State<GiphyGifWidget> createState() => _GiphyGifWidgetState();
}

class _GiphyGifWidgetState extends State<GiphyGifWidget> {
  bool _showMenu = false;
  Timer? _timerMenu;

  @override
  void dispose() {
    _timerMenu?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = GiphyGetUILocalizations.labelsOf(context);
    const buttonsTextStyle = TextStyle(
      fontSize: 12,
      color: Colors.white,
    );
    final images = widget.gif.images!;
    return Container(
      child: Stack(
        alignment: widget.imageAlignment,
        children: [
          Column(
            children: [
              GestureDetector(
                onLongPress: _triggerShowHideMenu,
                onTap: () {
                  _timerMenu?.cancel();
                  _showMenu = false;
                  setState(() {});
                },
                child: Container(
                  width: double.parse(images.fixedWidth.width),
                  height: double.parse(images.fixedWidth.height),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: widget.borderRadius,
                  ),
                  child: Image.network(
                    images.fixedWidth.url,
                  ),
                ),
              ),
              widget.showGiphyLabel
                  ? FittedBox(
                      child: Text(
                      localizations.poweredByGiphy,
                      style: const TextStyle(fontSize: 12),
                    ))
                  : Container()
            ],
          ),
          IgnorePointer(
            ignoring: !_showMenu,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showMenu ? 1 : 0,
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          // launchUrl(Uri.parse(widget.gif.url!));
                        },
                        child: Text(
                          localizations.viewOnGiphy,
                          style: buttonsTextStyle,
                        )),
                    Container(
                      height: 15,
                      child: const VerticalDivider(
                        color: Colors.white54,
                        thickness: 1,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.giphyGetWrapper.open(
                          '@${widget.gif.username}',
                          context,
                        );
                      },
                      child: Text(
                        '${localizations.moreBy} @${widget.gif.username}',
                        style: buttonsTextStyle,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _triggerShowHideMenu() {
    _timerMenu?.cancel();

    setState(() {
      _showMenu = true;
    });

    _timerMenu = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showMenu = !_showMenu;
      });
    });
  }
}
