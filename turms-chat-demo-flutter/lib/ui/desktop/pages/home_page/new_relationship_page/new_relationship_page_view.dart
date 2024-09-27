import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../themes/theme_config.dart';
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
      width: ThemeConfig.dialogWidthMedium,
      height: ThemeConfig.dialogHeightMedium,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildPage(appLocalizations),
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

  Column _buildPage(AppLocalizations appLocalizations) => Column(children: [
        const SizedBox(height: 16),
        Text(appLocalizations.addNewRelationship),
        const SizedBox(height: 16),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: safeAreaPaddingHorizontal),
          child: TSearchBar(
            hintText: appLocalizations.search,
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
      ]);

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