import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Shared/page_tab.dart';

class GenericContentPage2<T> extends StatefulWidget {
  final Stream<List<T>> Function() retrieveContent; // Zmiana na Stream
  final Widget Function(T, BuildContext) buildItem;
  final Future<void>? Function(T, BuildContext) precachingStrategy;
  final List<PageTab<T>> tabs;

  GenericContentPage2({
    super.key,
    required this.retrieveContent,
    required this.buildItem,
    required this.precachingStrategy,
    required this.tabs,
  });

  @override
  _GenericContentPage2State<T> createState() => _GenericContentPage2State<T>();
}

class _GenericContentPage2State<T> extends State<GenericContentPage2<T>> {
  late final List<StreamController<List<T>>>
      _tabControllers; // List to hold StreamControllers for each tab
  late final List<Stream<List<T>>> _tabStreams;
  bool _isLoading = false;
  Set<T> cached = {};
  List<T> allItems = [];
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    _tabControllers = List.generate(
        widget.tabs.length, (index) => StreamController<List<T>>());
    _tabStreams =
        _tabControllers.map((controller) => controller.stream).toList();

    // Na starcie załaduj dane
    _refreshPosts();
  }

  Future<void> _refreshPosts() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true; // Rozpoczynamy ładowanie
    });

    // Oczekiwanie na dane z backendu
    final stream = widget.retrieveContent();

    await for (var data in stream) {
      setState(() {
        allItems = data;
        _filterItems();
      });
    }
    _isLoading = false;
  }

  void _filterItems() {
    final filtered = allItems
        .where((item) => widget.tabs[_currentTab].filterPredicate(item))
        .toList();

    _tabControllers[_currentTab].sink.add(filtered);
  }

  void _onChangeTab(int index) {
    setState(() {
      _currentTab = index;
    });
    _filterItems();
  }

  @override
  void dispose() {
    // Ensure all controllers are closed when the widget is disposed
    for (var controller in _tabControllers) {
      controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget sliverAppBar = SliverAppBar(
      expandedHeight: 90.0,
      floating: true,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        background: TabsWidget(),
      ),
    );
    return RefreshIndicator(
      onRefresh: _refreshPosts,
      child: IndexedStack(
        index: _currentTab, // Active tab
        children: List.generate(widget.tabs.length, (index) {
          return StreamBuilder<List<T>>(
            stream: _tabStreams[index],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting &&
                  (!snapshot.hasData || snapshot.data!.isEmpty)) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final filteredItems = snapshot.data!;
                return CustomScrollView(
                  physics: ClampingScrollPhysics(), // Custom scroll physics
                  slivers: [
                    sliverAppBar,
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filteredItems[index];
                          if (!cached.contains(item)) {
                            widget.precachingStrategy(item, context);
                            cached.add(item);
                          }
                          return widget.buildItem(item, context);
                        },
                        childCount: filteredItems.length,
                      ),
                    ),
                  ],
                );
              } else {
                return CustomScrollView(
                  physics: ClampingScrollPhysics(), // Custom scroll physics
                  slivers: [
                    sliverAppBar,
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "No content found",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }
            },
          );
        }),
      ),
    );
  }

  Widget TabsWidget() {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 9, top: 9),
            child: Text(
              "Feeds",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          Row(
            children: widget.tabs
                .asMap()
                .entries
                .map(
                  (entry) => TabButton(
                    entry.value.name,
                    _currentTab == entry.key,
                    () => _onChangeTab(entry.key),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget TabButton(String name, bool isActive, void Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(left: 9, top: 9, bottom: 9),
        child: Container(
          height: 28,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: isActive
                    ? Color(0xffBDF271)
                    : Colors.black.withOpacity(0.5),
                offset: Offset(0, 0),
                blurRadius: 2.0,
                spreadRadius: isActive ? 2 : 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isActive
                        ? Color(0xffBDF271)
                        : Colors.black.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
