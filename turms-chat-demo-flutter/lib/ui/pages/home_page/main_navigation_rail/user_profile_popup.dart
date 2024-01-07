import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/conversation/models/private_conversation.dart';
import '../../../../domain/user/models/user.dart';
import '../../../../domain/user/models/user_contact.dart';
import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../components/t_avatar/t_avatar.dart';
import '../../../components/t_button/t_text_button.dart';
import '../../../components/t_popup/t_popup.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../themes/theme_config.dart';
import '../chat_page/view_models/conversations_view_model.dart';
import '../chat_page/view_models/selected_conversation_view_model.dart';
import '../home_page_tab.dart';
import '../shared_view_models/home_page_tab_view_model.dart';
import 'user_profile/user_profile.dart';

class UserProfilePopup extends ConsumerStatefulWidget {
  const UserProfilePopup({
    super.key,
  });

  @override
  ConsumerState<UserProfilePopup> createState() => _UserProfilePopupState();
}

class _UserProfilePopupState extends ConsumerState<UserProfilePopup> {
  late TPopupController popupController;

  @override
  void initState() {
    super.initState();
    popupController = TPopupController();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = ref.watch(loggedInUserViewModel)!;
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return TPopup(
      controller: popupController,
      targetAnchor: Alignment.bottomRight,
      offset: const Offset(-5, -5),
      target: TAvatar(name: loggedInUser.name, image: loggedInUser.image),
      follower: Material(
        child: SizedBox(
          height: 200,
          width: 280,
          child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: ThemeConfig.borderRadius4,
                  boxShadow: ThemeConfig.boxShadow),
              padding: const EdgeInsets.all(10),
              width: 50,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserProfile(user: loggedInUser),
                    TTextButton(
                      text: appLocalizations.messages,
                      onTap: () => startConversation(loggedInUser),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void startConversation(User loggedInUser) {
    popupController.hidePopover();
    ref.read(homePageTabViewModel.notifier).state = HomePageTab.chat;
    final selectedConversation = ref.read(selectedConversationViewModel);
    if (selectedConversation != null &&
        selectedConversation is PrivateConversation &&
        selectedConversation.contact.userId == loggedInUser.userId) {
      return;
    }
    final conversations = ref.read(conversationsViewModel);
    for (final conversation in conversations) {
      if (conversation is PrivateConversation &&
          conversation.contact.userId == loggedInUser.userId) {
        ref.read(selectedConversationViewModel.notifier).state = conversation;
        return;
      }
    }
    final newConversation = PrivateConversation(
        // TODO: get history messages
        messages: [],
        contact: UserContact.fromUser(loggedInUser, Int64(-1)));
    conversations.add(newConversation);
    ref.read(selectedConversationViewModel.notifier).state = newConversation;
    setState(() {});
  }
}