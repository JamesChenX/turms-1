part of 't_date_range_picker.dart';

class _TDateRangeInput extends ConsumerStatefulWidget {
  const _TDateRangeInput(
      {Key? key,
      this.startDate,
      this.endDate,
      this.previewStartDate,
      this.previewEndDate,
      required this.startDateFocusNode,
      required this.endDateFocusNode})
      : super(key: key);

  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? previewStartDate;
  final DateTime? previewEndDate;
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
    final previewStartDate = widget.previewStartDate;
    final previewEndDate = widget.previewEndDate;
    final usePreviewStartDate = previewStartDate != null;
    final usePreviewEndDate = previewEndDate != null;
    final DateTime? startDate;
    if (usePreviewStartDate) {
      startDate = previewStartDate;
    } else {
      startDate = widget.startDate;
    }
    final DateTime? endDate;
    if (usePreviewEndDate) {
      endDate = previewEndDate;
    } else {
      endDate = widget.endDate;
    }

    _startDateInputController.text = startDate == null
        ? ''
        : ref.read(dateFormatViewModel_yMd).format(startDate);
    _endDateInputController.text = endDate == null
        ? ''
        : ref.read(dateFormatViewModel_yMd).format(endDate);
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
            style:
                TextStyle(color: ThemeConfig.textColorSecondary, height: 1.2),
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
            style:
                TextStyle(color: ThemeConfig.textColorSecondary, height: 1.2),
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
