import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_tripper_mobile/Components/Post/BuildingBlocks/post_photo.dart';
import 'package:social_tripper_mobile/Components/Shared/posted_entity_author_info.dart';
import 'package:social_tripper_mobile/Components/Shared/profile_thumbnail.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_multimedia.dart';
import 'package:social_tripper_mobile/Pages/Relation/my_marker.dart';
import 'package:social_tripper_mobile/Pages/TripDetail/Subpages/trip_detail_details.dart';
import 'package:social_tripper_mobile/Utilities/Converters/distance_converter.dart';

import '../../Services/relation_service.dart';
import '../config/relation_page_build.dart';
import '../generic_content_page.dart';

class RelationsPage extends StatefulWidget {
  const RelationsPage({super.key});

  @override
  State<RelationsPage> createState() => _RelationsPageState();
}

class _RelationsPageState extends State<RelationsPage> {
  late GenericContentPage2<List<TripMultimedia>> content;

  @override
  void initState() {
    RelationService service = RelationService();
    content = GenericContentPage2(
        retrieveContent: service.getAllRelationsStream,
        buildItem: RelationPageBuildConfig.buildItem,
        precachingStrategy: RelationPageBuildConfig.cachingStrategy);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}

class Relation extends StatefulWidget {
  const Relation({super.key, required this.relation});

  final List<TripMultimedia> relation;

  @override
  State<Relation> createState() => _RelationState();
}

class _RelationState extends State<Relation> with TickerProviderStateMixin {
  late List<TripMultimedia> _relation;
  late PageController _pageController;
  late LatLng _mapCenter;
  late AnimatedMapController _animatedMapController;
  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _relation = widget.relation;
    _pageController = PageController();
    _mapCenter = LatLng(_relation[0].latitude, _relation[0].longitude);
    _animatedMapController = AnimatedMapController(vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final newCenter = LatLng(
      _relation[index].latitude,
      _relation[index].longitude,
    );

    setState(() {
      activeIndex = index;
    });

    _animatedMapController.animateTo(
      dest: newCenter,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onMarkerTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            RelationProfileThumbnail(
              "test",
              "https://picsum.photos/id/237/200/300",
              4,
              DateTime(2024, 12, 12, 12, 12),
              DateTime(2024, 12, 12, 12, 12),
            ),
            RelationSlider(
              pageController: _pageController,
              onPageChanged: _onPageChanged,
              testMultimedia: _relation, // Przekazujemy multimedia do slidera
            ),
            TripLocationsMap(
                points: _relation,
                mapCenter: _mapCenter,
                mapController: _animatedMapController.mapController,
                pageController: _pageController,
                onMarkerTapped: _onMarkerTapped,
                activeIndex: activeIndex),
            // Przekazujemy mapę z danymi i współrzędnymi
          ],
        ),
      ],
    );
  }
}

class RelationSlider extends StatefulWidget {
  final PageController pageController;
  final Function(int) onPageChanged;
  final List<TripMultimedia>
      testMultimedia; // Lista multimediów, która jest przekazywana

  const RelationSlider({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.testMultimedia, // Dodajemy parametr
  });

  @override
  State<RelationSlider> createState() => _RelationSliderState();
}

class _RelationSliderState extends State<RelationSlider> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Stack(
        children: [
          PageView.builder(
            controller: widget.pageController,
            itemCount: widget.testMultimedia.length,
            onPageChanged: widget.onPageChanged,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.testMultimedia[index].multimediaUrl,
                fit: BoxFit.fitHeight,
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                if (widget.pageController.page != null &&
                    widget.pageController.page! > 0) {
                  widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
              },
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () {
                if (widget.pageController.page != null &&
                    widget.pageController.page! <
                        widget.testMultimedia.length - 1) {
                  widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TripLocationsMap extends StatefulWidget {
  final List<TripMultimedia> points;
  final LatLng mapCenter;
  final MapController mapController;
  final PageController pageController;
  final Function(int) onMarkerTapped;
  final int activeIndex;

  const TripLocationsMap({
    super.key,
    required this.points,
    required this.mapCenter,
    required this.mapController,
    required this.pageController,
    required this.onMarkerTapped,
    required this.activeIndex,
  });

  @override
  _TripLocationsMapState createState() => _TripLocationsMapState();
}

class _TripLocationsMapState extends State<TripLocationsMap> {
  late LatLng _mapCenter;

  @override
  void initState() {
    super.initState();
    // Ustawienie początkowego środka mapy
    _mapCenter = widget.mapCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          initialCenter: _mapCenter, // Używamy dynamicznego środka mapy
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: widget.points.map((point) {
              int index = widget.points.indexOf(point);
              return Marker(
                alignment: Alignment.topCenter,
                width: 50,
                height: 50,
                point: LatLng(point.latitude, point.longitude),
                child: GestureDetector(
                  onTap: () {
                    widget.pageController.jumpToPage(index);
                  },
                  child: MyMarker(
                    mediaPath: point.multimediaUrl,
                    isActive: widget.activeIndex == index,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
