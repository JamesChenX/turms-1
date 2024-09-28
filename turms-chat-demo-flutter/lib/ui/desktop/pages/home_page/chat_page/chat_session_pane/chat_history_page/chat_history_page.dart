import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../components/t_dialog/t_dialog.dart';
import 'chat_history_page_controller.dart';

class ChatHistoryPage extends ConsumerStatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  ConsumerState<ChatHistoryPage> createState() => ChatHistoryPageController();
}

Future<void> showChatHistoryDialog(BuildContext context) => showCustomTDialog(
    routeName: '/chat-history-dialog',
    context: context,
    child: const ChatHistoryPage());
