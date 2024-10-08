import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/t_dialog/t_dialog.dart';
import 'create_group_page_controller.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => CreateGroupPageController();
}

const createGroupDialogRouteName = '/create-group-dialog';

Future<void> showCreateGroupDialog(BuildContext context) => showSimpleTDialog(
    routeName: createGroupDialogRouteName,
    context: context,
    child: const CreateGroupPage());
