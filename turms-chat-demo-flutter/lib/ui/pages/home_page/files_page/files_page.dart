import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'files_page_controller.dart';

class FilesPage extends ConsumerStatefulWidget {
  const FilesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FilesPageController();
}