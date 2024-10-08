import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/group/services/group_service.dart';
import '../../../../../domain/user/models/index.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/index.dart';
import '../../app_controller.dart';
import '../contacts_page/view_models/contacts_view_model.dart';
import 'create_group_page.dart';
import 'create_group_page_view.dart';

class CreateGroupPageController extends ConsumerState<CreateGroupPage> {
  late ThemeData theme;
  late AppThemeExtension appThemeExtension;
  late AppLocalizations appLocalizations;
  late List<UserContact> userContacts;

  final Set<Int64> selectedUserContactIds = {};
  final List<UserContact> selectedUserContacts = [];

  bool isCreating = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    theme = context.theme;
    appThemeExtension = theme.appThemeExtension;
    appLocalizations = ref.watch(appLocalizationsViewModel);
    userContacts = ref.watch(userContactsViewModel);
    return CreateGroupPageView(this);
  }

  void close() {
    AppController.popTopIfNameMatched(createGroupDialogRouteName);
  }

  Future<void> createGroup() async {
    isCreating = true;
    setState(() {});
    await groupService.createGroup();
    isCreating = false;
    close();
  }

  void addSelectedContact(UserContact userContact) {
    if (selectedUserContactIds.add(userContact.userId)) {
      selectedUserContacts.add(userContact);
      setState(() {});
    }
  }

  void removeSelectedContact(UserContact userContact) {
    if (selectedUserContactIds.remove(userContact.userId)) {
      selectedUserContacts.remove(userContact);
      setState(() {});
    }
  }

  void updateSearchText(String value) {
    searchText = value.toLowerCase().trim();
    setState(() {});
  }
}
