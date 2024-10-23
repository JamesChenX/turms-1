import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/user/services/user_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../l10n/view_models/app_localizations_view_model.dart';
import '../../../../../themes/index.dart';
import '../../../app_controller.dart';
import 'friend_request_page.dart';
import 'friend_request_page_view.dart';

class FriendRequestPageController extends ConsumerState<FriendRequestPage> {
  late ThemeData theme;
  late AppThemeExtension appThemeExtension;
  late AppLocalizations appLocalizations;
  late TextEditingController messageEditingController;

  bool isSending = false;

  @override
  void initState() {
    super.initState();
    messageEditingController = TextEditingController();
  }

  @override
  void dispose() {
    messageEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme = context.theme;
    appThemeExtension = theme.appThemeExtension;
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return FriendRequestPageView(this);
  }

  Future<void> sendFriendRequest(Int64 userId, String content) async {
    isSending = true;
    setState(() {});
    await userService.sendFriendRequest(userId, content);
    isSending = false;
    close();
  }

  void close() {
    AppController.popTopIfNameMatched(friendRequestDialogRouteName);
  }
}
