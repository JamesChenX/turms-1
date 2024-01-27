import 'package:fixnum/fixnum.dart';

import '../domain/user/models/friend_request.dart';

final _now = DateTime.now();

final friendRequests = [
  FriendRequest(
      id: Int64(1),
      status:  FriendRequestStatus.pending,
      senderId: Int64(1),
      senderName: 'fake name',
      creationDate: _now,
      message: 'hello'),
  FriendRequest(
      id: Int64(2),
      status:  FriendRequestStatus.pending,
      senderId: Int64(2),
      senderName: 'fake name',
      creationDate: _now,
      message: 'hi'),
  FriendRequest(
      id: Int64(3),
      status:  FriendRequestStatus.accepted,
      senderId: Int64(3),
      senderName: 'fake name',
      creationDate: _now,
      message: 'a very long message. ' * 50),
  FriendRequest(
      id: Int64(11),
      status:  FriendRequestStatus.pending,
      senderId: Int64(11),
      senderName: 'fake name',
      creationDate: _now.subtract(const Duration(days: 15)),
      message: 'hello'),
  FriendRequest(
      id: Int64(12),
      status:  FriendRequestStatus.pending,
      senderId: Int64(12),
      senderName: 'fake name',
      creationDate: _now.subtract(const Duration(days: 15)),
      message: 'hi'),
  FriendRequest(
      id: Int64(13),
      status:  FriendRequestStatus.accepted,
      senderId: Int64(13),
      senderName: 'fake name',
      creationDate: _now.subtract(const Duration(days: 15)),
      message: 'a very long message. ' * 50),
  FriendRequest(
      id: Int64(21),
      status:  FriendRequestStatus.pending,
      senderId: Int64(21),
      senderName: 'fake name',
      creationDate: _now.subtract(const Duration(days: 365)),
      message: 'hello'),
  FriendRequest(
      id: Int64(22),
      status:  FriendRequestStatus.pending,
      senderId: Int64(22),
      senderName: 'fake name',
      creationDate: _now.subtract(const Duration(days: 365)),
      message: 'hi'),
  FriendRequest(
      id: Int64(23),
      status:  FriendRequestStatus.accepted,
      senderId: Int64(23),
      senderName: 'fake name',
      creationDate: _now.subtract(const Duration(days: 365)),
      message: 'a very long message. ' * 50),
];