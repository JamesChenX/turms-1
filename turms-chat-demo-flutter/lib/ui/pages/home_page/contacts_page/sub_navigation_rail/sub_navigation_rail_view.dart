import 'package:flutter/cupertino.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../../../domain/user/models/system_contact.dart';
import '../../../../../fixtures/contacts.dart';
import '../../../../../fixtures/relationship_groups.dart';
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
            child: ListView(
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
        ),
      );

  List<Widget> _buildRelationshipGroups(BuildContext context) {
    final selectedContactId = subNavigationRailController.selectedContact?.id;
    final appLocalizations = subNavigationRailController.appLocalizations;
    final widgets = [
      SystemContact(
          type: SystemContactType.friendRequest,
          name: appLocalizations.friendRequests),
      SystemContact(
        type: SystemContactType.fileTransfer,
        name: appLocalizations.fileTransfer,
      ),
    ]
        .map<Widget>((contact) => ContactTile(
            contact: contact,
            focused: contact.id == selectedContactId,
            onTap: () {
              subNavigationRailController.selectContact(contact);
            }))
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
                  focused: contact.id == selectedContactId,
                  onTap: () {
                    subNavigationRailController.selectContact(contact);
                  }))
              .toList(),
        ),
      );
}