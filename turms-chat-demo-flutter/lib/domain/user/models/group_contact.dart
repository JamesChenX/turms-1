import 'package:fixnum/fixnum.dart';

import 'contact.dart';

class GroupContact extends Contact {
  GroupContact(
      {required this.groupId,
      required this.memberIds,
      required super.name,
      super.intro,
      super.imageUrl,
      super.imageBytes})
      : id = 'group:$groupId';

  @override
  final String id;
  final Int64 groupId;
  final Set<Int64> memberIds;
}