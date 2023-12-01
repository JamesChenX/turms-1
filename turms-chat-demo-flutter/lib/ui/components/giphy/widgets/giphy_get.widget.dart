import 'dart:async';

import 'package:flutter/material.dart';

import '../client/models/gif.dart';
import '../giphy_sheet.dart';

typedef GiphyGetWrapperBuilder = Widget Function(
    Stream<GiphyGif>, GiphyGetWrapper);

class GiphyGetWrapper extends StatelessWidget {
  final String apiKey;
  final GiphyGetWrapperBuilder builder;
  final StreamController<GiphyGif> streamController =
      StreamController.broadcast();

  GiphyGetWrapper({
    Key? key,
    required this.apiKey,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => builder(streamController.stream, this);

  Future<void> open(
    String queryText,
    BuildContext context, {
    bool showGIFs = true,
    bool showStickers = true,
    bool showEmojis = true,
  }) async {
    final gif = await GiphySheet.open(
      queryText: queryText,
      context: context,
      apiKey: apiKey,
      showGIFs: showGIFs,
      showStickers: showStickers,
      showEmojis: showEmojis,
    );
    if (gif != null) {
      streamController.add(gif);
    }
  }
}