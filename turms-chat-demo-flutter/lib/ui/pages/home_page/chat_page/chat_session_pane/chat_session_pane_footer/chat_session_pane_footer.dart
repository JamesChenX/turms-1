import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_session_pane_footer_controller.dart';

class ChatSessionPaneFooter extends ConsumerStatefulWidget {
  const ChatSessionPaneFooter({super.key});

  @override
  ConsumerState<ChatSessionPaneFooter> createState() =>
      ChatSessionPaneFooterController();
}
