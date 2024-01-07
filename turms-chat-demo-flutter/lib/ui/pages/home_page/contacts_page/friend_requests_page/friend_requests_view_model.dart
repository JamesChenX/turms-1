import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/friend_request.dart';
import '../../../../../fixtures/friend_requests.dart';

final friendRequestsViewModel =
    StateProvider<List<FriendRequest>>((ref) => friendRequests);