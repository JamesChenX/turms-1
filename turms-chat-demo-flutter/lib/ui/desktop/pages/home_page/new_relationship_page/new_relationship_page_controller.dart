import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../../../domain/user/models/index.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import 'friend_request_page/friend_request_page.dart';
import 'new_relationship_page.dart';
import 'new_relationship_page_view.dart';
import 'search_type.dart';

class NewRelationshipPageController extends ConsumerState<NewRelationshipPage>
    with SingleTickerProviderStateMixin {
  late AppLocalizations appLocalizations;
  late TabController tabController;

  List<Contact> contacts = [];

  bool isSearching = false;
  bool isSearchResultEmpty = false;
  late SearchType searchType;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    if (widget.showAddContactPage) {
      searchType = SearchType.user;
      tabController.index = 0;
    } else {
      searchType = SearchType.group;
      tabController.index = 1;
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return NewRelationshipPageView(this);
  }

  Future<void> _search(SearchType searchType, String value) async {
    final num = Int64.tryParseInt(value);
    if (num == null) {
      contacts = [];
      isSearchResultEmpty = true;
      setState(() {});
      return;
    }
    isSearching = true;
    setState(() {});
    // TODO: use real API
    await Future.delayed(const Duration(seconds: 3));
    switch (searchType) {
      case SearchType.user:
        contacts = [
          UserContact(
            userId: num,
            name: 'a fake user name: $value' * 10,
            intro: 'a fake user intro',
            relationshipGroupId: Int64(-1),
          )
        ];
      case SearchType.group:
        contacts = [
          GroupContact(
            groupId: num,
            name: 'a fake group name: $value' * 10,
            intro: 'a fake group intro',
            members: [],
          )
        ];
    }
    isSearching = false;
    isSearchResultEmpty = false;
    setState(() {});
  }

  Future<void> searchUser(String value) => _search(SearchType.user, value);

  Future<void> searchGroup(String value) => _search(SearchType.group, value);

  void openFriendRequestDialog(Contact contact) {
    showFriendRequestDialog(context, contact);
  }
}