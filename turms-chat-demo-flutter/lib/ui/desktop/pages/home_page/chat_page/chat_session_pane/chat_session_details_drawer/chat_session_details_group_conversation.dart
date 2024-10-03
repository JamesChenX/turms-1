import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/user/models/contact.dart';
import '../../../../../../../domain/user/models/user.dart';
import '../../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../../../infra/ui/text_utils.dart';
import '../../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../../themes/theme_config.dart';
import '../../../../../components/index.dart';
import '../../../../../components/t_switch/t_switch.dart';

class ChatSessionDetailsGroupConversation extends ConsumerStatefulWidget {
  const ChatSessionDetailsGroupConversation({super.key, required this.contact});

  final GroupContact contact;

  @override
  ConsumerState<ChatSessionDetailsGroupConversation> createState() =>
      _ChatSessionDetailsGroupConversationState();
}

class _ChatSessionDetailsGroupConversationState
    extends ConsumerState<ChatSessionDetailsGroupConversation> {
  bool _muteNotifications = false;
  bool _stickOnTop = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    const divider = THorizontalDivider();
    final intro = widget.contact.intro;

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SelectionArea(
              child: Text(
            widget.contact.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
        ),
        if (intro.isNotBlank) ...[
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            child: SelectionArea(
              child: Text(
                intro,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: ThemeConfig.textStyleSecondary,
              ),
            ),
          )
        ],
        const SizedBox(
          height: 8,
        ),
        divider,
        const SizedBox(
          height: 8,
        ),
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
        const SizedBox(
          height: 4,
        ),
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
        const SizedBox(
          height: 4,
        ),
        divider,
        const SizedBox(
          height: 8,
        ),
        TTextButton.outlined(
          containerPadding: ThemeConfig.paddingV4H8,
          text: appLocalizations.addNewMember,
          prefix: const Icon(
            Symbols.person_add_rounded,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Expanded(
            child: _ChatSessionDetailsGroupConversationMemberList(
                widget.contact.members)),
        const SizedBox(
          height: 8,
        ),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: const EdgeInsets.symmetric(vertical: 8),
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.clearChatHistory,
            textStyle: ThemeConfig.textStyleWarning,
          ),
        ),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: const EdgeInsets.symmetric(vertical: 8),
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.leaveGroup,
            textStyle: ThemeConfig.textStyleWarning,
          ),
        )
      ],
    );
  }
}

class _ChatSessionDetailsGroupConversationMemberList
    extends ConsumerStatefulWidget {
  const _ChatSessionDetailsGroupConversationMemberList(this.members);

  final List<User> members;

  @override
  ConsumerState createState() =>
      __ChatSessionDetailsGroupConversationMemberListState();
}

class __ChatSessionDetailsGroupConversationMemberListState
    extends ConsumerState<_ChatSessionDetailsGroupConversationMemberList> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);

    final isSearchMode = _searchText.isNotBlank;
    final matchedMembers = widget.members.expand<_StyledMember>((member) {
      final nameTextSpans = TextUtils.highlightSearchText(
          text: member.name,
          searchText: _searchText,
          searchTextStyle: ThemeConfig.textStyleHighlight);
      if (nameTextSpans.length == 1 && isSearchMode) {
        return [];
      }
      return [_StyledMember(member: member, nameTextSpans: nameTextSpans)];
    }).toList();

    final itemCount = matchedMembers.length;
    final matchedMemberIdToIndex = {
      for (var i = 0; i < itemCount; i++) matchedMembers[i].member.userId: i
    };
    return Column(
      spacing: 8,
      children: [
        TSearchBar(
          hintText: appLocalizations.search,
          onChanged: (value) {
            _searchText = value;
            setState(() {});
          },
        ),
        Expanded(
            child: ListView.separated(
          // Used to not overlay on the scrollbar
          padding: const EdgeInsets.only(right: 12),
          itemCount: itemCount,
          findChildIndexCallback: (key) =>
              matchedMemberIdToIndex[(key as ValueKey<Int64>).value],
          itemBuilder: (context, index) {
            final member = matchedMembers[index];
            return Row(
              spacing: 8,
              children: [
                TAvatar(name: member.member.name, size: TAvatarSize.small),
                Expanded(
                    child: Text.rich(
                  TextSpan(children: member.nameTextSpans),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                )
                    //     Text(
                    //   member.name,
                    //   overflow: TextOverflow.ellipsis,
                    // )
                    ),
                const Icon(Symbols.supervisor_account_rounded)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 4,
          ),
        ))
      ],
    );
  }
}

class _StyledMember {
  _StyledMember({required this.member, required this.nameTextSpans});

  final User member;
  final List<TextSpan> nameTextSpans;
}
