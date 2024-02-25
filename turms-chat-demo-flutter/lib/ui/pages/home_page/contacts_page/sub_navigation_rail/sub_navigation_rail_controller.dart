import 'dart:async';

import 'package:pixel_snap/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../domain/user/models/index.dart';
import '../../../../../fixtures/contacts.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../view_models/contacts_view_model.dart';
import '../view_models/is_contacts_initialized_view_model.dart';
import '../view_models/selected_contact_view_model.dart';
import 'sub_navigation_rail.dart';
import 'sub_navigation_rail_view.dart';

class SubNavigationRailController extends ConsumerState<SubNavigationRail> {
  late AppLocalizations appLocalizations;
  late List<Contact> contacts;
  Contact? selectedContact;
  bool isContactsInitialized = false;
  bool isContactsLoading = false;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (contacts.isNotEmpty) {
        return;
      }
      contacts = ref.watch(contactsViewModel);
      if (isContactsLoading) {
        return;
      }
      final isContactsInitialized = ref.read(isContactsInitializedViewModel);
      if (!isContactsInitialized) {
        loadContacts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    contacts = ref.watch(contactsViewModel);
    selectedContact = ref.watch(selectedContactViewModel);
    return SubNavigationRailView(this);
  }

  void selectContact(Contact contact) {
    ref.read(selectedContactViewModel.notifier).state = contact;
  }

  Future<void> loadContacts() async {
    isContactsLoading = true;
    setState(() {});
    // TODO: use real API
    await Future.delayed(const Duration(seconds: 3));
    ref.read(contactsViewModel.notifier).state = [
      SystemContact(
          type: SystemContactType.friendRequest,
          name: appLocalizations.friendRequests,
          icon: Symbols.person_add_rounded),
      SystemContact(
          type: SystemContactType.fileTransfer,
          name: appLocalizations.fileTransfer,
          icon: Symbols.drive_file_move_rounded),
    ]..addAll(fixtureContacts);
    ref.read(isContactsInitializedViewModel.notifier).state = true;
    isContactsInitialized = true;
    isContactsLoading = false;
    setState(() {});
  }

  void updateSearchText(String value) {
    searchText = value;
    setState(() {});
  }
}
