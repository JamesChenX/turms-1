import 'user.dart';

class GroupMember extends User {
  GroupMember({
    required super.userId,
    required super.name,
    super.intro,
    super.imageUrl,
    super.imageBytes,
    required this.isAdmin,
  });

  factory GroupMember.fromUser(User user, {bool isAdmin = false}) =>
      GroupMember(
          userId: user.userId,
          name: user.name,
          intro: user.intro,
          imageUrl: user.imageUrl,
          imageBytes: user.imageBytes,
          isAdmin: isAdmin);

  final bool isAdmin;
}
