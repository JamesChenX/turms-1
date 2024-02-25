import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../client/models/type.dart';
import '../../l10n/l10n.dart';
import '../../shared_states.dart';

class GiphyTabBar extends ConsumerStatefulWidget {
  final TabController tabController;

  const GiphyTabBar({
    Key? key,
    required this.tabController,
    this.showEmojis = true,
    this.showGIFs = true,
    this.showStickers = true,
  }) : super(key: key);

  final bool showGIFs;
  final bool showStickers;
  final bool showEmojis;

  @override
  _GiphyTabBarState createState() => _GiphyTabBarState();
}

class TabWithType {
  final Tab tab;
  final GiphyType type;

  TabWithType({
    required this.tab,
    required this.type,
  });
}

class _GiphyTabBarState extends ConsumerState<GiphyTabBar> {
  late List<TabWithType> _tabs;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      _setTabType(widget.tabController.index);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setTabType(0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l = GiphyGetUILocalizations.labelsOf(context);
    _tabs = [
      if (widget.showGIFs)
        TabWithType(tab: Tab(text: l.gifsLabel), type: GiphyType.gifs),
      if (widget.showStickers)
        TabWithType(tab: Tab(text: l.stickersLabel), type: GiphyType.stickers),
      if (widget.showEmojis)
        TabWithType(tab: Tab(text: l.emojisLabel), type: GiphyType.emoji),
    ];
  }

  @override
  void dispose() {
    widget.tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs.length == 1) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: TabBar(
        // indicatorColor: _tabProvider.tabColor,
        // labelColor: _tabProvider.textSelectedColor,
        // unselectedLabelColor: _tabProvider.textUnselectedColor,
        indicatorSize: TabBarIndicatorSize.label,
        controller: widget.tabController,
        tabs: _tabs.map((e) => e.tab).toList(),
        onTap: _setTabType,
      ),
    );
  }

  void _setTabType(int pos) {
    ref.read(tabTypeProvider.notifier).state = _tabs[pos].type;
  }
}
