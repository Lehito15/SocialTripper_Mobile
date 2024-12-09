import 'package:flutter/material.dart';


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
  List<T> loadedItems = []; // Przechowywanie danych w stanie
  final Set<T> cachedItems = {}; // Śledzenie przetworzonych elementów

  @override
  void initState() {
    super.initState();
    postsStream = widget.retrieveContent(); // Zmienione na Stream<List<T>>
  }

  Future<void> _refreshPosts() async {
    setState(() {
      loadedItems.clear();
      cachedItems.clear(); // Czyścimy cache, gdy dane są odświeżane
    });
    postsStream = widget.retrieveContent();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: StreamBuilder<List<T>>(
        stream: postsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && loadedItems.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            loadedItems = snapshot.data!;
            return ListView.builder(
              itemCount: loadedItems.length,
              itemBuilder: (context, index) {
                final item = loadedItems[index];

                if (!cachedItems.contains(item)) {
                  cachedItems.add(item);
                  widget.precachingStrategy(item, context);
                }

                return widget.buildItem(item, context);
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