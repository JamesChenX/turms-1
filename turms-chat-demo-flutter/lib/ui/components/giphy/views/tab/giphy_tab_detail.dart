import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../client/models/gif.dart';
import '../../client/models/response.dart';
import '../../client/models/type.dart';
import '../../shared_states.dart';

class GiphyTabDetail extends ConsumerStatefulWidget {
  GiphyTabDetail({Key? key, required this.type, required this.scrollController})
      : super(key: key);

  final GiphyType type;
  final ScrollController scrollController;

  @override
  _GiphyTabDetailState createState() => _GiphyTabDetailState();
}

class _GiphyTabDetailState extends ConsumerState<GiphyTabDetail> {
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
    ref.watch(queryTextProvider);

    widget.scrollController.addListener(_loadMoreIfScrollToEnd);
    // _appBarProvider.addListener(_resetAndLoad); TODO?

    // Set items count responsive
    _crossAxisCount = (MediaQuery.of(context).size.width / _gifWidth).round();

    // Set vertical max items count
    final _mainAxisCount =
        ((MediaQuery.of(context).size.height - 30) / _gifWidth).round();

    _limit = _crossAxisCount * _mainAxisCount;
    if (_limit > 100) {
      _limit = 100;
    }
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
    if (_gifs.isEmpty) {
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
      itemCount: _gifs.length,
      itemBuilder: (ctx, idx) {
        final _gif = _gifs[idx];
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
            : ExtendedImage.network(
                images.fixedWidth.webp!,
                semanticLabel: gif.title,
                gaplessPlayback: true,
                fit: BoxFit.fill,
                headers: {'accept': 'image/*'},
                loadStateChanged: (state) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: switch (state.extendedImageLoadState) {
                    LoadState.loading => AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: Container(
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    LoadState.completed => AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: ExtendedRawImage(
                          fit: BoxFit.fill,
                          image: state.extendedImageInfo?.image,
                        ),
                      ),
                    LoadState.failed => AspectRatio(
                        aspectRatio: _aspectRatio,
                        child: Container(
                          color: Theme.of(context).cardColor,
                        ),
                      )
                  },
                ),
              ),
      ),
    );
  }

  Future<void> _loadMore() async {
    if (_isLoading || _response?.pagination?.totalCount == _gifs.length) {
      return;
    }

    _isLoading = true;

    final client = ref.read(clientProvider);

    offset = _response == null
        ? 0
        : _response!.pagination!.offset + _response!.pagination!.count;

    // Get Gif or Emoji
    if (widget.type == GiphyType.emoji) {
      _response = await client.emojis(offset: offset, limit: _limit);
    } else {
      final queryText = ref.read(queryTextProvider);
      if (queryText.isNotEmpty) {
        _response = await client.search(queryText,
            // lang: _tabProvider.lang,
            offset: offset,
            // rating: _tabProvider.rating,
            type: widget.type,
            limit: _limit);
      } else {
        _response = await client.trending(
            // lang: _tabProvider.lang,
            offset: offset,
            // rating: _tabProvider.rating,
            type: widget.type,
            limit: _limit);
      }
    }

    if (_response!.data.isNotEmpty && mounted) {
      _gifs.addAll(_response!.data);
      setState(() {});
    }

    _isLoading = false;
  }

  void _loadMoreIfScrollToEnd() {
    if (widget.scrollController.positions.last.extentAfter.lessThan(500) &&
        !_isLoading) {
      _loadMore();
    }
  }

  // Return selected gif
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
