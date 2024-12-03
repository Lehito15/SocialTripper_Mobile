import 'package:flutter/material.dart';

class GenericContentPage<T> extends StatefulWidget {
  final double Function(int, int) scrollTresholdFunction;
  final Future<void>? Function(T, BuildContext) precachingStrategy;
  final Future<T?> Function() retrieveContent;
  final Widget Function(T, BuildContext) buildItem;
  Future<void> Function() onRefresh;
  final ScrollController scrollController;

  GenericContentPage({
    super.key,
    required this.scrollTresholdFunction,
    required this.precachingStrategy,
    required this.retrieveContent,
    required this.buildItem,
    this.onRefresh = _defaultOnRefresh,
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController();

  static Future<void> _defaultOnRefresh() {
    return Future.value(0);
  }

  @override
  State<GenericContentPage<T>> createState() => _GenericContentPageState();
}

class _GenericContentPageState<T> extends State<GenericContentPage<T>> {
  final List<T> _loadedContent = [];
  late final ScrollController _scrollController = widget.scrollController;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isContent = true;
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
        !_isLoading && _isContent) {
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
    await widget.onRefresh();
    _isContent = true;
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final List<T> allResults = [];
    final List<T> results = [];

    for (int i = 0; i < 2 && i < initialLoadCount; i++) {
      final result = await widget.retrieveContent();

      // Sprawdzamy, czy wynik nie jest null
      if (result != null) {
        results.add(result);
      } else {
        _isContent = false;
        break;
      }
    }

    if (results.isNotEmpty) {
      await _precacheImages(results);
    }

    // Wczytujemy pozostałe dane
    if (initialLoadCount > 2 && _isContent) {
      final futures = List.generate(
        initialLoadCount - 2,
            (_) async {
          final result = await widget.retrieveContent();
          if (result != null) {
            return result;
          } else {
            print("No content available in the remaining items");
            _isContent = false;
            return null;
          }
        },
      );

      final remainingResults = await Future.wait(futures);

      // Dodajemy tylko wyniki, które nie są null
      results.addAll(remainingResults.where((item) => item != null).cast<T>());
    }

    // Dodajemy dane do ogólnej listy wyników
    allResults.addAll(results);

    // Zaktualizuj stan z danymi
    setState(() {
      _loadedContent
        ..clear()
        ..addAll(allResults);
      _isLoading = false;
    });

    // Precacheujemy obrazy dla pozostałych wyników
    if (results.length > 2) {
      await _precacheImages(results.skip(2).toList());
    }
  }

  Future<void> _loadMoreContent() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final List<T> allResults = [];

    // Pobieramy dane, ale jeśli napotkamy null, kończymy pętlę
    for (int i = 0; i < initialLoadCount; i++) {
      final result = await widget.retrieveContent();

      // Jeśli wynik jest null, przerwij pętlę
      if (result == null) {
        _isContent = false;
        break;
      }

      // Jeśli wynik nie jest null, dodajemy go do listy
      allResults.add(result);
    }

    // Zaktualizuj stan, dodając nowe dane
    setState(() {
      _loadedContent.addAll(allResults);
      _isLoadingMore = false;

      // Precache'owanie obrazów tylko jeśli są dane
      if (allResults.isNotEmpty) {
        _precacheImages(allResults);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
                  return widget.buildItem(_loadedContent[index], context);
                },
              childCount: _loadedContent.length + (_isLoadingMore ? 1 : 0),
            ))
          ],
        ));
  }
}
