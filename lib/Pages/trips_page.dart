import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../Components/TripMaster/trip_master.dart';
import '../Models/Trip/trip_master.dart';
import '../Utilities/DataGenerators/Trip/trip_generator.dart';




class TripsPage extends StatefulWidget {
  static final GlobalKey<_TripsPageState> tripsPageKey =
      GlobalKey<_TripsPageState>();
  static final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  const TripsPage({Key? key}) : super(key: key);

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage>
    with AutomaticKeepAliveClientMixin {
  final List<TripMaster?> _loadedTrips = [];
  final ScrollController _scrollController = ScrollController();
  Map<int, Widget> _memoizedTripWidgets = {};

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

  Future<void> _precacheImages(List<TripMaster?> trips) async {
    for (int i = 0; i < trips.length; i++) {
      final trip = trips[i];
      if (trip?.photoUri != null && trip!.photoUri!.isNotEmpty) {
        final imageProvider = CachedNetworkImageProvider(trip.photoUri!);

        // Preładowanie obrazu z zachowaniem kolejności
        await precacheImage(imageProvider, context);

        // Można również opcjonalnie logować, które zdjęcie zostało załadowane
      }
    }
  }

  void scrollToTop() {
    if (_scrollController.offset == 0) {
      TripsPage.refreshIndicatorKey.currentState?.show();
    }

    _scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadInitialContent() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Zbieramy pierwsze trzy tripy do priorytetowego załadowania
    final List<Future<TripMaster>> priorityTrips = List.generate(
      2, // Tylko 1 pierwsze tripy
          (_) => TripGenerator.generateTripMaster(),
    );

    // Ładujemy priorytetowe tripy
    final List<TripMaster?> priorityResults = await Future.wait(priorityTrips);

    // Preładowanie zdjęć dla pierwszych 3 tripów
    await _precacheImages(priorityResults);

    // Zbieramy resztę tripów, które załadujemy po wczytaniu 3 pierwszych
    final List<Future<TripMaster>> otherTrips = List.generate(
      initialLoadCount - 2, // Reszta tripów
          (_) => TripGenerator.generateTripMaster(),
    );

    // Ładujemy pozostałe tripy po załadowaniu priorytetowych
    final List<TripMaster?> otherResults = await Future.wait(otherTrips);

    // Łączymy wyniki
    final allResults = [...priorityResults, ...otherResults];

    setState(() {
      _loadedTrips
        ..clear()
        ..addAll(allResults);
      _isLoading = false;
      _memoizedTripWidgets.clear();
    });

    // Preładowanie obrazów, dla reszty tripów
    _precacheImages(otherResults);
  }

  Future<void> _loadMoreContent() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final List<Future<TripMaster>> newTrips = List.generate(
      incrementLoadCount,
      (_) => TripGenerator.generateTripMaster(),
    );

    final List<TripMaster?> results = await Future.wait(newTrips);

    setState(() {
      _loadedTrips.addAll(results);
      _isLoadingMore = false;
    });

    // Preładowanie obrazów po załadowaniu nowych tripów
    _precacheImages(results);
  }


  double getLinearThreshold(int x, int maxX) {
    // Obliczamy próg procentowy w sposób liniowy
    double threshold = 50 + (49 / maxX) * x;

    // Ograniczamy wynik do 99%, aby nie przekroczyć tego progu
    return threshold.clamp(50.0, 95.0);
  }

  void _scrollListener() {
    // Załóżmy, że maxX to maksymalna liczba elementów, które spodziewasz się mieć w przyszłości
    const maxX = 400;

    // Obliczamy próg procentowy, przy którym nowe dane mają być załadowane
    double threshold = getLinearThreshold(_loadedTrips.length, maxX);

    // Sprawdzamy, czy przewinięto wystarczająco daleko
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * (threshold / 100) &&
        !_isLoading) {
      _loadMoreContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      key: TripsPage.refreshIndicatorKey,
      onRefresh: _loadInitialContent,
      child: _isLoading && _loadedTrips.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
        shrinkWrap: false,
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (_isLoadingMore && index == _loadedTrips.length) {
                  return Center(child: CircularProgressIndicator());
                }

                // Memoization: Zapamiętaj wygenerowane widoki
                return _buildTripItem(index);
              },
              childCount: _loadedTrips.length + (_isLoadingMore ? 1 : 0),
            ),
          ),
        ],
        cacheExtent: 10000,
      ),
    );
  }

  Widget _buildTripItem(int index) {
    final trip = _loadedTrips[index];
    if (trip == null) {
      return const Center(child: Text("Error loading trip"));
    }

    if (!_memoizedTripWidgets.containsKey(index)) {
      _memoizedTripWidgets[index] = TripMasterView(
        trip,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: _memoizedTripWidgets[index]!,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
