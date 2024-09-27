import 'package:fixnum/fixnum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/index.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../contacts_page/view_models/contacts_view_model.dart';
import 'create_group_page.dart';
import 'create_group_page_view.dart';

class CreateGroupPageController extends ConsumerState<CreateGroupPage> {
  late AppLocalizations appLocalizations;
  late List<UserContact> userContacts;

  final Set<Int64> selectedUserContactIds = {};
  final List<UserContact> selectedUserContacts = [];

  bool isCreating = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    userContacts = ref.watch(userContactsViewModel);
    return CreateGroupPageView(this);
  }

  void close() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> createGroup() async {
    isCreating = true;
    setState(() {});
    // TODO: use real API
    await Future.delayed(const Duration(seconds: 3));
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