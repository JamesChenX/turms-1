part of 'contact.dart';

class GroupContact extends Contact {
  GroupContact(
      {required this.groupId,
      required this.members,
      required super.name,
      super.intro,
      super.imageUrl,
      super.imageBytes})
      : id = 'group:$groupId';

  @override
  final String id;
  final Int64 groupId;
  final List<GroupMember> members;
}
