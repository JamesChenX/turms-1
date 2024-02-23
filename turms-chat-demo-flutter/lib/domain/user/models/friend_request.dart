import 'package:fixnum/fixnum.dart';

class FriendRequest {
  FriendRequest(
      {required this.id,
      required this.status,
      required this.senderId,
      required this.senderName,
      required this.creationDate,
      required this.message});

  final Int64 id;
  final FriendRequestStatus status;
  final Int64 senderId;
  final String senderName;
  final DateTime creationDate;
  final String message;

  FriendRequest copyWith({required FriendRequestStatus status}) =>
      FriendRequest(
        id: id,
        status: status,
        senderId: senderId,
        senderName: senderName,
        creationDate: creationDate,
        message: message,
      );
// final String status;
}

enum FriendRequestStatus {
  pending,
  accepted,
  // declined,
}
