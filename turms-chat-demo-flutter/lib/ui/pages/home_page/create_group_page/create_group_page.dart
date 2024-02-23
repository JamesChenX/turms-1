import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/t_dialog.dart';
import 'create_group_page_controller.dart';

class CreateGroupPage extends ConsumerStatefulWidget {
  const CreateGroupPage({super.key});

  @override
  ConsumerState<CreateGroupPage> createState() => CreateGroupPageController();
}

Future<void> showCreateGroupDialog(BuildContext context) =>
    showTDialog(context, '/create-group-dialog', CreateGroupPage());
