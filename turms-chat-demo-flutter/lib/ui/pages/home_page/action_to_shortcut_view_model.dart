import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page_action.dart';

final actionToShortcutViewModel =
    StateProvider<Map<HomePageAction, ShortcutActivator>>((ref) => {
          for (final type in HomePageAction.values)
            type: type.defaultShortcutActivator,
        });
