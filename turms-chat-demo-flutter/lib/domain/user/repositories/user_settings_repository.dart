import 'package:fixnum/fixnum.dart';

import '../../../infra/storage/secure_storage_utils.dart';
import '../../../infra/storage/storage_setting_names.dart';

class UserSettingsRepository {
  Int64? userId;
  String? userPassword;

  void setUserId(Int64 userId) {
    SecureStorageUtils.setString(
        StorageSettingNames.settingUserId, userId.toString());
  }

  void setUserPassword(String userId, String userPassword) {
    SecureStorageUtils.setString(
        StorageSettingNames.settingUserId, userPassword);
  }
}

final userSettingsRepository = UserSettingsRepository();