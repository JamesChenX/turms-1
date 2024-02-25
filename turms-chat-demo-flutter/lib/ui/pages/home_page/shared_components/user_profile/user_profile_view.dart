import 'package:pixel_snap/material.dart';

import '../../../../components/t_avatar/t_avatar.dart';
import 'user_profile_controller.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView(this.userProfileController, {super.key});

  final UserProfileController userProfileController;

  @override
  Widget build(BuildContext context) => _buildProfile();

  Widget _buildProfile() {
    final widget = userProfileController.widget;
    final user = widget.user;
    return IntrinsicHeight(
      child: Row(
        children: [
          TAvatar(
            size: TAvatarSize.large,
            name: user.name,
            image: user.image,
          ),
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
