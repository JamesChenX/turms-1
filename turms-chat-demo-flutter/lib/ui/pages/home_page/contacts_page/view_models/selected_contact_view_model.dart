import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/contact.dart';

late StateProviderRef<Contact?> selectedContactViewModelRef;
final selectedContactViewModel = StateProvider<Contact?>((ref) {
  selectedContactViewModelRef = ref;
  return null;
});
