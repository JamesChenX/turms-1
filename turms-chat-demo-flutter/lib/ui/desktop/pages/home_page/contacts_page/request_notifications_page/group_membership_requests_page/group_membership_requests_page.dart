import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../domain/common/models/request_status.dart';
import '../../../../../../../domain/group/models/group_membership_request.dart';
import '../../../../../../../domain/group/services/GroupService.dart';
import '../../../../../../../domain/user/models/contact.dart';
import '../../../chat_page/view_models/selected_conversation_view_model.dart';
import '../new_relationship_requests_page/new_relationship_requests_page.dart';
import 'group_membership_requests_view_model.dart';

class GroupMembershipRequestsPage extends ConsumerStatefulWidget {
  const GroupMembershipRequestsPage({super.key});

  @override
  ConsumerState<GroupMembershipRequestsPage> createState() =>
      _GroupMembershipRequestsPageState();
}

class _GroupMembershipRequestsPageState
    extends ConsumerState<GroupMembershipRequestsPage> {
  @override
  Widget build(BuildContext context) {
    final groupMembershipRequest = ref.watch(groupMembershipRequestsViewModel);
    return NewRelationshipRequestsPage(
      requests: groupMembershipRequest,
      onRequestStatusChange: (request, requestStatus) async {
        switch (requestStatus) {
          case RequestStatus.accepted:
            return approveGroupMembershipRequest(
                request as GroupMembershipRequest);
          default:
            return;
        }
      },
      onStartConversationTap: (value) {
        startConversation(value as GroupMembershipRequest);
      },
    );
  }

  Future<void> approveGroupMembershipRequest(
      GroupMembershipRequest request) async {
    final notifier = ref.read(groupMembershipRequestsViewModel.notifier);
    await groupService.approveGroupMembershipRequest(request.id);
    notifier.replace(request, request.copyWith(status: RequestStatus.accepted));
  }

  void startConversation(GroupMembershipRequest request) {
    final group = request.group;
    ref.read(selectedConversationViewModel.notifier).select(GroupContact(
        groupId: group.id,
        name: group.name,
        // TODO
        members: []));
  }
}
