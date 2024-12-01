import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Pages/config/scrolling_treshholds.dart';

import '../Models/Trip/trip_master.dart';
import 'config/trip_page_build_config.dart';
import 'generic_content_page.dart';

class TripsPage extends StatefulWidget {
  static final GlobalKey<_TripsPageState> tripsPageKey =
      GlobalKey<_TripsPageState>();

  const TripsPage({Key? key}) : super(key: key);

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();

  late GenericContentPage<TripMaster> content;

  @override
  void initState() {
    super.initState();
    content = GenericContentPage(
      refreshIndicatorKey: refreshIndicatorKey,
      scrollTresholdFunction: getLinearThreshold,
      precachingStrategy: TripPageBuildConfig.cachingStrategy,
      retrieveContent: TripPageBuildConfig.retrieveElement,
      buildItem: TripPageBuildConfig.buildItem,
      scrollController: _scrollController,
    );
  }

  void scrollToTop() {
    if (_scrollController.position.pixels == 0) {
      refreshIndicatorKey.currentState?.show();
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
