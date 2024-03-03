import 'package:flutter/material.dart';

import 'user_profile_controller.dart';
import 'user_profile_image.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView(this.userProfileController, {super.key});

  final UserProfileController userProfileController;

  @override
  Widget build(BuildContext context) => _buildProfile(context);

  Widget _buildProfile(BuildContext context) {
    final widget = userProfileController.widget;
    final user = widget.user;
    return IntrinsicHeight(
      child: Row(
        children: [
          UserProfileImage(userProfileController: userProfileController),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SelectionArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text(
                        '${userProfileController.appLocalizations.userId}: ${user.userId}'),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
