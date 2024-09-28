import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/view_models/app_localizations_view_model.dart';
import '../index.dart';
import '../t_loading_indicator/t_loading_indicator.dart';
import 'client/client.dart';
import 'client/models/gif.dart';
import 'client/models/response.dart';
import 'client/models/type.dart';

final _queryTextViewModel = StateProvider<String>((ref) => '');

class GiphyPicker extends ConsumerWidget {
  const GiphyPicker({super.key, required this.onSelected});

  final ValueChanged<GiphyGif> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsViewModel);
    return Column(
      spacing: 8,
      children: [
        TSearchBar(
          hintText: appLocalizations.searchStickers,
          onSubmitted: (value) {
            ref.read(_queryTextViewModel.notifier).state = value;
          },
        ),
        Expanded(
          child: GiphyPickerBody(
            type: GiphyType.stickers,
            scrollController: ScrollController(),
            onSelected: onSelected,
          ),
        ),
      ],
    );
  }
}

class GiphyPickerBody extends ConsumerStatefulWidget {
  GiphyPickerBody(
      {Key? key,
      required this.type,
      required this.scrollController,
      required this.onSelected})
      : super(key: key);

  final GiphyType type;
  final ScrollController scrollController;
  final ValueChanged<GiphyGif> onSelected;

  @override
  _GiphyPickerBodyState createState() => _GiphyPickerBodyState();
}

const crossAxisCount = 5;
const limit = crossAxisCount * 10;

class _GiphyPickerBodyState extends ConsumerState<GiphyPickerBody> {
  GiphyResponse? _response;

  List<GiphyGif> _gifs = [];

  final Axis _scrollDirection = Axis.vertical;

  // Spacing between gifs in grid
  final double _spacing = 8.0;

  bool _isLoading = false;

  int offset = 0;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_loadMoreIfScrollToEnd);
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
      final appLocalizations = ref.watch(appLocalizationsViewModel);
      return Center(
        child: TLoadingIndicator(text: appLocalizations.loading),
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      scrollDirection: _scrollDirection,
      controller: widget.scrollController,
      itemCount: gifs.length,
      itemBuilder: (ctx, idx) => _buildItem(gifs[idx]),
    );
  }

  Widget _buildItem(GiphyGif gif) {
    final images = gif.images!;
    final image = images.fixedWidthSmall!;
    final _aspectRatio = double.parse(image.width) / double.parse(image.height);
    final url = image.url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.onSelected(gif),
          child: RepaintBoundary(
            child: LayoutBuilder(builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              return Image.network(
                url,
                cacheWidth: maxWidth.toInt(),
                cacheHeight: maxWidth ~/ _aspectRatio,
                semanticLabel: gif.title,
                gaplessPlayback: true,
                fit: BoxFit.fill,
                headers: {'accept': 'image/*'},
                // TODO
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
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _loadMore() async {
    var response = _response;
    if (_isLoading || response?.pagination?.totalCount == _gifs.length) {
      return;
    }

    _isLoading = true;

    final client = ref.read(giphyClientProvider);
    final appLocalizations = ref.read(appLocalizationsViewModel);

    appLocalizations.localeName;

    offset = response == null
        ? 0
        : response.pagination!.offset + response.pagination!.count;

    final type = widget.type;
    if (type == GiphyType.emoji) {
      response = await client.emojis(offset: offset, limit: limit);
    } else {
      final queryText = ref.read(_queryTextViewModel);
      if (queryText.isNotEmpty) {
        response = await client.search(queryText,
            // lang: _tabProvider.lang,
            offset: offset,
            // rating: _tabProvider.rating,
            type: type,
            limit: limit);
      } else {
        response = await client.trending(
            // lang: _tabProvider.lang,
            offset: offset,
            // rating: _tabProvider.rating,
            type: type,
            limit: limit);
      }
    }

    _response = response;
    if (response.data.isNotEmpty && mounted) {
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

  void _resetAndLoad() {
    // Reset pagination
    _response = null;

    // Reset list
    _gifs = [];

    // Load data
    _loadMore();
  }
}
