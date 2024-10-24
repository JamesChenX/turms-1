import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../domain/file/fixtures/files.dart';
import '../../../../../infra/units/file_size_extensions.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../themes/index.dart';
import '../../../components/index.dart';
import '../../../components/t_table/t_table.dart';
import 'file_icon/file_icon.dart';
import 'files_page_controller.dart';

class FilesPageView extends ConsumerWidget {
  const FilesPageView(this.filesPageController, {super.key});

  final FilesPageController filesPageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeExtension = context.appThemeExtension;
    final appLocalizations = filesPageController.appLocalizations;
    return Column(
      children: [
        _buildQueryFilters(context, appThemeExtension, appLocalizations),
        _buildTable(context, appThemeExtension, appLocalizations, ref),
      ],
    );
  }

  Widget _buildQueryFilters(BuildContext context,
      AppThemeExtension appThemeExtension, AppLocalizations appLocalizations) {
    final now = DateTime.now();
    return ColoredBox(
      color: appThemeExtension.homePageBackgroundColor,
      child: ConstrainedBox(
        constraints:
            const BoxConstraints.tightFor(height: Sizes.homePageHeaderHeight),
        child: Stack(children: [
          const TWindowControlZone(toggleMaximizeOnDoubleTap: true),
          Center(
            child: Padding(
              padding: Sizes.paddingV16H16,
              child: Row(
                spacing: 16,
                children: [
                  SizedBox(
                    width: 200,
                    child: TSearchBar(hintText: appLocalizations.fileName),
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

  Widget _buildTable(BuildContext context, AppThemeExtension appThemeExtension,
      AppLocalizations appLocalizations, WidgetRef ref) {
    // use "add_Hm()" instead of "add_jm()"
    // to make the string short and concise
    final dateFormat = ref.watch(dateFormatViewModel_yMdHm);
    return Expanded(
      child: TTable(
        header: TTableRow(cells: [
          const TTableDataCell(widget: Icon(Symbols.insert_drive_file_rounded)),
          _buildHeaderCell(appThemeExtension, appLocalizations.fileName),
          _buildHeaderCell(appThemeExtension, appLocalizations.fileUploadDate),
          _buildHeaderCell(appThemeExtension, appLocalizations.fileUploader),
          _buildHeaderCell(appThemeExtension, appLocalizations.fileSize),
          _buildHeaderCell(appThemeExtension, appLocalizations.progress),
        ]),
        rows: fixtureFiles
            .map((e) => TTableRow(
                  onTap: filesPageController.downloadOrOpen,
                  cells: [
                    TTableDataCell(widget: FileIcon(fileFormat: e.type)),
                    _buildTextDataCell(appThemeExtension, e.name, false),
                    _buildTextDataCell(appThemeExtension,
                        dateFormat.format(e.uploadDate), true),
                    _buildTextDataCell(appThemeExtension, e.uploader, true),
                    _buildTextDataCell(appThemeExtension,
                        e.size.toHumanReadableFileSize(), true),
                    const TTableDataCell(
                        widget: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: LinearProgressIndicator(),
                    )),
                  ],
                ))
            .toList(),
        columnOptions: [
          const TTableColumnOption(width: 0.05),
          const TTableColumnOption(width: 0.30),
          const TTableColumnOption(width: 0.15),
          const TTableColumnOption(width: 0.225),
          const TTableColumnOption(width: 0.10),
          const TTableColumnOption(width: 0.175),
        ],
      ),
    );
  }

  TTableDataCell _buildHeaderCell(
          AppThemeExtension appThemeExtension, String title) =>
      TTableDataCell(
          widget: Text(title,
              style: appThemeExtension.fileTableTitleTextStyle,
              overflow: TextOverflow.ellipsis));

  TTableDataCell _buildTextDataCell(
          AppThemeExtension appThemeExtension, String text, bool isSecondary) =>
      TTableDataCell(
          widget: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: isSecondary ? appThemeExtension.fileTableCellTextStyle : null,
      ));
}
