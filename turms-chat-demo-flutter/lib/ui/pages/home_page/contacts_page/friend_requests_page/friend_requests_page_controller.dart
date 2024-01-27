import 'package:fixnum/src/int64.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/friend_request.dart';
import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import 'friend_requests_page.dart';
import 'friend_requests_page_view.dart';
import 'friend_requests_view_model.dart';

class FriendRequestsPageController extends ConsumerState<FriendRequestsPage> {
  late AppLocalizations appLocalizations;
  late  List<FriendRequest> friendRequests;
  late Map<DateTime, List<FriendRequest>> creationDateToFriendRequests;

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    friendRequests = ref.watch(friendRequestsViewModel);
    creationDateToFriendRequests = friendRequests.groupBy((request) {
      final createdAt = request.creationDate;
      return DateTime(createdAt.year, createdAt.month, createdAt.day);
    });
    return FriendRequestsPageView(this);
  }

  Future<void> acceptFriendRequest(FriendRequest request) async {
    // TODO: use real API
    await Future.delayed(Duration(seconds: 3));
    friendRequests.replace(request, request.copyWith(status: FriendRequestStatus.accepted));
    friendRequestsViewModelRef.notifyListeners();
  }
}