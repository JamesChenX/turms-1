import 'package:fixnum/fixnum.dart';

import '../domain/user/models/friend_request.dart';

final _now = DateTime.now();

final friendRequests = [
  FriendRequest(
      id: Int64(1), senderId: Int64(1), creationDate: _now, message: 'hello'),
  FriendRequest(
      id: Int64(2), senderId: Int64(2), creationDate: _now, message: 'hi'),
  FriendRequest(
      id: Int64(3),
      senderId: Int64(3),
      creationDate: _now,
      message: 'a very long message. ' * 50),
  FriendRequest(
      id: Int64(11),
      senderId: Int64(11),
      creationDate: _now.subtract(const Duration(days: 15)),
      message: 'hello'),
  FriendRequest(
      id: Int64(12),
      senderId: Int64(12),
      creationDate: _now.subtract(const Duration(days: 15)),
      message: 'hi'),
  FriendRequest(
      id: Int64(13),
      senderId: Int64(13),
      creationDate: _now.subtract(const Duration(days: 15)),
      message: 'a very long message. ' * 50),
  FriendRequest(
      id: Int64(21),
      senderId: Int64(21),
      creationDate: _now.subtract(const Duration(days: 365)),
      message: 'hello'),
  FriendRequest(
      id: Int64(22),
      senderId: Int64(22),
      creationDate: _now.subtract(const Duration(days: 365)),
      message: 'hi'),
  FriendRequest(
      id: Int64(23),
      senderId: Int64(23),
      creationDate: _now.subtract(const Duration(days: 365)),
      message: 'a very long message. ' * 50),
];