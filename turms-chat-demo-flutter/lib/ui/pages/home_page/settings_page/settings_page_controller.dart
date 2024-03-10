import 'package:flutter/material.dart';

import '../../../components/t_tabs/t_tabs.dart';
import 'setting_form_field_groups.dart';
import 'settings_page.dart';
import 'settings_page_view.dart';

class SettingsPageController extends State<SettingsPage> {
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) => SettingsPageView(this);

  void selectTab(int index, TTab tab) {
    selectedTabIndex = index;
    final fieldGroupContext =
        formFieldGroupToContext[tab.id as SettingFormFieldGroup]
            ?.key
            .currentContext;
    if (fieldGroupContext != null) {
      Scrollable.ensureVisible(fieldGroupContext,
          duration: const Duration(milliseconds: 100),
          curve: Curves.fastOutSlowIn);
    }
    setState(() {});
  }

  void selectTabWithoutScroll(int index) {
    selectedTabIndex = index;
    setState(() {});
  }
}
