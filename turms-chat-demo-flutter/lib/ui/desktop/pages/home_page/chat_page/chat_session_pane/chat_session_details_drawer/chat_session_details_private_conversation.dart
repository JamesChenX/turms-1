part of 'chat_session_details_drawer.dart';

class ChatSessionDetailsPrivateConversation extends ConsumerStatefulWidget {
  const ChatSessionDetailsPrivateConversation(
      {super.key, required this.contact});

  final UserContact contact;

  @override
  ConsumerState<ChatSessionDetailsPrivateConversation> createState() =>
      _ChatSessionDetailsPrivateConversationState();
}

class _ChatSessionDetailsPrivateConversationState
    extends ConsumerState<ChatSessionDetailsPrivateConversation> {
  // TODO: load from server + save to server
  bool _muteNotifications = false;
  bool _stickOnTop = false;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final loggedInUser = ref.watch(loggedInUserViewModel)!;
    const divider = THorizontalDivider();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.muteNotifications),
            TSwitch(
              value: _muteNotifications,
              onChanged: (value) {
                _muteNotifications = value;
                setState(() {});
              },
            ),
          ],
        ),
        Sizes.sizedBoxH4,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appLocalizations.stickOnTop),
            TSwitch(
              value: _stickOnTop,
              onChanged: (value) {
                _stickOnTop = value;
                setState(() {});
              },
            ),
          ],
        ),
        Sizes.sizedBoxH4,
        divider,
        Sizes.sizedBoxH8,
        _buildAddParticipantItem(theme, appLocalizations.createGroup),
        _participantItemSpacing,
        _buildParticipantItem(loggedInUser),
        _participantItemSpacing,
        _buildParticipantItem(widget.contact),
        const Spacer(),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: Sizes.paddingV8,
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.clearChatHistory,
            textStyle: context.appThemeExtension.dangerTextStyle,
          ),
        )
      ],
    );
  }

  Row _buildParticipantItem(User user) => Row(
        spacing: _participantItemElementSpacing,
        children: [
          UserProfilePopup(
              user: user, popupAnchor: Alignment.topRight, size: _avatarSize),
          Expanded(
              child: Text(
            user.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          )),
        ],
      );
}
