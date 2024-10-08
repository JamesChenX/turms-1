import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/user/models/index.dart';
import '../../../../../../domain/user/services/user_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
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
    final contactsController = ref.read(contactsViewModel.notifier);
    final isContactsInitializedController =
        ref.read(isContactsInitializedViewModel.notifier);
    setState(() {});

    final contacts = await userService.queryContacts(appLocalizations);

    contactsController.state = contacts;
    isContactsInitializedController.state = true;
    isContactsInitialized = true;
    isContactsLoading = false;
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void updateSearchText(String value) {
    searchText = value;
    setState(() {});
  }
}
