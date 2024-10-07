import 'package:flutter/material.dart';

import '../../../../../themes/index.dart';
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
        spacing: 16,
        children: [
          UserProfileImage(userProfileController: userProfileController),
          Expanded(
            child: Padding(
              padding: Sizes.paddingV4,
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
