import 'package:flutter/material.dart';

class GenericContentPage<T> extends StatefulWidget {
  final double Function(int, int) scrollTresholdFunction;
  final Future<void>? Function(T, BuildContext) precachingStrategy;
  final Future<T?> Function() retrieveContent;
  final Widget Function(T, BuildContext) buildItem;
  final Future<void> Function() onRefresh;
  final ScrollController scrollController;

  GenericContentPage({
    super.key,
    required this.scrollTresholdFunction,
    required this.precachingStrategy,
    required this.retrieveContent,
    required this.buildItem,
    required this.onRefresh,
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController();

  @override
  State<GenericContentPage<T>> createState() => _GenericContentPageState();
}

class _GenericContentPageState<T> extends State<GenericContentPage<T>> {
  final List<T> _loadedContent = [];
  late final ScrollController _scrollController = widget.scrollController;
  bool firstTimeVisit = true;
  bool _isLoadingMore = false;
  bool _isContent = true;

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
    double threshold = widget.scrollTresholdFunction(_loadedContent.length, maxContent);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * (threshold / 100) &&
        !_isLoadingMore &&
        _isContent) {
      _loadMoreContent();
    }
  }

  Future<void> _loadInitialContent() async {
    await widget.onRefresh();
    setState(() {
      _isLoadingMore = true;
    });

    final List<T> results = [];
    for (int i = 0; i < 15; i++) {
      final result = await widget.retrieveContent();
      if (result != null) {
        results.add(result);
        print("rez: $result");
      } else {
        _isContent = false;
        break;
      }
    }

    await _precacheImages(results);
    setState(() {
      _loadedContent.clear();
      _loadedContent.addAll(results);
      _isLoadingMore = false;
      firstTimeVisit = false;
    });
  }

  Future<void> _loadMoreContent() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final List<T> results = [];
    for (int i = 0; i < 15; i++) {
      final result = await widget.retrieveContent();
      if (result == null) {
        _isContent = false;
        break;
      }
      results.add(result);
    }

    await _precacheImages(results);
    setState(() {
      _loadedContent.addAll(results);
      _isLoadingMore = false;
    });
  }

  Future<void> _precacheImages(List<T> content) async {
    for (var element in content) {
      await widget.precachingStrategy?.call(element, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        print("refresh");
        await _loadInitialContent();  // Reload content without clearing the list
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _loadedContent.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isLoadingMore && index == _loadedContent.length) {
            return Center(child: CircularProgressIndicator());
          }
          return widget.buildItem(_loadedContent[index], context);
        },
      ),
    );
  }
}



class GenericContentPage2<T> extends StatefulWidget {
  final Stream<List<T>> Function() retrieveContent; // Zmiana na Stream
  final Widget Function(T, BuildContext) buildItem;
  final Future<void>? Function(T, BuildContext) precachingStrategy;

  GenericContentPage2({
    super.key,
    required this.retrieveContent,
    required this.buildItem,
    required this.precachingStrategy,
  });

  @override
  _GenericContentPage2State<T> createState() => _GenericContentPage2State<T>();
}

class _GenericContentPage2State<T> extends State<GenericContentPage2<T>> {
  late Stream<List<T>> postsStream;
  List<T> loadedItems = [];  // Przechowywanie danych w stanie

  @override
  void initState() {
    super.initState();
    postsStream = widget.retrieveContent();  // Zmienione na Stream<List<T>>
  }

  Future<void> _refreshPosts() async {
    setState(() {
      loadedItems.clear();
    });
    // Odświeżamy dane
    postsStream = widget.retrieveContent();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: StreamBuilder<List<T>>(
        stream: postsStream,  // Słuchamy Stream<List<T>>
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && loadedItems.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            // Ładujemy wszystkie elementy na raz
            loadedItems = snapshot.data!;
            return ListView.builder(
              itemCount: loadedItems.length,
              itemBuilder: (context, index) {
                return widget.buildItem(loadedItems[index], context);
              },
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

// class GenericContentPage2<T> extends StatefulWidget {
//   final Future<List<T>> Function() retrieveContent;
//   final Widget Function(T, BuildContext) buildItem;
//   final Future<void>? Function(T, BuildContext) precachingStrategy;
//
//   GenericContentPage2({
//     super.key,
//     required this.retrieveContent,
//     required this.buildItem,
//     required this.precachingStrategy,
//   });
//
//   @override
//   _GenericContentPage2State<T> createState() => _GenericContentPage2State<T>();
// }
//
// class _GenericContentPage2State<T> extends State<GenericContentPage2<T>> {
//   late Future<List<T>> postsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     postsFuture = widget.retrieveContent();
//   }
//
//   // Funkcja wywoływana podczas pull-to-refresh
//   Future<void> _refreshPosts() async {
//     setState(() {
//       postsFuture = widget.retrieveContent();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Posts')),
//       body: RefreshIndicator(
//         onRefresh: _refreshPosts, // Używamy RefreshIndicator do wywołania _refreshPosts
//         child: FutureBuilder<List<T>>(
//           future: postsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Błąd: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('Brak danych'));
//             } else {
//               // Budowanie listy elementów
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   T post = snapshot.data![index];
//                   return widget.buildItem(post, context);
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }