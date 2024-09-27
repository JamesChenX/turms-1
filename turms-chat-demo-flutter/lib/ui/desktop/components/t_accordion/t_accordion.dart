import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class TAccordion extends StatefulWidget {
  const TAccordion(
      {Key? key,
      required this.titleChild,
      required this.contentChild,
      this.collapsedTitleBackgroundColor = Colors.white,
      this.expandedTitleBackgroundColor = Colors.white,
      this.titlePadding = const EdgeInsets.all(4),
      this.contentBackgroundColor,
      this.contentPadding = EdgeInsets.zero,
      this.titleBorder = const Border(),
      this.contentBorder = const Border(),
      this.margin,
      this.showAccordion = false,
      this.onToggleCollapsed,
      this.titleBorderRadius = BorderRadius.zero,
      this.contentBorderRadius = BorderRadius.zero})
      : super(key: key);

  final bool showAccordion;

  final Widget titleChild;

  final Widget contentChild;

  final Color collapsedTitleBackgroundColor;

  final Color expandedTitleBackgroundColor;

  final EdgeInsets titlePadding;

  final EdgeInsets contentPadding;

  final Color? contentBackgroundColor;

  final EdgeInsets? margin;

  final Border titleBorder;

  final Border contentBorder;

  final BorderRadius titleBorderRadius;

  final BorderRadius contentBorderRadius;

  final void Function(bool)? onToggleCollapsed;

  @override
  _TAccordionState createState() => _TAccordionState();
}

class _TAccordionState extends State<TAccordion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _turnsAnimation;
  late CurvedAnimation _sizeAnimation;
  late bool _showAccordion;
  bool _buildChild = true;

  @override
  void initState() {
    _showAccordion = widget.showAccordion;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this)
      ..addListener(() {
        if (_controller.isDismissed) {
          _buildChild = false;
          setState(() {});
        }
      });
    _turnsAnimation = _controller.drive(Tween(
      begin: 0,
      end: 90 / 360,
    ));
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: _toggleCollapsed,
            borderRadius: widget.titleBorderRadius,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: widget.titleBorderRadius,
                border: widget.titleBorder,
                color: _showAccordion
                    ? widget.expandedTitleBackgroundColor
                    : widget.collapsedTitleBackgroundColor,
              ),
              padding: widget.titlePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RotationTransition(
                      turns: _turnsAnimation,
                      child: const Icon(Symbols.keyboard_arrow_right)),
                  Expanded(
                    child: widget.titleChild,
                  )
                ],
              ),
            ),
          ),
          if (_buildChild)
            SizeTransition(
              sizeFactor: _sizeAnimation,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: widget.contentBorderRadius,
                  border: widget.contentBorder,
                  color: widget.contentBackgroundColor ?? Colors.white70,
                ),
                width: MediaQuery.of(context).size.width,
                padding: widget.contentPadding,
                child: widget.contentChild,
              ),
            )
        ],
      );

  void _toggleCollapsed() {
    switch (_controller.status) {
      case AnimationStatus.completed:
        _controller.reverse();
        break;
      case AnimationStatus.dismissed:
        _controller.forward();
        _buildChild = true;
        setState(() {});
        break;
      default:
    }
    _showAccordion = !_showAccordion;
    widget.onToggleCollapsed?.call(_showAccordion);
    setState(() {});
  }
}
