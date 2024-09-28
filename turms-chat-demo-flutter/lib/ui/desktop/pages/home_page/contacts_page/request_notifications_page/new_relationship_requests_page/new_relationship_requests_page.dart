import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../domain/common/models/new_relationship_request.dart';
import '../../../../../../../domain/common/models/request_status.dart';
import 'new_relationship_requests_page_controller.dart';

class NewRelationshipRequestsPage extends ConsumerStatefulWidget {
  const NewRelationshipRequestsPage(
      {super.key,
      required this.requests,
      required this.onRequestStatusChange,
      required this.onStartConversationTap});

  final List<NewRelationshipRequest> requests;
  final Future<void> Function(
          NewRelationshipRequest request, RequestStatus requestStatus)
      onRequestStatusChange;
  final ValueChanged<NewRelationshipRequest> onStartConversationTap;

  @override
  ConsumerState createState() => NewRelationshipRequestsPageController();
}
