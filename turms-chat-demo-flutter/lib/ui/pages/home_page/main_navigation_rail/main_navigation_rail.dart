import 'package:pixel_snap/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import 'tabs.dart';
import '../shared_components/user_profile_popup.dart';

class MainNavigationRail extends ConsumerWidget {
  const MainNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedInUser = ref.watch(loggedInUserViewModel)!;
    return Container(
        color: const Color.fromARGB(255, 46, 46, 46),
        padding: const EdgeInsets.only(top: 32, bottom: 16),
        child: Column(
          children: [
            UserProfilePopup(
              user: loggedInUser,
            ),
            const SizedBox(
              height: 24,
            ),
            const Expanded(child: Tabs())
          ],
        ));
  }
}
