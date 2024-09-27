import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import 'files_page_view.dart';

class FilesPageController extends ConsumerState {
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return FilesPageView(this);
  }

  void downloadOrOpen() {
    // TODO: download + download animation + use real file path
    OpenFile.open('C:/projects/turms/turms-chat-demo-flutter/pubspec.yaml');
  }
}