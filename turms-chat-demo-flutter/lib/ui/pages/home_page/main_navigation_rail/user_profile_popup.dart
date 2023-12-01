import 'package:flutter/material.dart';

import '../../../components/components.dart';
import 'user_profile.dart';

class UserProfilePopup extends StatelessWidget {
  const UserProfilePopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) => TPopup(
        targetAnchor: Alignment.bottomRight,
        offset: Offset(-5, -5),
        target: TAvatar(),
        follower: Material(
          child: SizedBox(
            height: 200,
            width: 280,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ]),
                padding: const EdgeInsets.all(10),
                width: 50,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UserProfile(),
                      TTextButton(
                        text: 'Messages',
                        onPressed: () {},
                      ),
                    ],
                  ),
                )),
          ),
        ),
      );
}