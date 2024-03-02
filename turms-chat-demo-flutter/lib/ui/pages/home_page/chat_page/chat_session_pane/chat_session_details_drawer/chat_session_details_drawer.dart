import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../components/components.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../themes/theme_config.dart';

class ChatSessionDetailsDrawer extends ConsumerWidget {
  const ChatSessionDetailsDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    const divider = THorizontalDivider();
    return SizedBox(
      width: ThemeConfig.subNavigationRailWidth,
      height: double.infinity,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(width: 1, color: ThemeConfig.borderColor),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              const Align(
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
              const SizedBox(
                height: 8,
              ),
              TTextButton(
                text: appLocalizations.addNewMember,
              ),
              const SizedBox(
                height: 8,
              ),
              TSearchBar(hintText: appLocalizations.search),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                  child: ListView.separated(
                itemCount: 20,
                itemBuilder: (context, index) => Row(
                  children: [
                    TAvatar(name: 'name', size: TAvatarSize.small),
                    const SizedBox(
                      width: 8,
                    ),
                    const Expanded(
                        child: Text(
                      'a very long name, a very long name, a very long name, a very long name',
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(Symbols.crowdsource)
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(
                  height: 4,
                ),
              )),
              const SizedBox(
                height: 8,
              ),
              TTextButton(
                text: appLocalizations.leaveGroup,
              )
            ],
          ),
        ),
      ),
    );
  }
}
