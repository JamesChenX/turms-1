import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../infra/assets/assets.gen.dart';
import '../../components/t_title_bar.dart';
import '../../components/t_window_control_zone.dart';
import 'login_form/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Stack(children: [
        ColoredBox(
          color: Colors.white,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 36, right: 36, top: 36, bottom: 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    width: 320,
                    Assets.images.logo,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const LoginForm(),
                ],
              ),
            ),
          ),
        ),
        const TWindowControlZone(toggleMaximizeOnDoubleTap: false),
        const TTitleBar(displayCloseOnly: true, backgroundColor: Colors.white),
      ]);
}