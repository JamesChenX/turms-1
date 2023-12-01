import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_controller.dart';

class App extends ConsumerStatefulWidget {
  App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppController();
}