import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../fixtures/conversations.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_view_model.dart';
import '../../shared_components/conversation.dart';
import '../../shared_states/shared_states.dart';
import 'sub_navigation_rail.dart';
import 'sub_navigation_rail_view.dart';

class SubNavigationRailController extends ConsumerState<SubNavigationRail> {
  late AppLocalizations appLocalizations;
  late List<ConversationData> conversations;
  ConversationData? selectedConversation;
  bool isConversationsInitialized = false;
  bool isConversationsLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (conversations.isNotEmpty) {
        return;
      }
      conversations = ref.watch(conversationsViewModel);
      if (isConversationsLoading) {
        return;
      }
      final isConversationsInitialized =
          ref.read(isConversationsInitializedViewModel);
      if (!isConversationsInitialized) {
        loadConversations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.read(appLocalizationsViewModel);
    conversations = ref.watch(conversationsViewModel);
    selectedConversation = ref.watch(selectedConversationViewModel);
    return SubNavigationRailView(this);
  }

  void selectConversation(ConversationData conversation) =>
      ref.read(selectedConversationViewModel.notifier).state = conversation;

  Future<void> loadConversations() async {
    setState(() {
      isConversationsLoading = true;
    });
    // TODO: use real API
    await Future.delayed(const Duration(seconds: 3));
    ref.read(conversationsViewModel.notifier).state = fixtureConversations;
    ref.read(isConversationsInitializedViewModel.notifier).state = true;
    setState(() {
      isConversationsInitialized = true;
      isConversationsLoading = false;
    });
  }
}