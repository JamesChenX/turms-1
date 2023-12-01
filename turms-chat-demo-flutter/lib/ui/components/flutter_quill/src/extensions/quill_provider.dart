import 'package:flutter/widgets.dart' show BuildContext;

import '../../flutter_quill.dart';

// TODO: The comments of this file is outdated and needs to be updated

/// Public shared extension
extension QuillProviderExt on BuildContext {
  /// return [QuillProvider] as not null
  /// throw exception if it's not in the widget tree
  QuillProvider get requireQuillProvider => QuillProvider.ofNotNull(this);

  /// return nullable [QuillProvider]
  /// don't throw exception if it's not in the widget tree
  /// instead it will be null
  QuillProvider? get quillProvider => QuillProvider.of(this);

  /// return nullable [QuillController]
  /// since the quill controller is in the [QuillProvider] then we need to get
  /// the provider widget first and then we will return the controller
  /// don't throw exception if [QuillProvider] is not in the widget tree
  /// instead it will be null
  QuillController? get quilController =>
      quillProvider?.configurations.controller;

  /// return [QuillController] as not null
  /// since the quill controller is in the [QuillProvider] then we need to get
  /// the provider widget first and then we will return the controller
  /// throw exception if [QuillProvider] is not in the widget tree
  QuillController get requireQuillController =>
      requireQuillProvider.configurations.controller;

  /// return [QuillConfigurations] as not null
  /// since the quill configurations is in the [QuillProvider] then we need to
  /// get the provider widget first and then we will return quill configurations
  /// throw exception if [QuillProvider] is not in the widget tree
  QuillConfigurations get requireQuillConfigurations =>
      requireQuillProvider.configurations;

  /// return nullable [QuillConfigurations]
  /// since the quill configurations is in the [QuillProvider] then we need to
  /// get the provider widget first and then we will return quill configurations
  /// don't throw exception if [QuillProvider] is not in the widget tree
  QuillConfigurations? get quillConfigurations => quillProvider?.configurations;

  /// return [QuillSharedConfigurations] as not null. Since the quill
  /// shared configurations is in the [QuillProvider] then we need to get the
  /// provider widget first and then we will return shared configurations
  /// throw exception if [QuillProvider] is not in the widget tree
  QuillSharedConfigurations get requireQuillSharedConfigurations =>
      requireQuillConfigurations.sharedConfigurations;

  /// return nullable [QuillSharedConfigurations] . Since the quill
  /// shared configurations is in the [QuillProvider] then we need to get the
  /// provider widget first and then we will return shared configurations
  /// don't throw exception if [QuillProvider] is not in the widget tree
  QuillSharedConfigurations? get quillSharedConfigurations =>
      quillConfigurations?.sharedConfigurations;

  /// return [QuillEditorConfigurations] as not null . Since the quill
  /// editor configurations is in the [QuillEditorProvider]
  ///  then we need to get the
  /// provider widget first and then we will return editor configurations
  /// throw exception if [QuillProvider] is not in the widget tree
  QuillEditorConfigurations get requireQuillEditorConfigurations =>
      QuillEditorProvider.ofNotNull(this).editorConfigurations;

  /// return [QuillToolbarBaseButtonOptions] as not null. Since the quill
  /// quill editor block options is in the [QuillEditorProvider] then we need to
  /// get the provider widget first and then we will return block options
  /// don't throw exception if [QuillEditorProvider] is not in the widget tree
  QuillEditorElementOptions get requireQuillEditorElementOptions =>
      requireQuillEditorConfigurations.elementOptions;
}