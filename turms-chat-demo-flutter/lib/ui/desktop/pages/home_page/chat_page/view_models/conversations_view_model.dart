import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/conversation/models/conversation.dart';

late StateProviderRef<List<Conversation>> conversationsViewModelRef;
final conversationsViewModel = StateProvider<List<Conversation>>((ref) {
  conversationsViewModelRef = ref;
  return [];
});
