import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../components/t_empty.dart';
import '../../../components/t_empty_result.dart';
import '../../../components/t_search_bar.dart';
import '../../../components/t_title_bar.dart';
import '../../../themes/theme_config.dart';
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
      width: ThemeConfig.dialogWidthMedium,
      height: ThemeConfig.dialogHeightMedium,
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(children: [
              const SizedBox(height: 16),
              Text(appLocalizations.addNewRelationship),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: safeAreaPaddingHorizontal),
                child: TSearchBar(
                  hintText: 'search',
                  autofocus: true,
                  onSubmitted: newRelationshipPageController.searchUser,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          tabAlignment: TabAlignment.start,
                          controller:
                              newRelationshipPageController.tabController,
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
                        const SizedBox(height: 8),
                        if (!newRelationshipPageController.isSearching)
                          Expanded(child: _buildSearchResultTabView())
                      ],
                    ),
                    if (newRelationshipPageController.isSearching)
                      const Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ]),
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

  Widget _buildSearchResultTabView() {
    final contacts = newRelationshipPageController.contacts;
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
                : ListView(
                    children: contacts
                        .map<Widget>((contact) => RelationshipInfoTile(
                              isGroup: index == 1,
                              contact: contact,
                              onTap: () => newRelationshipPageController
                                  .openFriendRequestDialog(contact),
                            ))
                        .toList(),
                  )));
  }
}