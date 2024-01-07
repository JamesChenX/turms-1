import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/t_avatar/t_avatar.dart';
import '../../../../components/t_button/t_text_button.dart';
import '../../../../components/t_horizontal_divider.dart';
import '../../../../components/t_window_control_zone.dart';
import '../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../themes/theme_config.dart';
import 'friend_requests_page_controller.dart';

class FriendRequestsPageView extends ConsumerWidget {
  const FriendRequestsPageView(this.friendRequestsPageController, {super.key});

  final FriendRequestsPageController friendRequestsPageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
        children: [
          _buildProfile(ref),
          const TWindowControlZone(
            toggleMaximizeOnDoubleTap: true,
            child: SizedBox(
              height: ThemeConfig.homePageHeaderHeight,
              width: double.infinity,
            ),
          ),
        ],
      );

  Padding _buildProfile(WidgetRef ref) {
    final now = DateTime.now();
    final appLocalizations = friendRequestsPageController.appLocalizations;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      child: Align(
        alignment: Alignment.topCenter,
        // TODO: load lazily
        child: ListView(
          children: friendRequestsPageController
              .creationDateToFriendRequests.entries.indexed
              .expand((item) {
            final (entryIndex, creationDateAndFriendRequests) = item;
            final creationDate = creationDateAndFriendRequests.key;
            Widget creationDateWidget;
            if (DateUtils.isSameDay(creationDate, now)) {
              creationDateWidget = Text(appLocalizations.today);
            } else if (creationDate.year == now.year) {
              creationDateWidget =
                  Text(ref.watch(dateFormatViewModel_Md).format(creationDate));
            } else {
              creationDateWidget =
                  Text(ref.watch(dateFormatViewModel_yMd).format(creationDate));
            }
            final friendRequests = creationDateAndFriendRequests.value;
            // TODO: use real data
            const senderName = 'test';
            return [
              if (entryIndex > 0) const SizedBox(height: 16),
              creationDateWidget,
              const SizedBox(height: 8),
              THorizontalDivider(),
              const SizedBox(height: 12),
              ...friendRequests.indexed.expand((item) {
                final (requestIndex, friendRequest) = item;
                return [
                  if (requestIndex > 0) const SizedBox(height: 16),
                  Row(
                    children: [
                      TAvatar(name: senderName),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              senderName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'my message. ' * ((requestIndex + 1) * 3),
                              style: ThemeConfig.textStyleSecondary,
                              strutStyle: StrutStyle.fromTextStyle(
                                  ThemeConfig.textStyleSecondary,
                                  forceStrutHeight: true),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              // style: TextStyle(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      TTextButton(
                        padding: ThemeConfig.paddingV4H8,
                        text: appLocalizations.accept,
                        onTap: () {},
                      ),
                      // Prevent the scrollbar from overlapping the button
                      const SizedBox(width: 24),
                    ],
                  )
                ];
              })
            ];
          }).toList(),
        ),
      ),
    );
  }
}