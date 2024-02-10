import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../../../../../domain/conversation/models/conversation.dart';
import '../../../../../../domain/message/message_delivery_status.dart';
import '../../../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../../components/t_editor/t_editor.dart';
import '../../../../../components/t_popup/t_popup.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../message.dart';
import '../../view_models/selected_conversation_view_model.dart';
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
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (currentConversation != null) {
          final previousDraft = currentConversation.draft;
          final draft = getEditorDocument();
          if (draft != (previousDraft ?? '')) {
            currentConversation.draft = draft;
            selectedConversationViewModelRef.notifyListeners();
          }
        }
        final currentDraft = newConversation?.draft;
        if (currentDraft?.isBlank ?? true) {
          editorController.text = '';
        } else {
          editorController.text = currentDraft!;
        }
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
    }).toList();
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
    if (end >= text.length) {
      prefix = text + emoji;
      editorController.text = prefix;
    } else {
      prefix = text.substring(0, start) + emoji;
      editorController.text = prefix + text.substring(end);
    }
    editorController.selection = TextSelection.collapsed(offset: prefix.length);

    editorFocusNode.requestFocus();
    stickerPickerPopupController.hidePopover();
    setState(() {});
  }

  void sendMessage() {
    final document = getEditorDocument();
    ref.read(selectedConversationViewModel.notifier).state!.messages.add(
        ChatMessage(ref.read(loggedInUserViewModel)!.userId, true, document,
            DateTime.now(), MessageDeliveryStatus.delivering));
    selectedConversationViewModelRef.notifyListeners();

    editorController.text = '';
    setState(() {});
    // TODO: send
  }

  void removeFiles(DataReaderFile file) {
    localFiles.remove(file);
    setState(() {});
  }
}