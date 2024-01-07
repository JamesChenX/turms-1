import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:turms_chat_demo/ui/l10n/app_localizations.dart';

import '../../../../fixtures/files.dart';
import '../../../../infra/units/file_size_extensions.dart';
import '../../../components/t_search_bar.dart';
import '../../../components/t_window_control_zone.dart';
import '../../../l10n/view_models/date_format_view_models.dart';
import '../../../themes/theme_config.dart';
import 'file_icon/file_icon.dart';
import 'files_page_controller.dart';

class FilesPageView extends ConsumerWidget {
  const FilesPageView(this.filesPageController, {super.key});

  final FilesPageController filesPageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = filesPageController.appLocalizations;
    return Column(
      children: [
        _buildQueryFilters(context, appLocalizations),
        _buildTable(context, appLocalizations, ref),
      ],
    );
  }

  Widget _buildQueryFilters(
          BuildContext context, AppLocalizations appLocalizations) =>
      ColoredBox(
        color: ThemeConfig.homePageBackgroundColor,
        child: ConstrainedBox(
          constraints: const BoxConstraints.tightFor(
              height: ThemeConfig.homePageHeaderHeight),
          child: Stack(children: [
            TWindowControlZone(toggleMaximizeOnDoubleTap: true),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TSearchBar(hintText: appLocalizations.fileName),
                ),
                const SizedBox(
                  width: 16,
                ),
                // TODO: Add datetime picker for publish date,
                IconButton(
                  icon: const Icon(Symbols.date_range_rounded),
                  onPressed: () {
                    final now = DateTime.now();
                    showDateRangePicker(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        firstDate: DateTime(now.year - 3),
                        lastDate: now,
                        initialDateRange: DateTimeRange(
                          start: now.subtract(const Duration(days: 7)),
                          end: now,
                        ),
                        builder: (context, child) => Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 400.0,
                                  maxHeight: 500.0,
                                ),
                                child: child,
                              ),
                            ));
                  },
                )
              ],
            ),
          ]),
        ),
      );

  Widget _buildTable(
      BuildContext context, AppLocalizations appLocalizations, WidgetRef ref) {
    // use "add_Hm()" instead of "add_jm()"
    // to make the string short and concise
    final dateFormat = ref.watch(dateFormatViewModel_yMdHm);
    const secondaryTextStyle =
        TextStyle(color: Color.fromARGB(255, 102, 102, 102));
    const titleTextStyle = TextStyle(
        fontStyle: FontStyle.normal, color: Color.fromARGB(255, 51, 51, 51));
    return Expanded(
      child: DataTable2(
          columnSpacing: 30.0,
          dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.green),
          columns: _buildTableHeader(appLocalizations, titleTextStyle),
          rows: _buildTableRows(dateFormat, secondaryTextStyle)),
    );
  }

  List<DataColumn> _buildTableHeader(
          AppLocalizations appLocalizations, TextStyle titleTextStyle) =>
      <DataColumn>[
        DataColumn2(
          label: Text(
            appLocalizations.fileName,
            style: titleTextStyle,
          ),
        ),
        DataColumn2(
          label: Text(
            appLocalizations.fileUploadDate,
            style: titleTextStyle,
          ),
        ),
        DataColumn2(
          label: Text(
            appLocalizations.fileUploader,
            style: titleTextStyle,
          ),
        ),
        DataColumn2(
          label: Text(
            appLocalizations.fileType,
            style: titleTextStyle,
          ),
        ),
        DataColumn2(
          label: Text(
            appLocalizations.fileSize,
            style: titleTextStyle,
          ),
        ),
      ];

  List<DataRow2> _buildTableRows(
          DateFormat dateTimeFormat, TextStyle secondaryTextStyle) =>
      fixtureFiles
          .map((e) => DataRow2(
                onTap: filesPageController.downloadOrOpen,
                onSelectChanged: (isSelected) {},
                cells: [
                  DataCell(Row(
                    children: [
                      FileIcon(fileFormat: e.type),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(e.name),
                    ],
                  )),
                  DataCell(Text(dateTimeFormat.format(e.uploadDate),
                      style: secondaryTextStyle)),
                  DataCell(Text(e.uploader, style: secondaryTextStyle)),
                  DataCell(Text(e.type, style: secondaryTextStyle)),
                  DataCell(Text(e.size.toHumanReadableFileSize(),
                      style: secondaryTextStyle)),
                ],
              ))
          .toList();

  Color? _getDataRowColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return const Color.fromARGB(255, 246, 246, 246);
    }
    return null;
  }
}