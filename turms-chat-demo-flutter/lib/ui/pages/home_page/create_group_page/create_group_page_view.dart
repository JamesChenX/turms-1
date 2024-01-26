import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:turms_chat_demo/domain/user/models/user_contact.dart';
import 'package:turms_chat_demo/ui/l10n/app_localizations.dart';

import '../../../components/components.dart';
import '../../../themes/theme_config.dart';
import 'create_group_page_controller.dart';

class CreateGroupPageView extends StatelessWidget {
  const CreateGroupPageView(this.createGroupPageController);

  final CreateGroupPageController createGroupPageController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = createGroupPageController.appLocalizations;
    final userContacts = createGroupPageController.userContacts;
    return SizedBox(
      width: ThemeConfig.dialogWidthMedium,
      height: ThemeConfig.dialogHeightMedium,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: ThemeConfig.paddingV8H16,
              child: Column(children: [
                Text(appLocalizations.createGroup),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: ThemeConfig.dividerColor,
                        ),
                        borderRadius: ThemeConfig.borderRadius4),
                    child: Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TSearchBar(hintText: 'search'),
                              )),
                              const TVerticalDivider(),
                              Expanded(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  appLocalizations.selectedContacts,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _buildContacts(userContacts)),
                              const TVerticalDivider(),
                              Expanded(
                                  child:
                                      _buildSelectedContacts(appLocalizations))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                _buildActions()
              ]),
            ),
          ),
          // const Expanded(
          //   child: SettingsPane(),
          // ),
          const TTitleBar(
            backgroundColor: ThemeConfig.homePageBackgroundColor,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }

  ListView _buildContacts(List<UserContact> userContacts) => ListView.builder(
      itemCount: userContacts.length,
      itemBuilder: (BuildContext context, int index) {
        final userContact = userContacts[index];
        return TListTile(
          backgroundColor: Colors.white,
          padding: ThemeConfig.paddingH8,
          height: 40,
          child: Row(
            children: [
              TSimpleCheckbox(
                  value: createGroupPageController.selectedUserContactIds
                      .contains(userContact.userId),
                  onChanged: (value) {
                    createGroupPageController.onContactSelectedChanged(
                        userContact, value);
                  }),
              const SizedBox(
                width: 8,
              ),
              TAvatar(
                name: userContact.name,
                size: TAvatarSize.small,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  userContact.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      });

  Widget _buildSelectedContacts(AppLocalizations appLocalizations) {
    final selectedUserContacts = createGroupPageController.selectedUserContacts;
    return ListView.builder(
        itemCount: selectedUserContacts.length,
        itemBuilder: (BuildContext context, int index) {
          final userContact = selectedUserContacts[index];
          return TListTile(
            backgroundColor: Colors.white,
            padding: ThemeConfig.paddingH8,
            height: 40,
            child: Stack(
              children: [
                Row(
                  children: [
                    TAvatar(
                      name: userContact.name,
                      size: TAvatarSize.small,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        userContact.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 8,
                    child: TIconButton(
                      iconData: Symbols.close_rounded,
                      iconColor: ThemeConfig.textColorSecondary,
                      iconSize: 16,
                      addContainer: false,
                      onTap: () {
                        createGroupPageController.onContactSelectedChanged(
                            userContact, false);
                      },
                    ))
              ],
            ),
          );
        });
  }

  Widget _buildActions() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TTextButton.outlined(
            text: createGroupPageController.appLocalizations.cancel,
            padding: ThemeConfig.paddingV4H8,
            width: 64,
            onTap: createGroupPageController.close,
          ),
          const SizedBox(
            width: 16,
          ),
          TTextButton(
            isLoading: createGroupPageController.isCreating,
            text: createGroupPageController.appLocalizations.create,
            padding: ThemeConfig.paddingV4H8,
            width: 64,
            onTap: createGroupPageController.createGroup,
          )
        ],
      );
}