import 'package:pixel_snap/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/t_dialog.dart';
import 'about_page_controller.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<AboutPage> createState() => AboutPageController();
}

// Don't call "showAboutDialog" to avoid name conflict with
// the one in "flutter/lib/src/material/about.dart".
Future<void> showAppAboutDialog(BuildContext context) =>
    showTDialog(context, '/about-dialog', const AboutPage());
