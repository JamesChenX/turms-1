import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/group/services/group_service.dart';
import '../../../../../domain/user/models/contact.dart';
import '../../../../../domain/user/models/index.dart';
import '../../../../../domain/user/services/user_service.dart';
import '../../../../../infra/data/t_async_data.dart';
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

  TAsyncData<List<Contact>> userContacts = TAsyncData();
  TAsyncData<List<Contact>> groupContacts = TAsyncData();

  late SearchType searchType;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          if (tabController.index == 0) {
            searchType = SearchType.user;
          } else {
            searchType = SearchType.group;
          }
        },
      );
    if (widget.showAddContactPage) {
      tabController.index = 0;
    } else {
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

  Future<void> _search(SearchType searchType, String value,
      TAsyncData<List<dynamic>> contactsData) async {
    final num = Int64.tryParseInt(value);
    if (num == null) {
      contactsData.lastValue = [];
      setState(() {});
      return;
    }
    contactsData.isLoading = true;
    setState(() {});
    switch (searchType) {
      case SearchType.user:
        contactsData.lastValue =
            await userService.searchUserContacts(num, value);
        break;
      case SearchType.group:
        contactsData.lastValue =
            await groupService.searchGroupContacts(num, value);
        break;
    }
    contactsData.isLoading = false;
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> searchUser(String value) =>
      _search(SearchType.user, value, userContacts);

  Future<void> searchGroup(String value) =>
      _search(SearchType.group, value, groupContacts);

  void openFriendRequestDialog(Contact contact) {
    showFriendRequestDialog(context, contact);
  }

  void openGroupJoinRequestDialog(Contact contact) {
    // TODO
    showFriendRequestDialog(context, contact);
  }
}
