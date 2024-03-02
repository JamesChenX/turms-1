import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../../../components/t_avatar/t_avatar.dart';
import '../../../../components/t_image_viewer.dart';
import 'user_profile_controller.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView(this.userProfileController, {super.key});

  final UserProfileController userProfileController;

  @override
  Widget build(BuildContext context) => _buildProfile(context);

  Widget _buildProfile(BuildContext context) {
    final widget = userProfileController.widget;
    final user = widget.user;
    final image = user.image;
    final avatar = TAvatar(
      size: TAvatarSize.large,
      name: user.name,
      image: user.image,
    );
    return IntrinsicHeight(
      child: Row(
        children: [
          image == null
              ? avatar
              : MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      showImageViewerDialog(context, image);
                    },
                    child: avatar,
                  ),
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
