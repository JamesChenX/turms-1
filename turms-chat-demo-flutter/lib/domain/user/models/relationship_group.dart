import 'contact.dart';

class RelationshipGroup {
  RelationshipGroup(this.name, this.isBlocked, this.contacts);

  final String name;
  final bool isBlocked;
  final List<Contact> contacts;
}