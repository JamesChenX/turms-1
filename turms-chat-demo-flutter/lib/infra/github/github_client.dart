import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

import '../http/http_response_exception.dart';
import 'github_asset.dart';
import 'versioned_asset.dart';

class GithubUtils {
  GithubUtils._();

  static Future<VersionedAsset?> fetchVersion() async {
    // TODO: make configurable
    const url = 'https://api.github.com/repos/turms-im/turms/releases';

    final response =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final releases = json.decode(response.body) as List<dynamic>;
      if (releases.isEmpty) {
        return null;
      }
      var latestRelease = releases[0] as Map<String, dynamic>;
      var latestReleasePublishedAt =
          DateTime.parse(latestRelease['published_at'] as String);
      final releaseCount = releases.length;
      for (var i = 1; i < releaseCount; i++) {
        final release = releases[i] as Map<String, dynamic>;
        final publishedAt = release['published_at'] as String;
        final releasePublishedAt = DateTime.parse(publishedAt);
        if (releasePublishedAt.isAfter(latestReleasePublishedAt)) {
          latestRelease = release;
          latestReleasePublishedAt = releasePublishedAt;
        }
      }

      final latestVersion = latestRelease['tag_name'] as String;
      final latestAssets = latestRelease['assets'] as List<dynamic>;
      for (final (asset as Map<String, dynamic>) in latestAssets) {
        final name = asset['name'] as String;
        if (name.contains('turms-chat-demo')) {
          return VersionedAsset(
              version: Version.parse(normalizeVersion(latestVersion)),
              asset: GithubAsset.fromJson(asset));
        }
      }
      return null;
    }
    throw HttpResponseException(response);
  }

  static String normalizeVersion(String version) {
    if (version.startsWith('v')) {
      final index = version.indexOf('-', 1);
      if (index == -1) {
        return version.substring(1);
      } else {
        return version.substring(1, index);
      }
    }
    final index = version.indexOf('-', 1);
    if (index == -1) {
      return version;
    } else {
      return version.substring(0, index);
    }
  }
}
