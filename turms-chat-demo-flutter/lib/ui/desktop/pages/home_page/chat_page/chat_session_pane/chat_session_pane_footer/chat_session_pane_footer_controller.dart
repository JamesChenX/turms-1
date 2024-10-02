import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../../domain/message/models/message_delivery_status.dart';
import '../../../../../../../domain/message/services/message_service.dart';
import '../../../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../../../infra/io/data_reader_file_adaptor.dart';
import '../../../../../../../infra/io/file_utils.dart';
import '../../../../../../../infra/logging/logger.dart';
import '../../../../../../../infra/random/random_utils.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../components/index.dart';
import '../../view_models/selected_conversation_view_model.dart';
import '../message.dart';
import 'chat_session_pane_footer.dart';
import 'chat_session_pane_footer_view.dart';

class ChatSessionPaneFooterController
    extends ConsumerState<ChatSessionPaneFooter> {
  final List<DataReaderFile> localFiles = [];
  bool dragging = false;

  late EmojiTextEditingController editorController;
  late FocusNode editorFocusNode;

  late TPopupController stickerPickerPopupController;

  late AppLocalizations appLocalizations;
  Conversation? conversation;

  @override
  void initState() {
    super.initState();
    editorController = EmojiTextEditingController();
    editorFocusNode = FocusNode();
    stickerPickerPopupController = TPopupController();
  }

  @override
  void dispose() {
    super.dispose();
    editorController.dispose();
    editorFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = ref.watch(appLocalizationsViewModel);
    final newConversation = ref.watch(selectedConversationViewModel);
    final currentConversation = conversation;
    if (newConversation?.id != currentConversation?.id) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (currentConversation != null) {
          final previousDraft = currentConversation.draft;
          final draft = getEditorDocument();
          if (draft.isNotEmpty && draft != previousDraft) {
            currentConversation.draft = draft;
          } else {
            currentConversation.draft = null;
          }
          ref.read(selectedConversationViewModel.notifier).notifyListeners();
        }
        final currentDraft = newConversation?.draft;
        if (currentDraft?.isBlank ?? true) {
          editorController.text = '';
        } else {
          editorController.text = currentDraft!;
        }
        editorFocusNode.requestFocus();
        setState(() {});
      });
      conversation = newConversation;
    }
    return ChatSessionPaneFooterView(this);
  }

  String getEditorDocument() => editorController.text.trim();

  bool tryAddNewFile(List<DataReaderFile> newFiles) {
    var hasNewFile = false;
    for (final newFile in newFiles) {
      // Exclude directory (Directory size is null).
      if (newFile.fileSize == null) {
        continue;
      }
      if (!localFiles.any((existingFile) =>
          existingFile.fileName == newFile.fileName &&
          existingFile.fileSize == newFile.fileSize)) {
        hasNewFile = true;
        localFiles.add(newFile);
      }
    }
    return hasNewFile;
  }

  void onDropEnter() {
    dragging = true;
    setState(() {});
  }

  void onDropLeave() {
    dragging = false;
    setState(() {});
  }

  DropOperation onDropOver(DropOverEvent event) {
    if (event.session.allowedOperations.contains(DropOperation.copy)) {
      return DropOperation.copy;
    } else {
      return DropOperation.none;
    }
  }

  Future<void> onPerformDrop(PerformDropEvent event) async {
    final futures = event.session.items.map((item) {
      final completer = Completer<DataReaderFile>();
      item.dataReader!
          .getFile(null, completer.complete, onError: completer.completeError);
      return completer.future;
    });
    final newFiles = await Future.wait(futures);
    if (tryAddNewFile(newFiles)) {
      setState(() {});
    }
  }

  void insertEmoji(String emoji) {
    final selection = editorController.selection;
    final start = selection.start;
    final end = selection.end;
    final text = editorController.text;
    String prefix;
    if (start < 0) {
      prefix = text + emoji;
      editorController.text = prefix;
    } else {
      prefix = start == 0 ? emoji : text.substring(0, start) + emoji;
      if (end >= text.length) {
        editorController.text = prefix;
      } else {
        editorController.text = prefix + text.substring(end);
      }
    }
    editorController.selection = TextSelection.collapsed(offset: prefix.length);

    editorFocusNode.requestFocus();
    stickerPickerPopupController.hidePopover?.call();
    setState(() {});
  }

  Future<void> sendInputMessage() async {
    final document = getEditorDocument();
    if (document.isBlank) {
      return;
    }
    await sendMessage(document);
  }

  void sendImage(
      String originalUrl, String thumbnailUrl, int width, int height) {
    try {
      final originalUri = Uri.parse(originalUrl);
      originalUrl = originalUri.origin + originalUri.path;
    } catch (e) {
      TToast.showToast(context, appLocalizations.failedToSendImageInvalidUrl);
      logger.error(
          'Failed to send image. The original URL is invalid: $originalUrl', e);
      return;
    }
    try {
      final thumbnailUri = Uri.parse(thumbnailUrl);
      thumbnailUrl = thumbnailUri.origin + thumbnailUri.path;
    } catch (e) {
      TToast.showToast(context, appLocalizations.failedToSendImageInvalidUrl);
      logger.error(
          'Failed to send image. The thumbnail URL is invalid: $thumbnailUrl',
          e);
      return;
    }
    final text = messageService.encodeImageMessage(
        originalUrl: originalUrl,
        thumbnailUrl: thumbnailUrl,
        width: width,
        height: height);
    sendMessage(text);
  }

  Future<void> sendMessage(String text) async {
    final fakeMessageId = -RandomUtils.nextUniqueInt64();
    final message = ChatMessage.parse(text,
        messageId: fakeMessageId,
        senderId: ref.read(loggedInUserViewModel)!.userId,
        sentByMe: true,
        isFakeMessage: false,
        isGroupMessage: conversation is GroupConversation,
        // Note that: the timestamp may be different from the one the recipients received.
        timestamp: DateTime.now(),
        status: MessageDeliveryStatus.delivering);
    final selectedConversationController =
        ref.read(selectedConversationViewModel.notifier)..addMessage(message);
    editorController.text = '';
    setState(() {});

    final sentMessage = await messageService.sendMessage(text, message);

    selectedConversationController.replaceMessage(
        fakeMessageId,
        message.copyWith(
            messageId: sentMessage.messageId,
            status: sentMessage.status,
            // Note that this may cause the timestamp UI of the message updated,
            // which is expected to ensure the timestamp is consistent with the server and recipients.
            timestamp: sentMessage.timestamp));
  }

  void removeFiles(DataReaderFile file) {
    localFiles.remove(file);
    setState(() {});
  }

  Future<void> pickFile() async {
    final result = await FileUtils.pickFile();
    if (result == null) {
      return;
    }
    final file = File(result.files.single.path!);
    tryAddNewFile([DataReaderFileValueAdapter(file)]);
    setState(() {});
  }
}
