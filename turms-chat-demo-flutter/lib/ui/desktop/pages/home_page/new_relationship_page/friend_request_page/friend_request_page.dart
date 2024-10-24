import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/user/models/contact.dart';
import '../../../../components/t_dialog/t_dialog.dart';
import 'friend_request_page_controller.dart';

class FriendRequestPage extends ConsumerStatefulWidget {
  const FriendRequestPage(this.contact, {super.key});

  final Contact contact;

  @override
  ConsumerState<FriendRequestPage> createState() =>
      FriendRequestPageController();
}

const friendRequestDialogRouteName = '/friend-request-dialog';

Future<void> showFriendRequestDialog(BuildContext context, Contact contact) =>
    showCustomTDialog(
        routeName: friendRequestDialogRouteName,
        context: context,
        child: FriendRequestPage(contact));