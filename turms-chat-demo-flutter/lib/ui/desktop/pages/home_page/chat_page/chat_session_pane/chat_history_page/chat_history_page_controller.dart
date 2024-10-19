import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../l10n/view_models/app_localizations_view_model.dart';
import 'chat_history_page.dart';
import 'chat_history_page_view.dart';

class ChatHistoryPageController extends ConsumerState<ChatHistoryPage>
    with SingleTickerProviderStateMixin {
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return ChatHistoryPageView(this);
  }

  void search(String text) {}
}
