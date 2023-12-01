import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../infra/assets/assets.gen.dart';
import '../../../infra/window/window_utils.dart';
import '../../components/t_title_bar.dart';
import 'login_form/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => Material(
          child: Stack(children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (details) {
            WindowUtils.startDragging();
          },
          child: const SizedBox.expand(),
          // child: ConstrainedBox(constraints: const BoxConstraints.expand()),
        ),
        const TTitleBar(displayCloseOnly: true, backgroundColor: Colors.white),
        Padding(
          padding:
              const EdgeInsets.only(left: 36, right: 36, top: 36, bottom: 16),
          child: Container(
            // padding: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 30),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            // color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  width: 320,
                  Assets.images.logo,
                  // width: 200,
                  // height: 200,
                  // fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 32,
                ),
                LoginForm(),
              ],
            ),
          ),
        )
      ]));
}