import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../components/trip_interface/camera.dart';
import '../components/trip_interface/marker.dart';


class TripInterface extends StatefulWidget {
  const TripInterface({super.key});

  @override
  State<TripInterface> createState() => _TripInterfaceState();
}


class _TripInterfaceState extends State<TripInterface> {
  bool _isStartButtonVisible = true;
  String locationMessage = 'Current Location of the User';
  String lat="";
  String long="";
  int _counter = 0;
  List<LatLng> routeCoordinates = [];
  LatLng? lastPosition;
  List<LatLng> positionPack = [];
  List<double> speedPack = [];
  DateTime lastUpdateTime = DateTime.now();

  double lastTime = DateTime.now().millisecondsSinceEpoch / 1000.0;

  double speedLimit = 1;
  int distanceLimit = 20;
  int timeLimit = 10;

  bool hasAccelerometer = true;
  double velocity = 0.0;
  double highestVelocity = 0.0;

  List<Marker> markers = [];

  MapController mapController = MapController();

  @override
  void initState() {
    userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    },
      onError: (error) {
        hasAccelerometer = false;
      },
    );
    super.initState();
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z
    );

    // if ((newVelocity - velocity).abs() < 0.1) {
    //   return;
    // }

    setState(() {
      velocity = newVelocity;

      if (velocity > highestVelocity) {
        highestVelocity = velocity;
      }
    });
    // print(velocity);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Location service enabled: $serviceEnabled');
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print('Initial permission status: $permission');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print('Permission after request: $permission');
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Permission denied forever');
      return Future.error('Location permissions are permanently denied, we cannot request permission');
    }

    print('Getting current position...');
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _openCamera() async {
    final String? mediaPath = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(),
      ),
    );

    if (mediaPath != null) {
      _addMarker(mediaPath);
    }
  }

  Future<Uint8List?> generateThumbnail(String mediaPath) async {
    if (mediaPath.endsWith('.mp4')) {
      return await VideoThumbnail.thumbnailData(
        video: mediaPath,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
      );
    } else {
      return File(mediaPath).readAsBytesSync();
    }
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      DateTime currentTime = DateTime.now();
      LatLng tempLatLng = LatLng(position.latitude, position.longitude);
      positionPack.add(tempLatLng);
      if (hasAccelerometer) {
        speedPack.add(velocity);
      } else {
        speedPack.add(position.speed);
      }
      // print(tempLatLng);
      // print(position.speed);
      if (currentTime.difference(lastUpdateTime).inSeconds >= timeLimit) {
        LatLng currentPosition = calculateAverageLocation(positionPack);
        double speedAvg = calculateAverageList(speedPack);
        print(positionPack);
        print(speedAvg);
        positionPack = [];
        speedPack = [];

        setState(() {
          lat = currentPosition.latitude.toString();
          long = currentPosition.longitude.toString();
          locationMessage = 'Latitude: $lat, Longitude: $long';
        });

        if (lastPosition != null) {
          double distance = Geolocator.distanceBetween(
            lastPosition!.latitude,
            lastPosition!.longitude,
            currentPosition.latitude,
            currentPosition.longitude,
          );
          if (distance >= distanceLimit && (speedAvg > speedLimit || speedAvg == 0)) {
            setState(() {
              lastUpdateTime = currentTime;
              routeCoordinates.add(currentPosition);
              lastPosition = currentPosition;
            });
          } else {
            lastUpdateTime = currentTime;
          }
        } else {
          setState(() {
            lastUpdateTime = currentTime;
            routeCoordinates.add(currentPosition);
            lastPosition = currentPosition;
          });
        }
      }
    });
  }

  LatLng calculateAverageLocation(List<LatLng> coordinates) {
    if (coordinates.isEmpty) {
      throw ArgumentError('The list of coordinates cannot be empty');
    }

    double sumLat = 0;
    double sumLng = 0;

    for (var coord in coordinates) {
      sumLat += coord.latitude;
      sumLng += coord.longitude;
    }

    double avgLat = sumLat / coordinates.length;
    double avgLng = sumLng / coordinates.length;

    return LatLng(avgLat, avgLng);
  }

  LatLng _getSmoothedPosition(LatLng lastPos, LatLng currentPos) {
    double smoothedLat = (lastPos.latitude + currentPos.latitude) / 2;
    double smoothedLong = (lastPos.longitude + currentPos.longitude) / 2;
    return LatLng(smoothedLat, smoothedLong);
  }

  double calculateAverageList(List<double> list) {
    if (list.isEmpty) {
      throw ArgumentError('The list of coordinates cannot be empty');
    }

    double sum = 0;
    for (var elem in list) {
      sum += elem;
    }

    return sum / list.length;
  }

  void _addMarker(String? mediaPath) async{
    Uint8List? thumbnail = await generateThumbnail(mediaPath!);
    setState(() {
      if (lat.isNotEmpty && long.isNotEmpty) {
        markers.add(
          Marker(
            alignment: Alignment.topCenter,
            width: 75.0,
            height: 70.0,
            point: LatLng(double.parse(lat), double.parse(long)),
            child: CustomMarker(mediaPath: mediaPath, thumbnail: thumbnail,),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('SOCIAL TRIPPER'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(locationMessage, textAlign: TextAlign.center),
                  if (_isStartButtonVisible)
                    ElevatedButton(
                      onPressed: () {
                        _getCurrentLocation().then((value) {
                          print('Button pressed! Attempting to get location...');
                          lat = '${value.latitude}';
                          long = '${value.longitude}';
                          setState(() {
                            locationMessage = 'Latitude: $lat, Longitude: $long';
                            _isStartButtonVisible = false;
                          });

                          mapController.move(LatLng(value.latitude, value.longitude), 17.0);

                          _liveLocation();
                        });
                      },
                      child: const Text("Start trip"),
                    ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 300,
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: LatLng(50.911, 15.755),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routeCoordinates, // Lista punktów trasy
                          strokeWidth: 4.0,
                          color: Colors.blue, // Kolor linii
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        if (lat.isNotEmpty && long.isNotEmpty)
                          Marker(
                            width: 25.0,
                            height: 25.0,
                            point: LatLng(double.parse(lat), double.parse(long)),
                            child: Icon(
                              Icons.circle,
                              color: Colors.lightBlue,
                              size: 20,
                            ),
                          ),
                      ] + markers,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30.0), // Dodaj odstęp od dołu
          child: !_isStartButtonVisible
              ? FloatingActionButton(
            onPressed: _openCamera,
            tooltip: 'Add photo or video',
            child: const Icon(Icons.add),
          )
              : null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
}