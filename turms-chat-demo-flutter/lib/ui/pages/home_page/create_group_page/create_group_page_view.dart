import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../domain/user/models/index.dart';
import '../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../infra/ui/text_utils.dart';
import '../../../components/components.dart';
import '../../../l10n/app_localizations.dart';
import '../../../themes/theme_config.dart';
import 'create_group_page_controller.dart';

class CreateGroupPageView extends StatelessWidget {
  const CreateGroupPageView(this.createGroupPageController);

  final CreateGroupPageController createGroupPageController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = createGroupPageController.appLocalizations;
    return SizedBox(
      width: ThemeConfig.dialogWidthMedium,
      height: ThemeConfig.dialogHeightMedium,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildBody(appLocalizations),
          ),
          const TTitleBar(
            backgroundColor: ThemeConfig.homePageBackgroundColor,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations appLocalizations) => Padding(
        padding: ThemeConfig.paddingV8H16,
        child: Column(children: [
          Text(appLocalizations.createGroup),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: ThemeConfig.dividerColor),
                  borderRadius: ThemeConfig.borderRadius4),
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: ThemeConfig.paddingH8,
                          child: TSearchBar(
                            hintText: appLocalizations.search,
                            transformValue: (value) {
                              createGroupPageController.updateSearchText(value);
                              return value;
                            },
                          ),
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
                        Expanded(child: _buildContacts()),
                        const TVerticalDivider(),
                        Expanded(
                            child: _buildSelectedContacts(appLocalizations))
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
      );

  ListView _buildContacts() {
    final matchedUserContacts = createGroupPageController.userContacts
        .expand<(UserContact, List<TextSpan>)>((contact) {
      final searchText = createGroupPageController.searchText;
      final spans = TextUtils.splitText(
          text: contact.name,
          searchText: searchText,
          searchTextStyle: ThemeConfig.textStyleHighlight);
      if (spans.length == 1 && searchText.isNotBlank) {
        return [];
      }
      return [(contact, spans)];
    }).toList();

    final itemCount = matchedUserContacts.length;
    final matchedContactIdToIndex = {
      for (var i = 0; i < itemCount; i++) matchedUserContacts[i].$1.id: i
    };
    return ListView.builder(
        itemCount: matchedUserContacts.length,
        findChildIndexCallback: (key) =>
            matchedContactIdToIndex[(key as ValueKey<String>).value],
        itemBuilder: (BuildContext context, int index) {
          final (userContact, spans) = matchedUserContacts[index];
          return TListTile(
            key: Key(userContact.id),
            backgroundColor: Colors.white,
            padding: ThemeConfig.paddingH8,
            height: 40,
            child: Row(
              children: [
                TSimpleCheckbox(
                    value: createGroupPageController.selectedUserContactIds
                        .contains(userContact.userId),
                    onChanged: (value) {
                      if (value) {
                        createGroupPageController
                            .addSelectedContact(userContact);
                      } else {
                        createGroupPageController
                            .removeSelectedContact(userContact);
                      }
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
                  child: Text.rich(
                    TextSpan(
                      children: spans,
                    ),
                    // userContact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _buildSelectedContacts(AppLocalizations appLocalizations) {
    final selectedUserContacts = createGroupPageController.selectedUserContacts;
    final itemCount = selectedUserContacts.length;
    final selectedUserContactIdToIndex = {
      for (var i = 0; i < itemCount; i++) i: i
    };
    return ListView.builder(
        itemCount: itemCount,
        findChildIndexCallback: (key) =>
            selectedUserContactIdToIndex[(key as ValueKey<String>).value],
        itemBuilder: (BuildContext context, int index) {
          final userContact = selectedUserContacts[index];
          return TListTile(
            key: Key(userContact.id),
            backgroundColor: Colors.white,
            padding: ThemeConfig.paddingH8,
            height: 40,
            child: Row(
              children: [
                TAvatar(
                  name: userContact.name,
                  size: TAvatarSize.small,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userContact.name,
                    // userContact.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TIconButton(
                  iconData: Symbols.close_rounded,
                  iconColor: ThemeConfig.textColorSecondary,
                  iconSize: 16,
                  addContainer: false,
                  onTap: () {
                    createGroupPageController
                        .removeSelectedContact(userContact);
                  },
                )
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
            disabled:
                createGroupPageController.selectedUserContactIds.length <= 1,
            text: createGroupPageController.appLocalizations.create,
            padding: ThemeConfig.paddingV4H8,
            width: 64,
            onTap: createGroupPageController.createGroup,
          )
        ],
      );
}
