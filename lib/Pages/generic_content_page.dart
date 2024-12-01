import 'package:flutter/material.dart';

class GenericContentPage<T> extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final double Function(int, int) scrollTresholdFunction;
  final Future<void>? Function(T, BuildContext) precachingStrategy;
  final Future<T> Function() retrieveContent;
  final Widget Function(T) buildItem;
  final ScrollController scrollController;

  GenericContentPage({
    super.key,
    required this.refreshIndicatorKey,
    required this.scrollTresholdFunction,
    required this.precachingStrategy,
    required this.retrieveContent,
    required this.buildItem,
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController();

  @override
  State<GenericContentPage<T>> createState() => _GenericContentPageState();
}

class _GenericContentPageState<T> extends State<GenericContentPage<T>> {
  final List<T> _loadedContent = [];
  late final ScrollController _scrollController = widget.scrollController;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  final int initialLoadCount = 15;
  final int incrementLoadCount = 15;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialContent();
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    const maxContent = 400;

    double threshold =
        widget.scrollTresholdFunction(_loadedContent.length, maxContent);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * (threshold / 100) &&
        !_isLoading) {
      _loadMoreContent();
    }
  }


  Future<void> _precacheImages(List<T> content) async {
    for (int i = 0; i < content.length; i++) {
      final T element = content[i];
      widget.precachingStrategy(element, context);
    }
  }

  Future<void> _loadInitialContent() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final List<T> allResults = [];
    final List<T> results = [];


    for (int i = 0; i < 2 && i < initialLoadCount; i++) {
      final result = await widget.retrieveContent();
      results.add(result);
    }
    await _precacheImages(results);

    if (initialLoadCount > 2) {
      final futures = List.generate(
        initialLoadCount - 2,
            (_) => widget.retrieveContent(),
      );
      final remainingResults = await Future.wait(futures);
      results.addAll(remainingResults);
    }

    allResults.addAll(results);


    setState(() {
      _loadedContent
        ..clear()
        ..addAll(allResults);
      _isLoading = false;
    });

    _precacheImages(results.skip(2).toList());
  }

  Future<void> _loadMoreContent() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final List<T> allResults = [];

    for (int i = 0; i < initialLoadCount; i++) {
      final result = await widget.retrieveContent();
      allResults.add(result);
    }

    setState(() {
      _loadedContent.addAll(allResults);
      _isLoadingMore = false;

      _precacheImages(allResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: widget.refreshIndicatorKey,
        onRefresh: _loadInitialContent,
        child: _isLoading && _loadedContent.isEmpty
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
          shrinkWrap: false,
          controller: _scrollController,
          slivers: [
            SliverList(delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_isLoadingMore && index == _loadedContent.length) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return widget.buildItem(_loadedContent[index]);
                },
              childCount: _loadedContent.length + (_isLoadingMore ? 1 : 0),
            ))
          ],
        ));
  }
}
