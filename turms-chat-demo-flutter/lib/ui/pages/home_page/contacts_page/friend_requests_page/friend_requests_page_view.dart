import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turms_chat_demo/domain/user/models/friend_request.dart';
import 'package:turms_chat_demo/ui/l10n/app_localizations.dart';

import '../../../../components/t_horizontal_divider.dart';
import '../../../../components/t_window_control_zone.dart';
import '../../../../l10n/view_models/date_format_view_models.dart';
import '../../../../themes/theme_config.dart';
import 'friend_request_tile.dart';
import 'friend_requests_page_controller.dart';

class FriendRequestsPageView extends ConsumerWidget {
  const FriendRequestsPageView(this.friendRequestsPageController, {super.key});

  final FriendRequestsPageController friendRequestsPageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Stack(
        children: [
          _buildFriendRequestGroups(ref),
          TWindowControlZone(
            toggleMaximizeOnDoubleTap: true,
            child: SizedBox(
              height: ThemeConfig.titleBarSize.height,
              width: double.infinity,
            ),
          ),
        ],
      );

  Padding _buildFriendRequestGroups(WidgetRef ref) {
    final now = DateTime.now();
    final appLocalizations = friendRequestsPageController.appLocalizations;
    return Padding(
      padding: EdgeInsets.only(
          top: ThemeConfig.titleBarSize.height + 8,
          bottom: 16,
          left: 16,
          // Used to avoid the scrollbar aligning to the right exactly.
          right: 16),
      child: Align(
        alignment: Alignment.topCenter,
        // TODO: load lazily
        child: ListView(
          // Prevent the scrollbar from overlapping children.
          padding: const EdgeInsets.only(right: 24),
          children: friendRequestsPageController
              .creationDateToFriendRequests.entries.indexed
              .expand((item) {
            final (entryIndex, creationDateAndFriendRequests) = item;
            final creationDate = creationDateAndFriendRequests.key;
            final friendRequests = creationDateAndFriendRequests.value;
            return _buildFriendRequestGroupInSameDay(entryIndex, creationDate,
                now, appLocalizations, ref, friendRequests);
          }).toList(),
        ),
      ),
    );
  }

  List<Widget> _buildFriendRequestGroupInSameDay(
          int entryIndex,
          DateTime creationDate,
          DateTime now,
          AppLocalizations appLocalizations,
          WidgetRef ref,
          List<FriendRequest> friendRequests) =>
      [
        if (entryIndex > 0) const SizedBox(height: 16),
        if (DateUtils.isSameDay(creationDate, now))
          Text(appLocalizations.today)
        else if (creationDate.year == now.year)
          Text(ref.watch(dateFormatViewModel_Md).format(creationDate))
        else
          Text(ref.watch(dateFormatViewModel_yMd).format(creationDate)),
        const SizedBox(height: 8),
        const THorizontalDivider(),
        const SizedBox(height: 12),
        ...friendRequests.indexed.expand((item) {
          final (requestIndex, friendRequest) = item;
          return [
            if (requestIndex > 0) const SizedBox(height: 16),
            FriendRequestTile(
              key: Key(friendRequest.id.toString()),
              friendRequest: friendRequest,
              onAccept: () async =>
                  friendRequestsPageController.acceptFriendRequest(
                friendRequest,
              ),
              onStartConversation: () =>
                  friendRequestsPageController.startConversation(friendRequest),
            )
          ];
        })
      ];
}
