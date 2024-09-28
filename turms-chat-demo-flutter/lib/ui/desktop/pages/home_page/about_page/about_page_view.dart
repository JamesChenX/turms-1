import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../infra/app/app_config.dart';
import '../../../../../infra/assets/assets.gen.dart';
import '../../../../../infra/github/github_client.dart';
import '../../../../themes/theme_config.dart';
import '../../../components/t_button/t_text_button.dart';
import '../../../components/t_title_bar/t_title_bar.dart';
import '../../../components/t_toast/t_toast.dart';
import 'about_page_controller.dart';

class AboutPageView extends StatelessWidget {
  const AboutPageView(this.aboutPageController, {super.key});

  final AboutPageController aboutPageController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = aboutPageController.appLocalizations;
    return SizedBox(
      width: 450,
      height: 300,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 36, bottom: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  width: 320,
                  Assets.images.logo,
                ),
                Column(children: [
                  TTextButton(
                      text: appLocalizations.update,
                      isLoading: aboutPageController.isDownloading,
                      onTap: () async {
                        aboutPageController.updateIsDownloading(true);
                        // TODO: Support installing automatically
                        String text;
                        try {
                          final file = await GithubUtils.downloadLatestApp();
                          if (file == null) {
                            text = appLocalizations.alreadyLatestVersion;
                          } else {
                            text = 'Downloaded: ${file.absolute.path}';
                          }
                        } catch (e) {
                          text =
                              'Failed to download latest application: ${e.toString()}';
                        }
                        aboutPageController.updateIsDownloading(false);
                        unawaited(TToast.showToast(context, text));
                      })
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${appLocalizations.version}:  ${AppConfig.packageInfo.version}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    const Text('GitHub'),
                    TTextButton(
                        text: 'github.com/turms-im/turms',
                        containerColor: Colors.transparent,
                        containerColorHovered: Colors.transparent,
                        textStyle:
                            const TextStyle(color: ThemeConfig.linkColor),
                        textStyleHovered: const TextStyle(
                            color: ThemeConfig.linkColorHovered),
                        onTap: aboutPageController.openGitHub)
                  ],
                )
              ],
            ),
          ),
          const TTitleBar(
            backgroundColor: Colors.transparent,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }
}