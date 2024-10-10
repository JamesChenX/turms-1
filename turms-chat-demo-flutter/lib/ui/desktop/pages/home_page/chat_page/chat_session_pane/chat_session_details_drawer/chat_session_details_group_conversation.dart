import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../../../../domain/group/services/group_service.dart';
import '../../../../../../../domain/user/models/contact.dart';
import '../../../../../../../domain/user/models/group_member.dart';
import '../../../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../../../infra/ui/text_utils.dart';
import '../../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../../themes/index.dart';
import '../../../../../components/index.dart';
import '../../../../../components/t_switch/t_switch.dart';
import '../../../shared_components/user_profile_popup.dart';

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
    final theme = context.theme;
    final appThemeExtension = theme.appThemeExtension;
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    final loggedInUser = ref.watch(loggedInUserViewModel)!;
    const divider = THorizontalDivider();
    final intro = widget.contact.intro;

    final members = widget.contact.members;
    // TODO: final isCurrentUserAdmin = members.any((m) => m.userId == loggedInUser.userId);
    const isCurrentUserAdmin = true;

    return Column(
      children: [
        isCurrentUserAdmin
            ? _ChatSessionDetailsGroupConversationName(
                groupName: widget.contact.name,
              )
            : SelectionArea(
                child: Text(
                widget.contact.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
        if (intro.isNotBlank) ...[
          Sizes.sizedBoxH8,
          SizedBox(
            child: SelectionArea(
              child: Text(
                intro,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: appThemeExtension.descriptionTextStyle,
              ),
            ),
          )
        ],
        Sizes.sizedBoxH8,
        divider,
        Sizes.sizedBoxH8,
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
        TTextButton.outlined(
          theme: theme,
          containerPadding: Sizes.paddingV4H8,
          text: appLocalizations.addNewMember,
          prefix: const Icon(
            Symbols.person_add_rounded,
            size: 20,
          ),
        ),
        Sizes.sizedBoxH8,
        Expanded(
            child: _ChatSessionDetailsGroupConversationMemberList(members)),
        Sizes.sizedBoxH8,
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: Sizes.paddingV8,
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.clearChatHistory,
            textStyle: appThemeExtension.dangerTextStyle,
          ),
        ),
        divider,
        SizedBox(
          width: double.infinity,
          child: TTextButton(
            containerPadding: Sizes.paddingV8,
            containerColor: Colors.transparent,
            containerColorHovered: Colors.transparent,
            text: appLocalizations.leaveGroup,
            textStyle: appThemeExtension.dangerTextStyle,
          ),
        )
      ],
    );
  }
}

class _ChatSessionDetailsGroupConversationMemberList
    extends ConsumerStatefulWidget {
  const _ChatSessionDetailsGroupConversationMemberList(this.members);

  final List<GroupMember> members;

  @override
  ConsumerState createState() =>
      _ChatSessionDetailsGroupConversationMemberListState();
}

class _ChatSessionDetailsGroupConversationMemberListState
    extends ConsumerState<_ChatSessionDetailsGroupConversationMemberList> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final appThemeExtension = context.appThemeExtension;
    final appLocalizations = ref.watch(appLocalizationsViewModel);

    final isSearchMode = _searchText.isNotBlank;
    final matchedMembers = widget.members.expand<_StyledMember>((member) {
      final nameTextSpans = TextUtils.highlightSearchText(
          text: member.name,
          searchText: _searchText,
          searchTextStyle: appThemeExtension.highlightTextStyle);
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
            child: isSearchMode && itemCount == 0
                ? Center(
                    child: Text(
                    appLocalizations.noMatchingGroupMembersFound,
                    style: appThemeExtension.descriptionTextStyle,
                  ))
                : ListView.separated(
                    // Used to not overlay on the scrollbar
                    padding: const EdgeInsets.only(right: 12),
                    itemCount: itemCount,
                    findChildIndexCallback: (key) =>
                        matchedMemberIdToIndex[(key as ValueKey<Int64>).value],
                    itemBuilder: (context, index) {
                      final item = matchedMembers[index];
                      final member = item.member;
                      return Row(
                        spacing: 8,
                        children: [
                          UserProfilePopup(
                              user: member,
                              popupAnchor: Alignment.topRight,
                              size: TAvatarSize.small),
                          Expanded(
                              child: Text.rich(
                            TextSpan(children: item.nameTextSpans),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          )),
                          if (member.isAdmin)
                            Icon(
                              Symbols.supervisor_account_rounded,
                              size: 22,
                              color: Colors.yellow[800],
                            )
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      height: 4,
                    ),
                  ))
      ],
    );
  }
}

class _ChatSessionDetailsGroupConversationName extends StatefulWidget {
  const _ChatSessionDetailsGroupConversationName({required this.groupName});

  final String groupName;

  @override
  State<_ChatSessionDetailsGroupConversationName> createState() =>
      _ChatSessionDetailsGroupConversationNameState();
}

class _ChatSessionDetailsGroupConversationNameState
    extends State<_ChatSessionDetailsGroupConversationName> {
  TextEditingController? _textEditingController;
  bool _editingGroupName = false;
  bool _isHovered = false;

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _editingGroupName
      ? TTextField(
          textEditingController: _textEditingController!,
          autofocus: true,
          onSubmitted: (value) async {
            if (value.isBlank || value == widget.groupName) {
              _editingGroupName = false;
              setState(() {});
              return;
            }
            unawaited(groupService.updateGroupName(value));
            _editingGroupName = false;
            setState(() {});
          },
        )
      : MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Row(
            children: [
              Flexible(
                  child: SelectionArea(
                      child: Text(
                widget.groupName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))),
              if (_isHovered)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final name = widget.groupName;
                      _textEditingController ??=
                          TextEditingController(text: name)
                            ..selection = TextSelection(
                                baseOffset: 0, extentOffset: name.length);
                      _editingGroupName = true;
                      setState(() {});
                    },
                    child: const Icon(
                      Symbols.edit_rounded,
                      size: 18,
                    ),
                  ),
                )
            ],
          ),
        );
}

class _StyledMember {
  const _StyledMember({required this.member, required this.nameTextSpans});

  final GroupMember member;
  final List<TextSpan> nameTextSpans;
}
