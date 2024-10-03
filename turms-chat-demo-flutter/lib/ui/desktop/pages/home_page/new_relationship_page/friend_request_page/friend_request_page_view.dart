import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/user/models/index.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../themes/theme_config.dart';
import '../../../../components/t_avatar/t_avatar.dart';
import '../../../../components/t_button/t_text_button.dart';
import '../../../../components/t_text_field/t_text_field.dart';
import '../../../../components/t_title_bar/t_title_bar.dart';
import 'friend_request_page_controller.dart';

class FriendRequestPageView extends StatelessWidget {
  const FriendRequestPageView(this.friendRequestPageController);

  final FriendRequestPageController friendRequestPageController;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = friendRequestPageController.appLocalizations;
    final contact = friendRequestPageController.widget.contact;
    return SizedBox(
      width: 400,
      height: 300,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                Text(appLocalizations.addContact),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TAvatar(name: contact.name, image: contact.image),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (contact.intro.isNotBlank)
                            Text(
                              contact.intro,
                              style: ThemeConfig.textStyleSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.message),
                ),
                const SizedBox(height: 8),
                Expanded(
                    child: TTextField(
                  autofocus: true,
                  expands: true,
                  textEditingController:
                      friendRequestPageController.messageEditingController,
                )),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 16,
                  children: [
                    TTextButton.outlined(
                      text: appLocalizations.cancel,
                      containerPadding: ThemeConfig.paddingV4H8,
                      containerWidth: 64,
                      onTap: friendRequestPageController.close,
                    ),
                    TTextButton(
                      isLoading: friendRequestPageController.isSending,
                      text: appLocalizations.send,
                      containerPadding: ThemeConfig.paddingV4H8,
                      containerWidth: 64,
                      onTap: () {
                        friendRequestPageController.sendFriendRequest(
                            (contact is UserContact)
                                ? contact.userId
                                : (contact as GroupContact).groupId,
                            friendRequestPageController
                                .messageEditingController.text);
                      },
                    )
                  ],
                )
              ]),
            ),
          ),
          // const Expanded(
          //   child: SettingsPane(),
          // ),
          const TTitleBar(
            backgroundColor: ThemeConfig.homePageBackgroundColor,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }
}