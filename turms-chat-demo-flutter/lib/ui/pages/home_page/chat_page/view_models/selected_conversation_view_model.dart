import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/conversation/models/conversation.dart';

late StateProviderRef<Conversation?> selectedConversationViewModelRef;
final selectedConversationViewModel = StateProvider<Conversation?>((ref) {
  selectedConversationViewModelRef = ref;
  return null;
});