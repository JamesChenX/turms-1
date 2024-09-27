import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_controller.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key, required this.container});

  final ProviderContainer container;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppController();
}
