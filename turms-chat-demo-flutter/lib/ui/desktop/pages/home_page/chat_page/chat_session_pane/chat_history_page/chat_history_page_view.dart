import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../../../components/index.dart';
import 'chat_history_page_controller.dart';

const safeAreaPaddingHorizontal = 24.0;

class ChatHistoryPageView extends StatelessWidget {
  const ChatHistoryPageView(this.chatHistoryController);

  final ChatHistoryPageController chatHistoryController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = chatHistoryController.appLocalizations;
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
            onChanged: chatHistoryController.search,
            onSubmitted: chatHistoryController.search,
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
                      controller: chatHistoryController.tabController,
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
                  Expanded(child: _buildSearchResultTabView())
                ],
              ),
            ],
          ),
        ),
      ]);

  Widget _buildSearchResultTabView() {
    final contacts = chatHistoryController.contacts;
    return TabBarView(
        controller: chatHistoryController.tabController,
        // TODO: Add search for groups
        children: List.generate(
            2,
            (index) => contacts.isEmpty
                ? chatHistoryController.isSearchResultEmpty
                    ? const TEmptyResult(
                        icon: Symbols.person_rounded,
                      )
                    : const TEmpty()
                : ListView(
                    children: contacts
                        .map<Widget>((contact) => RelationshipInfoTile(
                              isGroup: index == 1,
                              contact: contact,
                              onTap: () => chatHistoryController
                                  .openFriendRequestDialog(contact),
                            ))
                        .toList(),
                  )));
  }
}