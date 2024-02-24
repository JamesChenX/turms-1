import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/user/models/index.dart';
import '../../../../domain/user/models/setting_action_on_close.dart';
import '../../../../domain/user/models/setting_locale.dart';
import '../../../../domain/user/repositories/user_settings_repository.dart';
import '../../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../../domain/user/view_models/user_settings_view_model.dart';
import '../../../../infra/app/app_config.dart';
import '../../../../infra/autostart/autostart_manager.dart';
import '../../../../infra/keyboard/shortcut_extensions.dart';
import '../../../components/components.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../l10n/view_models/use_system_locale_view_model.dart';
import '../../../themes/app_theme_view_model.dart';
import '../action_to_shortcut_view_model.dart';
import '../home_page_action.dart';
import 'setting_form_field_groups.dart';

part 'settings_pane_controller.dart';
part 'settings_pane_view.dart';

class SettingsPane extends ConsumerStatefulWidget {
  const SettingsPane(
      {super.key, required this.onSettingFormFieldGroupScrolled});

  final void Function(int index) onSettingFormFieldGroupScrolled;

  @override
  ConsumerState<SettingsPane> createState() => _SettingsPaneController();
}
