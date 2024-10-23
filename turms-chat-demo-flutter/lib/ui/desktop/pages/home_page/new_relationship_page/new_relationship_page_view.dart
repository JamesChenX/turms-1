import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../../../infra/data/t_async_data.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../themes/index.dart';
import '../../../components/t_empty/t_empty.dart';
import '../../../components/t_empty/t_empty_result.dart';
import '../../../components/t_search_bar/t_search_bar.dart';
import '../../../components/t_title_bar/t_title_bar.dart';
import 'new_relationship_page_controller.dart';
import 'relationship_info_tile.dart';
import 'search_type.dart';

const safeAreaPaddingHorizontal = 24.0;

class NewRelationshipPageView extends StatelessWidget {
  const NewRelationshipPageView(this.newRelationshipPageController);

  final NewRelationshipPageController newRelationshipPageController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = newRelationshipPageController.appLocalizations;
    return SizedBox(
      width: Sizes.dialogWidthMedium,
      height: Sizes.dialogHeightMedium,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildPage(appLocalizations),
          ),
          const TTitleBar(
            backgroundColor: Colors.white,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }

  Column _buildPage(AppLocalizations appLocalizations) => Column(children: [
        Sizes.sizedBoxH16,
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          dividerHeight: 0,
          controller: newRelationshipPageController.tabController,
          tabs: [
            Tab(
              text: appLocalizations.addContact,
              height: 40,
            ),
            Tab(
              text: appLocalizations.joinGroup,
              height: 40,
            )
          ],
        ),
        Sizes.sizedBoxH16,
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: safeAreaPaddingHorizontal),
          child: TSearchBar(
            hintText: appLocalizations.search,
            autofocus: true,
            onSubmitted: (value) {
              if (newRelationshipPageController.searchType == SearchType.user) {
                newRelationshipPageController.searchUser(value);
              } else {
                newRelationshipPageController.searchGroup(value);
              }
            },
          ),
        ),
        Sizes.sizedBoxH16,
        Expanded(
          child: TabBarView(
              controller: newRelationshipPageController.tabController,
              children: [
                _buildSearchResultView(
                    false, newRelationshipPageController.userContacts),
                _buildSearchResultView(
                    true, newRelationshipPageController.groupContacts),
              ]),
        ),
      ]);

  Widget _buildSearchResultView(
      bool isGroupContact, TAsyncData<List<Contact>> contactsData) {
    if (contactsData.isLoading) {
      return const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }
    final contacts = contactsData.lastValue ?? [];
    final contactCount = contacts.length;
    final idToIndex = {
      for (var i = 0; i < contactCount; i++) contacts[i].id: i
    };
    return contacts.isEmpty
        ? contactsData.isInitialized
            ? const TEmptyResult(
                icon: Symbols.person_rounded,
              )
            : const TEmpty()
        : ListView.builder(
            itemCount: contactCount,
            findChildIndexCallback: (key) =>
                idToIndex[(key as ValueKey<String>).value],
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return RelationshipInfoTile(
                key: ValueKey(contact.id),
                isGroup: isGroupContact,
                contact: contact,
                onTap: () {
                  if (isGroupContact) {
                    newRelationshipPageController
                        .openGroupJoinRequestDialog(contact);
                  } else {
                    newRelationshipPageController
                        .openFriendRequestDialog(contact);
                  }
                },
              );
            });
  }
}
