import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_page_footer_controller.dart';

class ChatPageFooter extends ConsumerStatefulWidget {
  const ChatPageFooter({super.key});

  @override
  ConsumerState<ChatPageFooter> createState() => ChatPageFooterController();
}