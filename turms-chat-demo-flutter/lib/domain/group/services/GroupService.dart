import 'package:fixnum/fixnum.dart';

class GroupService {
  Future<void> approveGroupMembershipRequest(Int64 id) async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }
}

final groupService = GroupService();
