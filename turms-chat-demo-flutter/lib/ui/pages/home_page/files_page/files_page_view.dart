import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../domain/file/fixtures/files.dart';
import '../../../../infra/units/file_size_extensions.dart';
import '../../../components/index.dart';
import '../../../components/t_date_range_picker/t_date_range_picker.dart';
import '../../../components/t_table/t_table.dart';
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
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
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
      child: TTable(
        header: TTableRow(cells: [
          TTableDataCell(widget: Icon(Symbols.insert_drive_file_rounded)),
          TTableDataCell(
              widget: Text(
            appLocalizations.fileName,
            style: titleTextStyle,
          )),
          TTableDataCell(
              widget: Text(
            appLocalizations.fileUploadDate,
            style: titleTextStyle,
          )),
          TTableDataCell(
              widget: Text(
            appLocalizations.fileUploader,
            style: titleTextStyle,
          )),
          TTableDataCell(
              widget: Text(
            appLocalizations.fileSize,
            style: titleTextStyle,
          )),
        ]),
        rows: fixtureFiles
            .map((e) => TTableRow(
                  onTap: filesPageController.downloadOrOpen,
                  cells: [
                    TTableDataCell(widget: FileIcon(fileFormat: e.type)),
                    TTableDataCell(widget: Text(e.name)),
                    TTableDataCell(
                        widget: Text(dateFormat.format(e.uploadDate),
                            style: secondaryTextStyle)),
                    TTableDataCell(
                        widget: Text(e.uploader, style: secondaryTextStyle)),
                    TTableDataCell(
                        widget: Text(e.size.toHumanReadableFileSize(),
                            style: secondaryTextStyle)),
                  ],
                ))
            .toList(),
        columnOptions: [
          TTableColumnOption(width: 0.06),
          TTableColumnOption(width: 0.35),
          TTableColumnOption(width: 0.20),
          TTableColumnOption(width: 0.24),
          TTableColumnOption(width: 0.15),
        ],
      ),
    );
  }
}
