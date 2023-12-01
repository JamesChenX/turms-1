import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_page_tab.dart';
import '../shared_components/conversation.dart';

final homePageTabProvider =
    StateProvider<HomePageTab>((ref) => HomePageTab.chat);

late StateProviderRef<List<ConversationData>> conversationsViewModelRef;
final conversationsViewModel = StateProvider<List<ConversationData>>((ref) {
  conversationsViewModelRef = ref;
  return [];
});

late StateProviderRef<ConversationData?> selectedConversationViewModelRef;
final selectedConversationViewModel = StateProvider<ConversationData?>((ref) {
  selectedConversationViewModelRef = ref;
  return null;
});

final isConversationsInitializedViewModel = StateProvider<bool>((ref) => false);