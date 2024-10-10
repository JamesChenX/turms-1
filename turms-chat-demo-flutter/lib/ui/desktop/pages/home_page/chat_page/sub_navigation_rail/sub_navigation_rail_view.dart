import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../themes/index.dart';

import '../../../../components/index.dart';
import '../../create_group_page/create_group_page.dart';
import '../../new_relationship_page/new_relationship_page.dart';
import 'conversation_tiles.dart';
import 'sub_navigation_rail_controller.dart';

class SubNavigationRailView extends StatelessWidget {
  const SubNavigationRailView(this.subNavigationRailController, {super.key});

  final SubNavigationRailController subNavigationRailController;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final appThemeExtension = theme.appThemeExtension;
    return GestureDetector(
      child: Focus(
        onKeyEvent: subNavigationRailController.onKeyEvent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: theme.dividerColor),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 1),
            child: ColoredBox(
              color: appThemeExtension.conversationBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(context, appThemeExtension),
                  if (subNavigationRailController.isConversationsLoading)
                    _buildLoadingIndicator(),
                  _buildConversationTiles(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() => const SizedBox(
        height: 40,
        child: ColoredBox(
          color: Color.fromARGB(255, 237, 237, 237),
          child: Align(
            alignment: AlignmentDirectional.center,
            child: CupertinoActivityIndicator(radius: 8),
          ),
        ),
      );

  Widget _buildSearchBar(
      BuildContext context, AppThemeExtension appThemeExtension) {
    final appLocalizations = subNavigationRailController.appLocalizations;
    return SizedBox(
      height: Sizes.homePageHeaderHeight,
      child: ColoredBox(
        color: appThemeExtension.subNavigationRailSearchBarBackgroundColor,
        child: Padding(
          padding: Sizes.paddingH12,
          child: Center(
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  // todo: adapt height
                  child: TSearchBar(
                    focusNode: subNavigationRailController.searchBarFocusNode,
                    hintText: appLocalizations.search,
                    textEditingController: subNavigationRailController
                        .searchBarTextEditingController,
                    onChanged: subNavigationRailController.onSearchTextUpdated,
                    onSubmitted: (_) =>
                        subNavigationRailController.onSearchSubmitted(),
                  ),
                ),
                MenuAnchor(
                    controller: subNavigationRailController.menuController,
                    consumeOutsideTap: true,
                    alignmentOffset: const Offset(0, 8),
                    menuChildren: <Widget>[
                      MenuItemButton(
                        child: Text(appLocalizations.addContact),
                        onPressed: () {
                          showNewRelationshipDialog(context, true);
                        },
                      ),
                      MenuItemButton(
                        child: Text(appLocalizations.joinGroup),
                        onPressed: () {
                          showNewRelationshipDialog(context, false);
                        },
                      ),
                      MenuItemButton(
                        child: Text(appLocalizations.createGroup),
                        onPressed: () {
                          showCreateGroupDialog(context);
                        },
                      ),
                    ],
                    child: TIconButton(
                        iconData: Symbols.add_rounded,
                        iconSize: 20,
                        // todo: adapt height
                        containerSize: const Size(30, 30),
                        containerColor:
                            const Color.fromARGB(255, 226, 226, 226),
                        containerColorHovered:
                            const Color.fromARGB(255, 209, 209, 209),
                        onTap: () {
                          subNavigationRailController.menuController.open();
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConversationTiles(BuildContext context) => Expanded(
      child: ConversationTiles(
          subNavigationRailController: subNavigationRailController));
}
