import 'package:fixnum/fixnum.dart';

class FriendRequest {
  FriendRequest(
      {required this.id,
      required this.senderId,
      required this.creationDate,
      required this.message});

  final Int64 id;
  final Int64 senderId;
  final DateTime creationDate;
  final String message;
// final String status;
}