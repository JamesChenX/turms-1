import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/components.dart';
import '../../../l10n/app_localizations_view_model.dart';
import '../main_navigation_rail/user_profile.dart';

class MyAccountSettingsPage extends ConsumerWidget {
  const MyAccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 350, child: UserProfile()),
          SizedBox(
            height: 36,
          ),
          TCheckbox(
            false,
            appLocalizations.autoLogin,
            onCheckedChanged: (bool value) {},
          ),
          SizedBox(
            height: 36,
          ),
          TTextButton(
              backgroundColor: Colors.white,
              backgroundHoverColor: Color.fromARGB(255, 235, 235, 235),
              text: appLocalizations.logOut,
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 37, 36, 35),
                  fontWeight: FontWeight.w600),
              enableBorder: true,
              onPressed: () {
                // TODO: Reset states
              })
        ],
      ),
    );
  }
}