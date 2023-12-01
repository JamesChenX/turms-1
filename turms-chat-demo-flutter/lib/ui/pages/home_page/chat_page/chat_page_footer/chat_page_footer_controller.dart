import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../../../../../infra/built_in_types/built_in_type_helpers.dart';
import '../../../../components/components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/app_localizations_view_model.dart';
import '../../shared_components/conversation.dart';
import '../../shared_states/shared_states.dart';
import '../message.dart';
import 'chat_page_footer.dart';
import 'chat_page_footer_view.dart';

class ChatPageFooterController extends ConsumerState<ChatPageFooter> {
  final List<DataReaderFile> localFiles = [];
  bool dragging = false;

  late QuillController editorController;
  late FocusNode editorFocusNode;
  late TPopupController stickerPickerPopupController;

  late AppLocalizations appLocalizations;
  ConversationData? conversation;

  @override
  void initState() {
    super.initState();
    final doc = Document();
    editorController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
    editorFocusNode = FocusNode();
    stickerPickerPopupController = TPopupController();
  }

  @override
  void dispose() {
    editorController.dispose();
    editorFocusNode.dispose();
    super.dispose();
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
          final draft = getEditorText();
          if (draft != (previousDraft ?? '')) {
            currentConversation.draft = draft;
            selectedConversationViewModelRef.notifyListeners();
          }
        }
        final currentDraft = newConversation?.draft;
        if (currentDraft?.isNotBlank == true) {
          editorController.document =
              Document.fromDelta(Delta()..insert(currentDraft!));
        } else {
          editorController.document = Document();
        }
        setState(() {});
      });
      conversation = newConversation;
    }
    return ChatPageFooterView(this);
  }

  String getEditorText() => editorController.document.toPlainText().trim();

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
    setState(() {
      dragging = true;
    });
  }

  void onDropLeave() {
    setState(() {
      dragging = false;
    });
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
    setState(() {
      // _textFieldController.text =
      //     _textFieldController.text + emoji;
      final selection = editorController.selection;
      final start = selection.start;
      final end = selection.end;
      final delta = end - start;
      if (delta > 0) {
        editorController.document.delete(start, delta);
      }
      editorController.document.insert(start, BlockEmbed('emoji', emoji));
      editorController.moveCursorToPosition(start + 1);
    });
    // Request focus from sticker picker
    editorFocusNode.requestFocus();
    stickerPickerPopupController.hidePopover();
  }

  void sendMessage() {
    final plainText = getEditorText();
    ref
        .read(selectedConversationViewModel.notifier)
        .state!
        .messages
        .add(ChatMessage(text: plainText));
    selectedConversationViewModelRef.notifyListeners();
    editorController.document = Document();
    // TODO: send
  }

  void removeFiles(DataReaderFile file) {
    setState(() {
      localFiles.remove(file);
    });
  }
}