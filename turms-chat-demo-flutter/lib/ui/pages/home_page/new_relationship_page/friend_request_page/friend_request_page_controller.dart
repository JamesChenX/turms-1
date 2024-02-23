import 'package:fixnum/src/int64.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/view_models/app_localizations_view_model.dart';
import 'friend_request_page.dart';
import 'friend_request_page_view.dart';

class FriendRequestPageController extends ConsumerState<FriendRequestPage> {
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
    appLocalizations = ref.watch(appLocalizationsViewModel);
    return FriendRequestPageView(this);
  }

  Future<void> sendFriendRequest(Int64 userId, String content) async {
    isSending = true;
    setState(() {});
    // TODO: use real API
    await Future.delayed(const Duration(seconds: 3));
    isSending = false;
    close();
  }

  void close() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
