import 'package:flutter/material.dart';

import '../../../../components/t_avatar/t_avatar.dart';
import '../../../../components/t_image_viewer/t_image_viewer.dart';
import 'user_profile_controller.dart';

class UserProfileImage extends StatefulWidget {
  const UserProfileImage({super.key, required this.userProfileController});

  final UserProfileController userProfileController;

  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  double imageOpacity = 0;

  @override
  Widget build(BuildContext context) {
    final userProfileController = widget.userProfileController;
    final user = userProfileController.widget.user;
    final image = user.image;
    final avatar = TAvatar(
      size: TAvatarSize.large,
      name: user.name,
      image: image,
    );
    if (userProfileController.widget.onEditTap case final onEditTap?) {
      return _buildEditableAvatar(onEditTap, avatar, userProfileController);
    }
    return image == null
        ? avatar
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                showImageViewerDialog(context, image);
              },
              child: avatar,
            ),
          );
  }

  MouseRegion _buildEditableAvatar(VoidCallback onEditTap, TAvatar avatar,
          UserProfileController userProfileController) =>
      MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            imageOpacity = 1;
          });
        },
        onExit: (_) {
          setState(() {
            imageOpacity = 0;
          });
        },
        child: GestureDetector(
          onTap: onEditTap,
          child: Stack(
            children: [
              avatar,
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: AnimatedOpacity(
                      opacity: imageOpacity,
                      duration: const Duration(milliseconds: 100),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(128, 0, 0, 0),
                        ),
                        child: Center(
                          child: Text(
                            userProfileController.appLocalizations.edit,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}