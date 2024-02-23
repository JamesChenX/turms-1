import 'package:flutter/src/painting/image_provider.dart';

import '../../user/models/contact.dart';
import '../../user/models/user_contact.dart';
import 'conversation.dart';

class PrivateConversation extends Conversation {
  PrivateConversation(
      {required super.messages,
      super.unreadMessageCount,
      super.draft,
      required this.contact})
      : super(id: 'private:${contact.userId}', name: contact.name);

  final UserContact contact;

  @override
  ImageProvider<Object>? get image => contact.image;

  @override
  set image(ImageProvider<Object>? _image) {}

  @override
  bool hasSameContact(Contact contact) =>
      contact is UserContact && contact.userId == this.contact.userId;
}
