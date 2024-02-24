part of 'contact.dart';

class UserContact extends Contact implements User {
  UserContact(
      {required this.userId,
      required super.name,
      super.intro,
      super.imageUrl,
      super.imageBytes,
      this.relationshipGroupId})
      : id = 'user:$userId';

  factory UserContact.fromUser(User user, Int64 relationshipGroupId) =>
      UserContact(
          userId: user.userId,
          name: user.name,
          intro: user.intro,
          imageUrl: user.imageUrl,
          imageBytes: user.imageBytes,
          relationshipGroupId: relationshipGroupId);

  @override
  final String id;
  @override
  final Int64 userId;
  final Int64? relationshipGroupId;
}
