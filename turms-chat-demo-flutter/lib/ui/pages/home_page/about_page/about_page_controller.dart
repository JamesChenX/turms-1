import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../infra/app/app_config.dart';
import '../../../../infra/github/github_client.dart';
import '../../../../infra/http/http_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
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

  void openGitHub() {
    launchUrlString('https://github.com/turms-im/turms');
  }

  /// returns null if the current version is latest.
  Future<File?> downloadLatestApp() async {
    final versionedAsset = await GithubUtils.fetchVersion();
    if (versionedAsset == null) {
      return null;
    }
    final currentVersion = Version.parse(
        GithubUtils.normalizeVersion(AppConfig.packageInfo.version));
    if (versionedAsset.version < currentVersion) {
      return null;
    }
    final asset = versionedAsset.asset;
    final filePath = '${AppConfig.appDir}${Platform.pathSeparator}app${Platform.pathSeparator}${asset.name!}';
    if (await File(filePath).exists()) {
      return File(filePath);
    }
    final downloadFile = await HttpUtils.downloadFile(
        uri: Uri.parse(asset.browserDownloadUrl!),
        filePath:
            filePath);
    if (downloadFile == null) {
      return null;
    }
    return downloadFile.bytes.isEmpty ? null : downloadFile.file;
  }

  void updateIsDownloading(bool isDownloading) {
    if (this.isDownloading != isDownloading) {
      this.isDownloading = isDownloading;
      setState(() {});
    }
  }
}