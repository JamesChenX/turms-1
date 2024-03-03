import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/user.dart';
import 'user_profile_controller.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({
    super.key,
    required this.user,
    this.onEditTap,
  });

  final User user;
  final VoidCallback? onEditTap;

  @override
  ConsumerState<UserProfile> createState() => UserProfileController();
}
