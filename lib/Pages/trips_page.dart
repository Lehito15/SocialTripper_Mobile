import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Shared/page_tab.dart';
import 'package:social_tripper_mobile/Pages/config/scrolling_treshholds.dart';
import 'package:social_tripper_mobile/Repositories/trip_repository.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';

import '../Models/Trip/trip_master.dart';
import 'config/data_retrieving_config.dart';
import 'config/trip_page_build_config.dart';
import 'generic_content_page.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  _TripsPageState createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final ScrollController _scrollController = ScrollController();

  late GenericContentPage2<TripMaster> content;

  Future<void> placeholderOnRefresh() async {
    await Future.value(0);
  }

  @override
  void initState() {
    super.initState();
    TripService service = TripService();
    // content = GenericContentPage(
    //   onRefresh: TripRepository.initialize,
    //   scrollTresholdFunction: getLinearThreshold,
    //   precachingStrategy: TripPageBuildConfig.cachingStrategy,
    //   retrieveContent: TripPageBuildConfig.retrieveBackendElement,
    //   buildItem: TripPageBuildConfig.buildItem,
    //   scrollController: _scrollController,
    // );
    content = GenericContentPage2(
      retrieveContent: service.loadAllTripsStream,
      buildItem: TripPageBuildConfig.buildItem,
      precachingStrategy: TripPageBuildConfig.cachingStrategy,
      tabs: [
        PageTab<TripMaster>("All trips", (TripMaster trip) => true),
        PageTab<TripMaster>("Owned trips", (TripMaster trip) => trip.isOwner),
        PageTab<TripMaster>("Joined trips", (TripMaster trip) => trip.isMember),
        // PageTab<TripMaster>("Requested trips", (TripMaster trip) => trip.isRequested),
      ],
    );
  }

  void scrollToTop() {
    if (_scrollController.position.pixels == 0) {
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
