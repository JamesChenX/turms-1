import 'package:flutter/src/painting/image_provider.dart';

import '../../user/models/index.dart';
import 'conversation.dart';

class GroupConversation extends Conversation {
  GroupConversation(
      {required super.messages,
      super.unreadMessageCount,
      super.draft,
      required this.contact})
      : super(id: 'group:${contact.groupId}', name: contact.name);

  final GroupContact contact;

  @override
  ImageProvider<Object>? get image => contact.image;

  @override
  set image(ImageProvider<Object>? _image) {}

  @override
  bool hasSameContact(Contact contact) =>
      contact is GroupContact && contact.groupId == this.contact.groupId;
}
