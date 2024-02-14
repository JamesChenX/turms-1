/*
 * Copyright (C) 2019 The Turms Project
 * https://github.com/turms-im/turms
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/conversation/models/private_conversation.dart';
import '../../../../domain/user/models/user.dart';
import '../../../../domain/user/models/user_contact.dart';
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
    required this.user,
    this.position = UserProfilePopupPosition.bottomRight,
  });

  final User user;
  final UserProfilePopupPosition position;

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
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final user = widget.user;
    return TPopup(
      controller: popupController,
      targetAnchor: widget.position == UserProfilePopupPosition.bottomRight
          ? Alignment.bottomRight
          : Alignment.bottomLeft,
      followerAnchor: widget.position == UserProfilePopupPosition.bottomRight
          ? Alignment.topLeft
          : Alignment.topRight,
      offset: widget.position == UserProfilePopupPosition.bottomRight
          ? const Offset(-5, -5)
          : const Offset(5, -5),
      target: TAvatar(
        name: user.name,
        image: user.image,
      ),
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
                    UserProfile(user: user),
                    TTextButton(
                      text: appLocalizations.messages,
                      onTap: () => startConversation(user),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void startConversation(User user) {
    // 1. Hide the popup
    popupController.hidePopover?.call();
    // 2. Switch to the chat page
    ref.read(homePageTabViewModel.notifier).state = HomePageTab.chat;
    // 3. Check if the conversation already selected
    final selectedConversation = ref.read(selectedConversationViewModel);
    if (selectedConversation != null &&
        selectedConversation is PrivateConversation &&
        selectedConversation.contact.userId == user.userId) {
      return;
    }
    // 4. Check if the conversation already exists
    final conversations = ref.read(conversationsViewModel);
    for (final conversation in conversations) {
      if (conversation is PrivateConversation &&
          conversation.contact.userId == user.userId) {
        ref.read(selectedConversationViewModel.notifier).state = conversation;
        return;
      }
    }
    // 5. Create a new conversation
    final newConversation = PrivateConversation(
        // TODO: get history messages
        messages: [],
        contact: UserContact.fromUser(user, Int64(-1)));
    conversations.add(newConversation);
    ref.read(selectedConversationViewModel.notifier).state = newConversation;
    // Scrollable.ensureVisible(context);
    setState(() {});
  }
}

enum UserProfilePopupPosition {
  bottomLeft,
  bottomRight,
}