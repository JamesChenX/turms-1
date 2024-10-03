import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import 'about_page.dart';
import 'about_page_view.dart';

class AboutPageController extends ConsumerState<AboutPage> {
  late AppLocalizations appLocalizations;
  bool isDownloading = false;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return AboutPageView(this);
  }

  Future<bool> openGitHub() =>
      launchUrlString('https://github.com/turms-im/turms');

  void updateIsDownloading(bool isDownloading) {
    if (this.isDownloading != isDownloading) {
      this.isDownloading = isDownloading;
      setState(() {});
    }
  }
}