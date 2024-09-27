part of './conversation.dart';

class GroupConversation extends Conversation {
  GroupConversation(
      {required super.messages,
      super.unreadMessageCount,
      super.draft,
      required this.contact})
      : super(id: 'group:${contact.groupId}', name: contact.name);

  @override
  final GroupContact contact;

  @override
  set contact(Contact _contact) {
    throw UnimplementedError();
  }

  @override
  ImageProvider<Object>? get image => contact.image;

  @override
  set image(ImageProvider<Object>? _image) {
    throw UnimplementedError();
  }

  @override
  bool hasSameContact(Contact contact) =>
      contact is GroupContact && contact.groupId == this.contact.groupId;
}