import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'friend_requests_page_controller.dart';

class FriendRequestsPage extends ConsumerStatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  ConsumerState createState() => FriendRequestsPageController();
}