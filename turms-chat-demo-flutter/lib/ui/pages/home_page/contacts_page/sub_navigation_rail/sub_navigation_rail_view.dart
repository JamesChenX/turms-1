import 'package:pixel_snap/cupertino.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../domain/user/models/index.dart';
import '../../../../../fixtures/contacts.dart';
import '../../../../../fixtures/relationship_groups.dart';
import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../infra/ui/text_utils.dart';
import '../../../../components/t_accordion.dart';
import '../../../../components/t_search_bar.dart';
import '../../../../themes/theme_config.dart';
import '../contact_tile.dart';
import 'sub_navigation_rail_controller.dart';

const backgroundColor = Color.fromARGB(255, 233, 233, 233);

class SubNavigationRailView extends StatelessWidget {
  const SubNavigationRailView(this.subNavigationRailController, {super.key});

  final SubNavigationRailController subNavigationRailController;

  @override
  Widget build(BuildContext context) => ColoredBox(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(context),
          if (subNavigationRailController.isContactsLoading)
            _buildLoadingIndicator(),
          Expanded(
            child: subNavigationRailController.searchText.isNotBlank
                ? _buildSearchResults()
                : ListView(
                    children: _buildRelationshipGroups(context),
                  ),
          ),
        ],
      ));

  Widget _buildLoadingIndicator() => Container(
        alignment: AlignmentDirectional.center,
        height: 40,
        color: const Color.fromARGB(255, 237, 237, 237),
        child: const CupertinoActivityIndicator(radius: 8),
      );

  Widget _buildSearchBar(BuildContext context) => Container(
        height: ThemeConfig.homePageHeaderHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: const Color.fromARGB(255, 247, 247, 247),
        alignment: Alignment.center,
        child: TSearchBar(
          hintText: subNavigationRailController.appLocalizations.search,
          transformValue: (value) {
            subNavigationRailController.updateSearchText(value);
            return value;
          },
        ),
      );

  Widget _buildSearchResults() {
    final selectedContactId = subNavigationRailController.selectedContact?.id;
    final matchedContacts = subNavigationRailController.contacts
        .expand<(Contact, List<TextSpan>)>((contact) {
      final searchText = subNavigationRailController.searchText;
      final spans = TextUtils.splitText(
          text: contact.name,
          searchText: searchText,
          searchTextStyle: ThemeConfig.textStyleHighlight);
      if (spans.length == 1 && searchText.isNotBlank) {
        return [];
      }
      return [(contact, spans)];
    }).toList();

    return ListView.builder(
        itemCount: matchedContacts.length,
        itemBuilder: (BuildContext context, int index) {
          final (contact, spans) = matchedContacts[index];
          return ContactTile(
            contact: contact,
            selected: contact.id == selectedContactId,
            onTap: () {
              subNavigationRailController.selectContact(contact);
            },
            nameTextSpans: spans,
            isSearchMode: true,
          );
        });
  }

  List<Widget> _buildRelationshipGroups(BuildContext context) {
    final selectedContactId = subNavigationRailController.selectedContact?.id;
    final appLocalizations = subNavigationRailController.appLocalizations;
    final widgets = [
      SystemContact(
          type: SystemContactType.friendRequest,
          name: appLocalizations.friendRequests,
          icon: Symbols.person_add_rounded),
      SystemContact(
          type: SystemContactType.fileTransfer,
          name: appLocalizations.fileTransfer,
          icon: Symbols.drive_file_move_rounded),
    ]
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
          children: [
            Text(name),
            const SizedBox(
              width: 4,
            ),
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
