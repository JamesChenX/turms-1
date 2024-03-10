import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/contact.dart';
import '../../../../../domain/user/models/index.dart';
import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../components/index.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';
import '../friend_requests_page/friend_requests_page.dart';
import 'contact_profile_controller.dart';

class ContactProfilePageView extends ConsumerWidget {
  const ContactProfilePageView(this.contactProfilePageController, {super.key});

  final ContactProfilePageController contactProfilePageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContact = contactProfilePageController.selectedContact;
    if (selectedContact == null) {
      return const TWindowControlZone(
          toggleMaximizeOnDoubleTap: true, child: TEmpty());
    }
    if (selectedContact is SystemContact &&
        selectedContact.type == SystemContactType.friendRequest) {
      return const FriendRequestsPage();
    }
    final intro = selectedContact.intro;
    return Stack(
      children: [
        _buildProfile(selectedContact, intro, ref),
        const TWindowControlZone(
          toggleMaximizeOnDoubleTap: true,
          child: SizedBox(
            height: ThemeConfig.homePageHeaderHeight,
            width: double.infinity,
          ),
        ),
      ],
    );
  }

  Padding _buildProfile(Contact selectedContact, String intro, WidgetRef ref) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 120),
        child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 300,
            child: Column(
              children: [
                Row(
                  children: [
                    TAvatar(
                      name: selectedContact.name,
                      image: selectedContact.image,
                      icon: selectedContact.icon,
                      size: TAvatarSize.large,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedContact.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                            ),
                            // TODO: Add more details
                            if (selectedContact is UserContact)
                              Text(
                                  '${contactProfilePageController.appLocalizations.userId}: ${selectedContact.userId}')
                            else if (selectedContact is GroupContact)
                              Text(
                                  '${contactProfilePageController.appLocalizations.groupId}: ${selectedContact.groupId}')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                if (intro.isNotBlank) ...[
                  const SizedBox(
                    height: 16,
                  ),
                  Text(selectedContact.intro)
                ],
                const SizedBox(
                  height: 32,
                ),
                _buildActions(ref)
              ],
            ),
          ),
        ),
      );

  Widget _buildActions(WidgetRef ref) => TTextButton(
        text: ref.watch(appLocalizationsViewModel).messages,
        onTap: contactProfilePageController.startConversation,
      );
}
