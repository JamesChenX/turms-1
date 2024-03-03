import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/user.dart';
import 'user_profile_controller.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({
    super.key,
    required this.user,
    this.avatarImageEditable = false,
  });

  final User user;
  final bool avatarImageEditable;

  @override
  ConsumerState<UserProfile> createState() => UserProfileController();
}
