import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../domain/user/models/user.dart';
import 'user_profile_controller.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({
    super.key,
    required this.user,
  });

  final User user;

  @override
  ConsumerState<UserProfile> createState() => UserProfileController();
}