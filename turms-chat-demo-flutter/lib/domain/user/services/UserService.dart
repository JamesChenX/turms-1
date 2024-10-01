import 'package:fixnum/src/int64.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../ui/l10n/app_localizations.dart';
import '../fixtures/contacts.dart';
import '../models/contact.dart';
import '../models/user.dart';

class UserService {
  Future<List<Contact>> queryContacts(AppLocalizations appLocalizations) async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return getSystemContacts(appLocalizations) + fixtureContacts;
  }

  List<Contact> getSystemContacts(AppLocalizations appLocalizations) => [
        SystemContact(
            type: SystemContactType.requestNotification,
            name: appLocalizations.requestNotification,
            icon: Symbols.person_add_rounded),
        SystemContact(
            type: SystemContactType.fileTransfer,
            name: appLocalizations.fileTransfer,
            icon: Symbols.drive_file_move_rounded),
      ];

  Future<void> acceptFriendRequest(Int64 id) async {
    await Future<void>.delayed(const Duration(seconds: 3));
  }

  Future<User> login(Int64 userId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return User(userId: userId, name: 'James Chen');
  }
}

final userService = UserService();
