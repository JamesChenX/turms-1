import 'package:flutter/material.dart';

import '../themes/theme_config.dart';

class TListTile extends StatefulWidget {
  const TListTile(
      {Key? key,
      this.height = 64,
      this.padding =
          const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 12),
      this.focused = false,
      // TODO: RENAME
      this.backgroundColor = ThemeConfig.conversationBackgroundColor,
      this.focusedBackgroundColor =
          ThemeConfig.conversationFocusedBackgroundColor,
      this.hoveredBackgroundColor =
          ThemeConfig.conversationHoveredBackgroundColor,
      this.mouseCursor = SystemMouseCursors.basic,
      this.onTap,
      required this.child})
      : super(key: key);

  final bool focused;
  final double height;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color focusedBackgroundColor;
  final Color hoveredBackgroundColor;
  final MouseCursor mouseCursor;
  final GestureTapCallback? onTap;
  final Widget child;

  @override
  _TListTileState createState() => _TListTileState();
}

class _TListTileState extends State<TListTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
      cursor: widget.mouseCursor,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
              height: widget.height,
              alignment: Alignment.center,
              color: widget.focused
                  ? widget.focusedBackgroundColor
                  : (isHovered
                      ? widget.hoveredBackgroundColor
                      : widget.backgroundColor),
              padding: widget.padding,
              duration: const Duration(milliseconds: 100),
              child: widget.child)));
}