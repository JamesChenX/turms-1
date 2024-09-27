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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/index.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';
import '../../../components/t_avatar/t_avatar.dart';
import '../../../components/t_button/t_text_button.dart';
import '../../../components/t_image_viewer/t_image_viewer.dart';
import '../../../components/t_popup/t_popup.dart';
import '../chat_page/view_models/selected_conversation_view_model.dart';
import 'user_profile/user_profile.dart';
import 'user_profile_image_editor_dialog/user_profile_image_editor_dialog.dart';

class UserProfilePopup extends ConsumerStatefulWidget {
  const UserProfilePopup({
    super.key,
    required this.user,
    this.editable = false,
    this.faceLeft = false,
  });

  final User user;
  final bool editable;
  final bool faceLeft;

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
    final image = user.image;
    final avatar = TAvatar(
      name: user.name,
      image: image,
    );
    return TPopup(
      controller: popupController,
      targetAnchor: Alignment.center,
      followerAnchor: widget.faceLeft ? Alignment.topRight : Alignment.topLeft,
      target: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: image == null
            ? avatar
            : GestureDetector(
                onTap: () {
                  showImageViewerDialog(context, image);
                },
                child: avatar,
              ),
      ),
      follower: Material(
        borderRadius: ThemeConfig.borderRadius4,
        child: SizedBox(
          height: 160,
          width: 280,
          child: DecoratedBox(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: ThemeConfig.borderRadius4,
                boxShadow: ThemeConfig.boxShadow),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, top: 16, right: 16, bottom: 16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserProfile(
                      user: user,
                      onEditTap:
                          widget.editable ? _startEditUserProfileImage : null,
                    ),
                    TTextButton(
                      text: appLocalizations.messages,
                      onTap: () => _startConversation(user),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startConversation(User user) {
    popupController.hidePopover?.call();
    // TODO: Handle the case when the user is a stranger.
    ref
        .read(selectedConversationViewModel.notifier)
        .select(UserContact(userId: user.userId, name: user.name));
  }

  void _startEditUserProfileImage() {
    popupController.hidePopover?.call();
    showUserProfileImageEditorDialog(context, widget.user);
  }
}