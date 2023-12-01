library giphy_get;

import 'package:flutter/material.dart';

import 'client/models/gif.dart';
import 'client/models/languages.dart';
import 'client/models/rating.dart';
import 'views/main_view.dart';

class GiphySheet {
  GiphySheet._();

  static Future<GiphyGif?> open({
    required BuildContext context,
    required String apiKey,
    String rating = GiphyRating.g,
    String lang = GiphyLanguage.english,
    String searchText = '',
    String queryText = '',
    bool showGIFs = true,
    bool showStickers = true,
    bool showEmojis = true,
    Color? tabColor,
    Color? textSelectedColor,
    Color? textUnselectedColor,
    int debounceTimeInMilliseconds = 350,
  }) =>
      showModalBottomSheet<GiphyGif>(
        clipBehavior: Clip.antiAlias,
        shape: Theme.of(context).bottomSheetTheme.shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
        isScrollControlled: true,
        context: context,
        builder: (ctx) => SafeArea(
          child: MainView(
            showGIFs: showGIFs,
            showStickers: showStickers,
            showEmojis: showEmojis,
          ),
        ),
      );
}