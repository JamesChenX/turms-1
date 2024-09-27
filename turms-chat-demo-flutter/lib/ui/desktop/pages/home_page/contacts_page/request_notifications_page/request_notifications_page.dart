import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/index.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import 'friend_requests_page/friend_requests_page.dart';
import 'group_membership_requests_page/group_membership_requests_page.dart';

part 'request_notifications_page_controller.dart';

part 'request_notifications_page_view.dart';

class RequestNotificationsPage extends ConsumerStatefulWidget {
  const RequestNotificationsPage({super.key});

  @override
  ConsumerState<RequestNotificationsPage> createState() =>
      _RequestNotificationsPageController();
}