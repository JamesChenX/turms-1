import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../fixtures/files.dart';
import '../../../../infra/units/file_size_extensions.dart';
import '../../../l10n/app_localizations_view_model.dart';
import 'file_icon/file_icon.dart';

class FilesPage extends ConsumerWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    // use "add_Hm()" instead of "add_jm()"
    // to make the string short and concise
    final dateTimeFormat =
        DateFormat.yMd(Localizations.localeOf(context).toString()).add_Hm();
    final secondaryTextStyle =
        const TextStyle(color: Color.fromARGB(255, 102, 102, 102));
    const titleTextStyle = const TextStyle(
        fontStyle: FontStyle.normal, color: Color.fromARGB(255, 51, 51, 51));
    return DataTable2(
        columnSpacing: 30.0,
        dataRowColor: MaterialStateProperty.resolveWith(_getDataRowColor),
        headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.green),
        columns: <DataColumn>[
          DataColumn2(
            label: Expanded(
              child: Text(
                appLocalizations.fileName,
                style: titleTextStyle,
              ),
            ),
          ),
          DataColumn2(
            label: Expanded(
              child: Text(
                appLocalizations.fileUploadDate,
                style: titleTextStyle,
              ),
            ),
          ),
          DataColumn2(
            label: Expanded(
              child: Text(
                appLocalizations.fileUploader,
                style: titleTextStyle,
              ),
            ),
          ),
          DataColumn2(
            label: Expanded(
              child: Text(
                appLocalizations.fileType,
                style: titleTextStyle,
              ),
            ),
          ),
          DataColumn2(
            label: Expanded(
              child: Text(
                appLocalizations.fileSize,
                style: titleTextStyle,
              ),
            ),
          ),
        ],
        rows: fixtureFiles
            .map((e) => DataRow2(
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
            .toList());
  }

  Color? _getDataRowColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.hovered)) {
      return const Color.fromARGB(255, 246, 246, 246);
    }
    return null;
  }
}

class FileInfo {
  final String name;
  final DateTime uploadDate;
  final String uploader;
  final String type;
  final int size;

  FileInfo(
      {required this.name,
      required this.uploadDate,
      required this.uploader,
      required this.type,
      required this.size});
}