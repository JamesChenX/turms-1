part of 't_date_range_picker.dart';

enum _TDateRangeInputFocus { none, start, end }

class _TDateRangeInput extends ConsumerStatefulWidget {
  const _TDateRangeInput(
      {Key? key,
      this.startDate,
      this.endDate,
      required this.startDateFocusNode,
      required this.endDateFocusNode})
      : super(key: key);

  final DateTime? startDate;
  final DateTime? endDate;
  final FocusNode startDateFocusNode;
  final FocusNode endDateFocusNode;

  @override
  ConsumerState<_TDateRangeInput> createState() => _TDateRangeInputState();
}

class _TDateRangeInputState extends ConsumerState<_TDateRangeInput> {
  late TextEditingController _startDateInputController;
  late TextEditingController _endDateInputController;

  @override
  void initState() {
    super.initState();

    _startDateInputController = TextEditingController();
    _endDateInputController = TextEditingController();
  }

  @override
  void dispose() {
    _startDateInputController.dispose();
    _endDateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final startDate = widget.startDate;
    final endDate = widget.endDate;
    if (startDate != null) {
      _startDateInputController.text =
          ref.read(dateFormatViewModel_yMd).format(startDate);
    }
    if (endDate != null) {
      _endDateInputController.text =
          ref.read(dateFormatViewModel_yMd).format(endDate);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 96,
          child: TTextField(
            textEditingController: _startDateInputController,
            focusNode: widget.startDateFocusNode,
            readOnly: true,
            showCursor: false,
            onTapOutside: onTapOutside,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Symbols.arrow_forward_rounded, size: 16),
        ),
        SizedBox(
          width: 96,
          child: TTextField(
            textEditingController: _endDateInputController,
            focusNode: widget.endDateFocusNode,
            readOnly: true,
            showCursor: false,
            onTapOutside: onTapOutside,
          ),
        ),
      ],
    );
  }

  void onTapOutside(_) {
    // it will unfocus by default,
    // we don't want to unfocus here,
    // so do nothing.
  }
}