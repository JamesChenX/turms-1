import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/friend_request.dart';
import '../../../../components/t_avatar/t_avatar.dart';
import '../../../../components/t_button/t_text_button.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../themes/theme_config.dart';

class FriendRequestTile extends ConsumerStatefulWidget {
  const FriendRequestTile(
      {Key? key,
      required this.friendRequest,
      required this.onAccept,
      required this.onStartConversation})
      : super(key: key);

  final FriendRequest friendRequest;
  final Future<void> Function() onAccept;
  final void Function() onStartConversation;

  @override
  _FriendRequestTileState createState() => _FriendRequestTileState();
}

class _FriendRequestTileState extends ConsumerState<FriendRequestTile> {
  bool isHandling = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final friendRequest = widget.friendRequest;
    final senderName = friendRequest.senderName;
    final message = friendRequest.message;
    final status = friendRequest.status;
    return Row(
      children: [
        TAvatar(name: senderName),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: SelectionArea(
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
                  message,
                  style: ThemeConfig.textStyleSecondary,
                  strutStyle: StrutStyle.fromTextStyle(
                      ThemeConfig.textStyleSecondary,
                      forceStrutHeight: true),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // TODO: support decline
        status == FriendRequestStatus.accepted
            ? TTextButton.outlined(
                width: 80,
                padding: ThemeConfig.paddingV4H8,
                text: appLocalizations.messages,
                onTap: widget.onStartConversation,
              )
            : TTextButton(
                width: 80,
                padding: ThemeConfig.paddingV4H8,
                text: appLocalizations.accept,
                isLoading: isHandling,
                onTap: () async {
                  isHandling = true;
                  setState(() {});
                  await widget.onAccept();
                  isHandling = false;
                  setState(() {});
                },
              ),
        const SizedBox(width: 8),
      ],
    );
  }
}
