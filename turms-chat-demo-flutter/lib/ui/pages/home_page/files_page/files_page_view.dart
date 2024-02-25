import 'package:data_table_2/data_table_2.dart';
import 'package:pixel_snap/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../fixtures/files.dart';
import '../../../../infra/units/file_size_extensions.dart';
import '../../../components/components.dart';
import '../../../components/t_date_range_picker/t_date_range_picker.dart';
import '../../../l10n/app_localizations.dart';
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
      BuildContext context, AppLocalizations appLocalizations) {
    final now = DateTime.now();
    return ColoredBox(
      color: ThemeConfig.homePageBackgroundColor,
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
            height: ThemeConfig.homePageHeaderHeight),
        child: Stack(children: [
          const TWindowControlZone(toggleMaximizeOnDoubleTap: true),
          Center(
            child: Padding(
              padding: ThemeConfig.paddingV8H16,
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TSearchBar(hintText: appLocalizations.fileName),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  TDateRangePicker(
                    firstDate: DateTime(now.year - 3),
                    lastDate: now,
                    initialDateRange: DateTimeRange(
                      start: now.subtract(const Duration(days: 7)),
                      end: now,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

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
          showCheckboxColumn: false,
          columnSpacing: 30.0,
          dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.green),
          columns: _buildTableHeader(appLocalizations, titleTextStyle),
          rows: _buildTableRows(
              appLocalizations, dateFormat, secondaryTextStyle)),
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
        DataColumn2(
          label: Text(
            appLocalizations.progress,
            style: titleTextStyle,
          ),
        ),
        DataColumn2(
          label: Text(
            appLocalizations.actions,
            style: titleTextStyle,
          ),
        ),
      ];

  List<DataRow2> _buildTableRows(AppLocalizations appLocalizations,
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
                  DataCell(LinearProgressIndicator(
                    value: 50,
                  )),
                  DataCell(Row(
                    children: [
                      TIconButton(
                        iconData: Symbols.play_arrow_rounded,
                        iconSize: 18,
                        addContainer: false,
                        tooltip: appLocalizations.downloadStart,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      TIconButton(
                        iconData: Symbols.close_rounded,
                        iconSize: 18,
                        addContainer: false,
                        tooltip: appLocalizations.downloadCancel,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      TIconButton(
                        iconData: Symbols.folder_rounded,
                        iconSize: 18,
                        addContainer: false,
                        tooltip: appLocalizations.openFolder,
                      )
                    ],
                  )),
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
