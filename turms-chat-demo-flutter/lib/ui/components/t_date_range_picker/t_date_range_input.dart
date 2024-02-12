part of 't_date_range_picker.dart';

enum _TDateRangeInputFocus { none, start, end }

class _TDateRangeInput extends StatefulWidget {
  const _TDateRangeInput({Key? key, required this.onFocusChanged})
      : super(key: key);

  final ValueChanged<_TDateRangeInputFocus> onFocusChanged;

  @override
  State<_TDateRangeInput> createState() => _TDateRangeInputState();
}

class _TDateRangeInputState extends State<_TDateRangeInput> {
  _TDateRangeInputFocus _focus = _TDateRangeInputFocus.none;
  late FocusNode _startDateInputFocusNode;
  late FocusNode _endDateInputFocusNode;

  @override
  void initState() {
    super.initState();
    _startDateInputFocusNode = FocusNode()
      ..addListener(() {
        if (_startDateInputFocusNode.hasFocus) {
          _focus = _TDateRangeInputFocus.start;
        } else if (_focus == _TDateRangeInputFocus.start) {
          _focus = _TDateRangeInputFocus.none;
        }
        widget.onFocusChanged(_focus);
      });
    _endDateInputFocusNode = FocusNode()
      ..addListener(() {
        if (_endDateInputFocusNode.hasFocus) {
          _focus = _TDateRangeInputFocus.end;
        } else if (_focus == _TDateRangeInputFocus.end) {
          _focus = _TDateRangeInputFocus.none;
        }
        widget.onFocusChanged(_focus);
      });
  }

  @override
  void dispose() {
    _startDateInputFocusNode.dispose();
    _endDateInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 96,
            child: TTextField(
              focusNode: _startDateInputFocusNode,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Symbols.arrow_forward_rounded, size: 16),
          ),
          SizedBox(
            width: 96,
            child: TTextField(
              focusNode: _endDateInputFocusNode,
            ),
          ),
        ],
      );
}