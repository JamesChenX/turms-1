import 'package:flutter/material.dart';

class TTableColumnOption {
  TTableColumnOption({required this.width});

  final double width;
}

class TTableRow {
  TTableRow({required this.cells, this.onTap, this.onDoubleTap});

  final List<TTableDataCell> cells;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
}

class TTableDataCell {
  TTableDataCell({this.alignment = Alignment.centerLeft, required this.widget});

  final Alignment alignment;
  final Widget widget;
}

class TTable extends StatelessWidget {
  const TTable({
    super.key,
    required this.header,
    required this.rows,
    required this.columnOptions,
  });

  final TTableRow header;
  final List<TTableRow> rows;
  final List<TTableColumnOption> columnOptions;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final maxWidth = constraints.maxWidth;
          if (maxWidth == double.infinity) {
            throw StateError('The max width cannot be infinity');
          }
          final count = columnOptions.length;
          final widths = <double>[];
          var remainingWidth = maxWidth;
          for (var i = 0; i < count; i++) {
            if (i == count - 1) {
              widths.add(remainingWidth.truncateToDouble());
            } else {
              final width =
                  (maxWidth * columnOptions[i].width).truncateToDouble();
              widths.add(width);
              remainingWidth -= width;
            }
          }
          return Column(
            children: <Widget>[
              _buildHeader(widths),
              Expanded(
                child: ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) =>
                      _buildDataRow(rows[index], widths),
                ),
              ),
            ],
          );
        },
      );

  Widget _buildHeader(List<double> widths) => Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          children: List.generate(columnOptions.length,
              (index) => _buildCell(header, index, widths[index])),
        ),
      );

  Widget _buildDataRow(TTableRow row, List<double> widths) => SizedBox(
        height: 50,
        child: Row(
          children: List.generate(columnOptions.length,
              (index) => _buildCell(row, index, widths[index])),
        ),
      );

  GestureDetector _buildCell(TTableRow row, int index, double width) {
    final cell = row.cells[index];
    return GestureDetector(
      onTap: () => row.onTap?.call(),
      onDoubleTap: () => row.onDoubleTap?.call(),
      child: Align(
        alignment: cell.alignment,
        child: SizedBox(
          width: width,
          child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.zero,
            child: cell.widget,
          ),
        ),
      ),
    );
  }
}
