import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/user/models/friend_request.dart';
import '../../../../../components/t_divider/t_horizontal_divider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/date_format_view_models.dart';
import 'friend_request_tile.dart';
import 'friend_requests_page_controller.dart';

class FriendRequestsPageView extends ConsumerWidget {
  const FriendRequestsPageView(this.friendRequestsPageController, {super.key});

  final FriendRequestsPageController friendRequestsPageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      _buildFriendRequestGroups(ref);

  Widget _buildFriendRequestGroups(WidgetRef ref) {
    final now = DateTime.now();
    final appLocalizations = friendRequestsPageController.appLocalizations;
    return ListView(
      // Prevent the scrollbar from overlapping children.
      padding: const EdgeInsets.only(right: 24),
      children: friendRequestsPageController
          .creationDateToFriendRequests.entries.indexed
          .expand((item) {
        final (entryIndex, creationDateAndFriendRequests) = item;
        final creationDate = creationDateAndFriendRequests.key;
        final friendRequests = creationDateAndFriendRequests.value;
        return _buildFriendRequestGroupInSameDay(entryIndex, creationDate, now,
            appLocalizations, ref, friendRequests);
      }).toList(),
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
