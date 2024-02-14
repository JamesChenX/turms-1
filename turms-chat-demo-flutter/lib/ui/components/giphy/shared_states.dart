import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/user/view_models/logged_in_user_info_view_model.dart';
import '../../../infra/env/env_vars.dart';
import 'client/client.dart';
import 'client/models/type.dart';
import 'theme.dart';

const _apiKey = EnvVars.giphyApiKey;

final queryTextProvider = StateProvider<String>((ref) => '');
final tabTypeProvider = StateProvider<GiphyType?>((ref) => null);
final sheetInitialExtentProvider =
    StateProvider<double>((ref) => sheetMinExtent);
final clientProvider = StateProvider<GiphyClient>((ref) {
  final randomId = ref.watch(loggedInUserViewModel)!.userId.toString() ?? '';
  return GiphyClient(apiKey: _apiKey, randomId: randomId);
});