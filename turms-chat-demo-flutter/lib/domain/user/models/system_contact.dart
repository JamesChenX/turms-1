part of 'contact.dart';

class SystemContact extends Contact {
  SystemContact(
      {required this.type,
      required super.name,
      super.intro,
      super.imageUrl,
      super.imageBytes,
      super.icon})
      : id = 'system:$type';

  @override
  final String id;
  final SystemContactType type;
}

enum SystemContactType {
  friendRequest,
  fileTransfer,
}
