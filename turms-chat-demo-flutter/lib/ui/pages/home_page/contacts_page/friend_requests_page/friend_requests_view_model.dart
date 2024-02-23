import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/friend_request.dart';
import '../../../../../fixtures/friend_requests.dart';

late StateProviderRef<List<FriendRequest>> friendRequestsViewModelRef;
final friendRequestsViewModel = StateProvider<List<FriendRequest>>((ref) {
  friendRequestsViewModelRef = ref;
  return friendRequests;
});
