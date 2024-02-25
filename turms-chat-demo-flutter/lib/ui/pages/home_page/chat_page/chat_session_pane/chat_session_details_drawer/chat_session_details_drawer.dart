import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../components/t_horizontal_divider.dart';
import '../../../../../components/t_search_bar.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../themes/theme_config.dart';

class ChatSessionDetailsDrawer extends ConsumerWidget {
  const ChatSessionDetailsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    const divider = THorizontalDivider();
    return SizedBox(
      width: 250,
      height: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 1, color: ThemeConfig.borderDefaultColor),
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SelectionArea(child: Text('name')),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                child: SelectionArea(
                  child: Text(
                    'intro'.padRight(200, '123test'),
                    softWrap: true,
                    maxLines: 4,
                    style: ThemeConfig.textStyleSecondary,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              divider,
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(appLocalizations.muteNotifications),
                  SizedBox(
                    height: 24,
                    child: FittedBox(
                      child: CupertinoSwitch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(appLocalizations.stickOnTop),
                  CupertinoSwitch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
              divider,
              TSearchBar(hintText: appLocalizations.search),
              Row(
                children: [
                  Text('add new memember'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
