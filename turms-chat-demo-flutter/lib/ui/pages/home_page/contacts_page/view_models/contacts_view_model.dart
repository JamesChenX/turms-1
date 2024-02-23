import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../../../domain/user/models/user_contact.dart';

late StateProviderRef<List<Contact>> contactsViewModelRef;
final contactsViewModel = StateProvider<List<Contact>>((ref) {
  contactsViewModelRef = ref;
  return [];
});

final userContactsViewModel = StateProvider<List<UserContact>>((ref) => ref
    .watch(contactsViewModel)
    .where((element) => element is UserContact)
    .cast<UserContact>()
    .toList());
