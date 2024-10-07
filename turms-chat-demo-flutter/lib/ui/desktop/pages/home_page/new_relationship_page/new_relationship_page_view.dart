import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../themes/index.dart';
import '../../../components/t_empty/t_empty.dart';
import '../../../components/t_empty/t_empty_result.dart';
import '../../../components/t_search_bar/t_search_bar.dart';
import '../../../components/t_title_bar/t_title_bar.dart';
import 'new_relationship_page_controller.dart';
import 'relationship_info_tile.dart';

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
          TTitleBar(
            backgroundColor: context.appThemeExtension.homePageBackgroundColor,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }

  Column _buildPage(AppLocalizations appLocalizations) {
    final isSearching = newRelationshipPageController.isSearching;
    return Column(children: [
      Sizes.sizedBoxH16,
      Text(appLocalizations.addNewRelationship),
      Sizes.sizedBoxH16,
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: safeAreaPaddingHorizontal),
        child: TSearchBar(
          hintText: appLocalizations.search,
          autofocus: true,
          onSubmitted: newRelationshipPageController.searchUser,
        ),
      ),
      Sizes.sizedBoxH8,
      Expanded(
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
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
                ),
                const SizedBox(height: 8),
                if (!isSearching) Expanded(child: _buildSearchResultTabView())
              ],
            ),
            if (isSearching)
              const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              )
          ],
        ),
      ),
    ]);
  }

  Widget _buildSearchResultTabView() {
    final contacts = newRelationshipPageController.contacts;
    final contactCount = contacts.length;
    final idToIndex = {
      for (var i = 0; i < contactCount; i++) contacts[i].id: i
    };
    return TabBarView(
        controller: newRelationshipPageController.tabController,
        // TODO: Add search for groups
        children: List.generate(
          2,
          (index) => contacts.isEmpty
              ? newRelationshipPageController.isSearchResultEmpty
                  ? const TEmptyResult(
                      icon: Symbols.person_rounded,
                    )
                  : const TEmpty()
              : ListView.builder(
                  findChildIndexCallback: (key) =>
                      idToIndex[(key as ValueKey<String>).value],
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return RelationshipInfoTile(
                      key: ValueKey(contact.id),
                      isGroup: index == 1,
                      contact: contact,
                      onTap: () => newRelationshipPageController
                          .openFriendRequestDialog(contact),
                    );
                  }),
        ));
  }
}
