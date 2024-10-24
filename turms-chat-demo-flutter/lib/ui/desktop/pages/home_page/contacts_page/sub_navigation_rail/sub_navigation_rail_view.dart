import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../domain/user/fixtures/contacts.dart';
import '../../../../../../domain/user/fixtures/relationship_groups.dart';
import '../../../../../../domain/user/models/index.dart';
import '../../../../../../domain/user/services/user_service.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../../infra/ui/text_utils.dart';
import '../../../../../themes/index.dart';
import '../../../../components/t_accordion/t_accordion.dart';
import '../../../../components/t_search_bar/t_search_bar.dart';
import '../contact_tile.dart';
import 'sub_navigation_rail_controller.dart';

const backgroundColor = Color.fromARGB(255, 233, 233, 233);

class SubNavigationRailView extends StatelessWidget {
  const SubNavigationRailView(this.subNavigationRailController, {super.key});

  final SubNavigationRailController subNavigationRailController;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final appThemeExtension = theme.appThemeExtension;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 1),
        child: ColoredBox(
            color: backgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(context, appThemeExtension),
                if (subNavigationRailController.isContactsLoading)
                  _buildLoadingIndicator(appThemeExtension),
                Expanded(
                  child: subNavigationRailController.searchText.isNotBlank
                      ? _buildSearchResults(appThemeExtension)
                      // TODO: use builder
                      : ListView(
                          children: _buildRelationshipGroups(context),
                        ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildLoadingIndicator(AppThemeExtension appThemeExtension) =>
      SizedBox(
        height: 40,
        child: ColoredBox(
          color: appThemeExtension
              .subNavigationRailLoadingIndicatorBackgroundColor,
          child: const Center(
            child: CupertinoActivityIndicator(radius: 8),
          ),
        ),
      );

  Widget _buildSearchBar(
          BuildContext context, AppThemeExtension appThemeExtension) =>
      SizedBox(
        height: Sizes.homePageHeaderHeight,
        child: ColoredBox(
          color: appThemeExtension.subNavigationRailSearchBarBackgroundColor,
          child: Padding(
            padding: Sizes.paddingH12,
            child: Center(
              child: TSearchBar(
                hintText: subNavigationRailController.appLocalizations.search,
                onChanged: subNavigationRailController.updateSearchText,
              ),
            ),
          ),
        ),
      );

  Widget _buildSearchResults(AppThemeExtension appThemeExtension) {
    final selectedContactId = subNavigationRailController.selectedContact?.id;
    final searchText = subNavigationRailController.searchText;
    final isSearchMode = searchText.isNotBlank;
    final matchedContacts =
        subNavigationRailController.contacts.expand<_StyledContact>((contact) {
      final nameTextSpans = TextUtils.highlightSearchText(
          text: contact.name,
          searchText: searchText,
          searchTextStyle: appThemeExtension.highlightTextStyle);
      if (nameTextSpans.length == 1 && isSearchMode) {
        return [];
      }
      return [_StyledContact(contact: contact, nameTextSpans: nameTextSpans)];
    }).toList();

    final itemCount = matchedContacts.length;
    final contactIdToIndex = {
      for (var i = 0; i < itemCount; i++) matchedContacts[i].contact.id: i
    };
    return ListView.builder(
        itemCount: itemCount,
        findChildIndexCallback: (key) =>
            contactIdToIndex[(key as ValueKey<String>).value],
        prototypeItem: ContactTile(
          contact: UserContact(userId: Int64.MIN_VALUE, name: ''),
          nameTextSpans: [],
          isSearchMode: true,
          selected: false,
          onTap: () {},
        ),
        itemBuilder: (BuildContext context, int index) {
          final _StyledContact(:contact, :nameTextSpans) =
              matchedContacts[index];
          return ContactTile(
            key: Key(contact.id),
            contact: contact,
            nameTextSpans: nameTextSpans,
            isSearchMode: true,
            selected: contact.id == selectedContactId,
            onTap: () {
              subNavigationRailController.selectContact(contact);
            },
          );
        });
  }

  List<Widget> _buildRelationshipGroups(BuildContext context) {
    final selectedContactId = subNavigationRailController.selectedContact?.id;
    final appLocalizations = subNavigationRailController.appLocalizations;
    final widgets = userService
        .getSystemContacts(appLocalizations)
        .map<Widget>((contact) => ContactTile(
              contact: contact,
              nameTextSpans: [],
              isSearchMode: false,
              selected: contact.id == selectedContactId,
              onTap: () {
                subNavigationRailController.selectContact(contact);
              },
            ))
        .toList();

    // TODO:
    // 1. Use real data
    // 2. Load contacts lazily if there are more than 20 contacts.
    for (final group in fixtureRelationshipGroups) {
      widgets.add(_buildRelationshipGroup(
          group.name, group.contacts, selectedContactId));
    }
    widgets.add(_buildRelationshipGroup(
        appLocalizations.groups, fixtureGroupContacts, selectedContactId));

    return widgets;
  }

  Widget _buildRelationshipGroup(
          String name, List<Contact> contacts, String? selectedContactId) =>
      TAccordion(
        titleChild: Row(
          spacing: 4,
          children: [
            Text(name),
            Text('(${contacts.length})'),
          ],
        ),
        contentChild: Column(
          children: contacts
              .map((contact) => ContactTile(
                    contact: contact,
                    selected: contact.id == selectedContactId,
                    onTap: () {
                      subNavigationRailController.selectContact(contact);
                    },
                    nameTextSpans: [],
                    isSearchMode: false,
                  ))
              .toList(),
        ),
      );
}

class _StyledContact {
  const _StyledContact({required this.contact, required this.nameTextSpans});

  final Contact contact;
  final List<TextSpan> nameTextSpans;
}