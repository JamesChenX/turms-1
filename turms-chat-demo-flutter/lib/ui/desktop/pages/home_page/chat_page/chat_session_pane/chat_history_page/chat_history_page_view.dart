import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../themes/index.dart';
import '../../../../../components/index.dart';
import 'chat_history_page_controller.dart';

const safeAreaPaddingHorizontal = 24.0;

class ChatHistoryPageView extends StatelessWidget {
  const ChatHistoryPageView(this.chatHistoryController);

  final ChatHistoryPageController chatHistoryController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = chatHistoryController.appLocalizations;
    final appThemeExtension = context.appThemeExtension;
    return SizedBox(
      width: Sizes.dialogWidthMedium,
      height: Sizes.dialogHeightMedium,
      child: Stack(
        children: [
          Positioned.fill(
            child: _buildPage(appLocalizations),
          ),
          TTitleBar(
            backgroundColor: appThemeExtension.homePageBackgroundColor,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }

  Column _buildPage(AppLocalizations appLocalizations) => Column(children: [
        Sizes.sizedBoxH16,
        Text(appLocalizations.addNewRelationship),
        Sizes.sizedBoxH16,
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
        Sizes.sizedBoxH8,
        Expanded(
          child: Stack(
            children: [
              Column(
                spacing: 8,
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: TabBar(
                  //     isScrollable: true,
                  //     tabAlignment: TabAlignment.start,
                  //     padding: Sizes.paddingH8,
                  //     dividerHeight: 0,
                  //     controller: chatHistoryController.tabController,
                  //     tabs: [
                  //       Tab(
                  //         text: appLocalizations.addContact,
                  //         height: 40,
                  //       ),
                  //       Tab(
                  //         text: appLocalizations.joinGroup,
                  //         height: 40,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(child: _buildSearchResultTabView())
                ],
              ),
            ],
          ),
        ),
      ]);

  Widget _buildSearchResultTabView() {
    return const Placeholder();
    // final contacts = chatHistoryController.contacts;
    // return contacts.isEmpty
    //     ? chatHistoryController.isSearchResultEmpty
    //         ? const TEmptyResult(
    //             icon: Symbols.person_rounded,
    //           )
    //         : const TEmpty()
    //     : ListView(
    //         children: contacts
    //             .map<Widget>((contact) => RelationshipInfoTile(
    //                   isGroup: index == 1,
    //                   contact: contact,
    //                   onTap: () => chatHistoryController
    //                       .openFriendRequestDialog(contact),
    //                 ))
    //             .toList(),
    //       );
  }
}
