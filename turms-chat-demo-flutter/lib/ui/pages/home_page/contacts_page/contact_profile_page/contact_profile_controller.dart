import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../chat_page/view_models/selected_conversation_view_model.dart';
import '../view_models/selected_contact_view_model.dart';
import 'contact_profile_page.dart';
import 'contact_profile_view.dart';

class ContactProfilePageController extends ConsumerState<ContactProfilePage> {
  late AppLocalizations appLocalizations;
  late Contact? selectedContact;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    selectedContact = ref.watch(selectedContactViewModel);
    return ContactProfilePageView(this);
  }

  startConversation() {
    if (selectedContact == null) {
      return;
    }
    ref.read(selectedConversationViewModel.notifier).select(selectedContact!);
  }
}
