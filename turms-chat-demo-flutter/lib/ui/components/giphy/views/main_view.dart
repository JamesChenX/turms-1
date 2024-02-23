import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared_states.dart';
import '../theme.dart';
import 'search_bar/giphy_search_bar.dart';
import 'tab/giphy_tab_bar.dart';
import 'tab/giphy_tab_bottom.dart';
import 'tab/giphy_tab_top.dart';
import 'tab/giphy_tab_view.dart';

class MainView extends ConsumerStatefulWidget {
  MainView({
    Key? key,
    this.showEmojis = true,
    this.showGIFs = true,
    this.showStickers = true,
  }) : super(key: key);

  final bool showGIFs;
  final bool showStickers;
  final bool showEmojis;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: [
        widget.showGIFs,
        widget.showEmojis,
        widget.showStickers,
      ].where((isShown) => isShown).length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) => _buildSheet();

  Widget _buildSheet() => DraggableScrollableSheet(
      minChildSize: sheetMinExtent,
      maxChildSize: sheetMaxExtent,
      initialChildSize: ref.read(sheetInitialExtentProvider),
      builder: (ctx, scrollController) {
        _scrollController = scrollController;
        return _buildSheetBody();
      });

  Widget _buildSheetBody() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GiphyTabTop(),
          GiphyTabBar(
            tabController: _tabController,
            showGIFs: widget.showGIFs,
            showStickers: widget.showStickers,
            showEmojis: widget.showEmojis,
          ),
          GiphySearchBar(),
          Expanded(
            child: GiphyTabView(
              tabController: _tabController,
              scrollController: _scrollController,
              showGIFs: widget.showGIFs,
              showStickers: widget.showStickers,
              showEmojis: widget.showEmojis,
            ),
          ),
          const GiphyTabBottom(),
        ],
      );
}
