import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/view_models/app_localizations_view_model.dart';
import '../components.dart';
import 'client/client.dart';
import 'client/models/gif.dart';
import 'client/models/response.dart';
import 'client/models/type.dart';

final _queryTextViewModel = StateProvider<String>((ref) => '');

class GiphyPicker extends ConsumerWidget {
  const GiphyPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return Column(
      children: [
        TSearchBar(
          hintText: appLocalizations.searchStickers,
          onSubmitted: (value) {
            ref.read(_queryTextViewModel.notifier).state = value;
          },
        ),
        Expanded(
          child: GiphyPickerBody(
            type: GiphyType.emoji,
            scrollController: ScrollController(),
          ),
        ),
      ],
    );
  }
}

class GiphyPickerBody extends ConsumerStatefulWidget {
  GiphyPickerBody(
      {Key? key, required this.type, required this.scrollController})
      : super(key: key);

  final GiphyType type;
  final ScrollController scrollController;

  @override
  _GiphyPickerBodyState createState() => _GiphyPickerBodyState();
}

class _GiphyPickerBodyState extends ConsumerState<GiphyPickerBody> {
  GiphyResponse? _response;

  List<GiphyGif> _gifs = [];

  final Axis _scrollDirection = Axis.vertical;

  late int _crossAxisCount;

  // Spacing between gifs in grid
  final double _spacing = 8.0;

  late double _gifWidth;

  // Limit of query
  late int _limit;

  bool _isLoading = false;

  int offset = 0;

  @override
  void initState() {
    super.initState();

    _gifWidth = switch (widget.type) {
      GiphyType.gifs => 200,
      GiphyType.stickers => 150,
      GiphyType.emoji => 80
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget.scrollController.addListener(_loadMoreIfScrollToEnd);
    // _appBarProvider.addListener(_resetAndLoad); TODO?

    // Set items count responsive
    _crossAxisCount = (MediaQuery.of(context).size.width / _gifWidth).round();

    // Set vertical max items count
    final _mainAxisCount =
        ((MediaQuery.of(context).size.height - 30) / _gifWidth).round();

    _limit = min(100, _crossAxisCount * _mainAxisCount);
    offset = 0;

    _loadMore();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_loadMoreIfScrollToEnd);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gifs = _gifs;
    if (gifs.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      scrollDirection: _scrollDirection,
      controller: widget.scrollController,
      itemCount: gifs.length,
      itemBuilder: (ctx, idx) {
        final _gif = gifs[idx];
        return _buildItem(_gif);
      },
    );
  }

  Widget _buildItem(GiphyGif gif) {
    final images = gif.images!;
    final _aspectRatio = double.parse(images.fixedWidth.width) /
        double.parse(images.fixedWidth.height);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () => _selectedGif(gif),
        child: images.fixedWidth.webp == null
            ? Container()
            : Image.network(
                images.fixedWidth.webp!,
                semanticLabel: gif.title,
                gaplessPlayback: true,
                fit: BoxFit.fill,
                headers: {'accept': 'image/*'},
                // loadStateChanged: (state) => AnimatedSwitcher(
                //   duration: const Duration(milliseconds: 350),
                //   child: switch (state.extendedImageLoadState) {
                //     LoadState.loading => AspectRatio(
                //         aspectRatio: _aspectRatio,
                //         child: Container(
                //           color: Theme.of(context).cardColor,
                //         ),
                //       ),
                //     LoadState.completed => AspectRatio(
                //         aspectRatio: _aspectRatio,
                //         child: ExtendedRawImage(
                //           fit: BoxFit.fill,
                //           image: state.extendedImageInfo?.image,
                //         ),
                //       ),
                //     LoadState.failed => AspectRatio(
                //         aspectRatio: _aspectRatio,
                //         child: Container(
                //           color: Theme.of(context).cardColor,
                //         ),
                //       )
                //   },
              ),
      ),
    );
  }

  Future<void> _loadMore() async {
    final response = _response;
    if (_isLoading || response?.pagination?.totalCount == _gifs.length) {
      return;
    }

    _isLoading = true;

    final client = ref.read(giphyClientProvider);

    offset = response == null
        ? 0
        : response.pagination!.offset + response.pagination!.count;

    final type = widget.type;
    if (type == GiphyType.emoji) {
      _response = await client.emojis(offset: offset, limit: _limit);
    } else {
      final queryText = ref.read(_queryTextViewModel);
      if (queryText.isNotEmpty) {
        _response = await client.search(queryText,
            // lang: _tabProvider.lang,
            offset: offset,
            // rating: _tabProvider.rating,
            type: type,
            limit: _limit);
      } else {
        _response = await client.trending(
            // lang: _tabProvider.lang,
            offset: offset,
            // rating: _tabProvider.rating,
            type: type,
            limit: _limit);
      }
    }

    if (response!.data.isNotEmpty && mounted) {
      _gifs.addAll(response.data);
      setState(() {});
    }

    _isLoading = false;
  }

  void _loadMoreIfScrollToEnd() {
    // if (widget.scrollController.positions.last.extentAfter.lessThan(500) &&
    //     !_isLoading) {
    //   _loadMore();
    // }
  }

  void _selectedGif(GiphyGif gif) {
    Navigator.pop(context, gif);
  }

  void _resetAndLoad() {
    // Reset pagination
    _response = null;

    // Reset list
    _gifs = [];

    // Load data
    _loadMore();
  }
}
