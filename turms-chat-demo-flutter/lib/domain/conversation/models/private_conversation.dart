import 'package:flutter/src/painting/image_provider.dart';

import '../../user/models/index.dart';
import 'conversation.dart';

class PrivateConversation extends Conversation {
  PrivateConversation(
      {required super.messages,
      super.unreadMessageCount,
      super.draft,
      required this.contact})
      : super(id: 'private:${contact.userId}', name: contact.name);

  @override
  final UserContact contact;

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
      contact is UserContact && contact.userId == this.contact.userId;
}
