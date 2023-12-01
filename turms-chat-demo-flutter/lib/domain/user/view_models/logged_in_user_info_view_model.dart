import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_info.dart';

final loggedInUserInfoViewModel = StateProvider<UserInfo?>((ref) => null);