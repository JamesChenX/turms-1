import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/view_models/date_format_view_models.dart';
import '../../themes/theme_config.dart';
import '../components.dart';

class TDateCell extends ConsumerStatefulWidget {
  TDateCell({Key? key, required this.date, required this.isToday, required this.onTap})
      : day = date.day.toString(),
        super(key: key);

  final DateTime date;
  final String day;
  final bool isToday;
  final ValueChanged<DateTime> onTap;

  @override
  ConsumerState<TDateCell> createState() => _TDateCellState();
}

class _TDateCellState extends ConsumerState<TDateCell> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHovered = false;
          });
        },
        child: TTooltip(
          message: ref.watch(dateFormatViewModel_yMd).format(widget.date),
          waitDuration: const Duration(milliseconds: 1000),
          child: GestureDetector(
            onTap: () {
              widget.onTap(widget.date);
            },
            child: UnconstrainedBox(
              child: SizedBox(
                width: 24,
                height: 24,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: widget.isToday
                          ? Border.all(color: ThemeConfig.primary)
                          : null,
                      borderRadius: ThemeConfig.borderRadius4,
                      color:
                          isHovered ? ThemeConfig.primary : Colors.transparent),
                  child: Center(
                      child: Text(widget.day,
                          style: TextStyle(
                              color: isHovered
                                  ? Colors.white
                                  : ThemeConfig.textColorPrimary))),
                ),
              ),
            ),
          ),
        ),
      );
}