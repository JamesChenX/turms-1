import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/user/models/index.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../themes/index.dart';

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
    final appThemeExtension = friendRequestPageController.appThemeExtension;
    final contact = friendRequestPageController.widget.contact;
    return SizedBox(
      width: Sizes.friendRequestDialogWidth,
      height: Sizes.friendRequestDialogHeight,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: Sizes.paddingV16H16,
              child: Column(children: [
                Text(appLocalizations.addContact),
                Sizes.sizedBoxH16,
                Row(
                  spacing: 8,
                  children: [
                    TAvatar(name: contact.name, image: contact.image),
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
                              style: appThemeExtension.descriptionTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ],
                      ),
                    )
                  ],
                ),
                Sizes.sizedBoxH8,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(appLocalizations.message),
                ),
                Sizes.sizedBoxH8,
                Expanded(
                    child: TTextField(
                  autofocus: true,
                  expands: true,
                  textEditingController:
                      friendRequestPageController.messageEditingController,
                )),
                Sizes.sizedBoxH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 16,
                  children: [
                    TTextButton.outlined(
                      theme: friendRequestPageController.theme,
                      text: appLocalizations.cancel,
                      containerPadding: Sizes.paddingV4H8,
                      containerWidth: 64,
                      onTap: friendRequestPageController.close,
                    ),
                    TTextButton(
                      isLoading: friendRequestPageController.isSending,
                      text: appLocalizations.send,
                      containerPadding: Sizes.paddingV4H8,
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
          TTitleBar(
            backgroundColor: appThemeExtension.homePageBackgroundColor,
            displayCloseOnly: true,
            popOnCloseTapped: true,
          )
        ],
      ),
    );
  }
}
