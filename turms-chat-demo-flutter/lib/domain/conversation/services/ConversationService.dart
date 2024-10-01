import '../fixtures/conversations.dart';
import '../models/conversation.dart';

class ConversationService {
  Future<List<Conversation>> queryConversations() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    return fixtureConversations;
  }
}

final conversationService = ConversationService();
