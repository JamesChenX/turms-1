import 'package:flutter/material.dart';

import '../../../themes/index.dart';

const defaultListTile = 64.0;

class TListTile extends StatefulWidget {
  const TListTile(
      {Key? key,
      this.height = defaultListTile,
      this.padding =
          const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
      this.focused = false,
      this.backgroundColor,
      this.backgroundFocusedColor,
      this.backgroundHoveredColor,
      this.mouseCursor = SystemMouseCursors.basic,
      this.onTap,
      this.onSecondaryTapUp,
      required this.child})
      : super(key: key);

  final bool focused;
  final double height;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final Color? backgroundFocusedColor;
  final Color? backgroundHoveredColor;
  final MouseCursor mouseCursor;
  final GestureTapCallback? onTap;
  final GestureTapUpCallback? onSecondaryTapUp;
  final Widget child;

  @override
  _TListTileState createState() => _TListTileState();
}

class _TListTileState extends State<TListTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final appThemeExtension = context.appThemeExtension;
    return MouseRegion(
        cursor: widget.mouseCursor,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: GestureDetector(
            onTap: widget.onTap,
            onSecondaryTapUp: widget.onSecondaryTapUp,
            child: AnimatedContainer(
                height: widget.height,
                alignment: Alignment.center,
                color: widget.focused
                    ? (widget.backgroundFocusedColor ??
                        // TODO: RENAME
                        appThemeExtension.conversationBackgroundFocusedColor)
                    : (isHovered
                        ? (widget.backgroundHoveredColor ??
                            appThemeExtension
                                .conversationBackgroundHoveredColor)
                        : (widget.backgroundColor ??
                            appThemeExtension.conversationBackgroundColor)),
                padding: widget.padding,
                duration: const Duration(milliseconds: 100),
                child: widget.child)));
  }
}
