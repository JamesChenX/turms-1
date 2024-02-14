import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/t_dialog.dart';
import 'new_relationship_page_controller.dart';

class NewRelationshipPage extends ConsumerStatefulWidget {
  const NewRelationshipPage({super.key, required this.showAddContactPage});

  final bool showAddContactPage;

  @override
  ConsumerState<NewRelationshipPage> createState() =>
      NewRelationshipPageController();
}

Future<void> showNewRelationshipDialog(
        BuildContext context, bool showAddContactPage) =>
    showTDialog(context, '/new-relationship-dialog',
        NewRelationshipPage(showAddContactPage: showAddContactPage));