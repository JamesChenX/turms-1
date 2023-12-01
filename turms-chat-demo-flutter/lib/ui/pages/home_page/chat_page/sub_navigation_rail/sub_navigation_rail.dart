import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sub_navigation_rail_controller.dart';

class SubNavigationRail extends ConsumerStatefulWidget {
  const SubNavigationRail({super.key});

  @override
  ConsumerState<SubNavigationRail> createState() =>
      SubNavigationRailController();
}