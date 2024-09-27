import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/user/models/index.dart';

final contactsViewModel = StateProvider<List<Contact>>((ref) => []);

final userContactsViewModel = StateProvider<List<UserContact>>((ref) => ref
    .watch(contactsViewModel)
    .where((element) => element is UserContact)
    .cast<UserContact>()
    .toList());