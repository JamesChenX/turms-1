import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/view_models/date_format_view_models.dart';
import '../../themes/theme_config.dart';
import '../components.dart';

enum RangePosition {
  start,
  end,
  middle,
  none,
}

class TDateCell extends ConsumerStatefulWidget {
  TDateCell(
      {Key? key,
      required this.date,
      required this.isToday,
      required this.selectRangePosition,
      required this.disableRangePosition,
      required this.onTap})
      : day = date.day.toString(),
        super(key: key);

  final DateTime date;
  final String day;
  final bool isToday;
  final RangePosition selectRangePosition;
  final RangePosition disableRangePosition;
  final ValueChanged<DateTime> onTap;

  @override
  ConsumerState<TDateCell> createState() => _TDateCellState();
}

class _TDateCellState extends ConsumerState<TDateCell> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget child;
    final disabled = widget.disableRangePosition != RangePosition.none;
    if (disabled) {
      child = Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 245, 245),
                    borderRadius: switch (widget.disableRangePosition) {
                      RangePosition.middle => null,
                      RangePosition.start =>
                        const BorderRadius.horizontal(left: Radius.circular(4)),
                      RangePosition.end => const BorderRadius.horizontal(
                          right: Radius.circular(4)),
                      RangePosition.none =>
                        throw AssertionError('Should not reach here'),
                    }),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: widget.isToday
                          ? Border.all(color: ThemeConfig.textColorDisabled)
                          : null,
                      borderRadius: ThemeConfig.borderRadius4,
                    ),
                    child: Center(
                        child: Text(widget.day,
                            style: const TextStyle(
                                color: ThemeConfig.textColorDisabled))),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      child = Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 24,
              // width: switch (widget.selectRangePosition) {
              //   RangePosition.middle => null,
              //   RangePosition.start => 24,
              //   RangePosition.end => 24,
              //   RangePosition.none => null,
              // },
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: switch (widget.selectRangePosition) {
                      RangePosition.middle =>
                        const Color.fromARGB(255, 230, 244, 255),
                      RangePosition.start => null,
                      RangePosition.end => null,
                      RangePosition.none => null,
                    },
                    borderRadius: switch (widget.selectRangePosition) {
                      RangePosition.middle => null,
                      RangePosition.start =>
                        const BorderRadius.horizontal(left: Radius.circular(4)),
                      RangePosition.end => const BorderRadius.horizontal(
                          right: Radius.circular(4)),
                      RangePosition.none => null,
                    }),
                child: UnconstrainedBox(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: widget.isToday
                            ? Border.all(color: ThemeConfig.primary)
                            : null,
                        borderRadius: switch (widget.selectRangePosition) {
                          RangePosition.middle => null,
                          RangePosition.start => const BorderRadius.horizontal(
                              left: Radius.circular(4)),
                          RangePosition.end => const BorderRadius.horizontal(
                              right: Radius.circular(4)),
                          RangePosition.none => null,
                        },
                        color: isHovered
                            ? ThemeConfig.primary
                            : switch (widget.selectRangePosition) {
                                RangePosition.none => null,
                                RangePosition.middle =>
                                  const Color.fromARGB(255, 230, 244, 255),
                                RangePosition.start => ThemeConfig.primary,
                                RangePosition.end => ThemeConfig.primary,
                              },
                      ),
                      child: Center(
                          child: Text(widget.day,
                              style: TextStyle(
                                  color: isHovered
                                      ? Colors.white
                                      : switch (widget.selectRangePosition) {
                                          RangePosition.none => null,
                                          RangePosition.middle => null,
                                          RangePosition.start => Colors.white,
                                          RangePosition.end => Colors.white,
                                        }))),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return MouseRegion(
      cursor:
          disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      onEnter: (event) {
        if (!disabled) {
          setState(() {
            isHovered = true;
          });
        }
      },
      onExit: (event) {
        if (!disabled) {
          setState(() {
            isHovered = false;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          if (!disabled) {
            widget.onTap(widget.date);
          }
        },
        child: TTooltip(
          message: ref.watch(dateFormatViewModel_yMd).format(widget.date),
          waitDuration: const Duration(milliseconds: 1000),
          child: child,
        ),
      ),
    );
  }
}