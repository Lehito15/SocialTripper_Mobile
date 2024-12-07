import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_master.dart';
import 'package:social_tripper_mobile/Models/Trip/trip_status.dart';
import 'package:social_tripper_mobile/Services/trip_service.dart';
import '../Components/TripInterface/camera.dart';
import '../Components/TripInterface/marker.dart';
import '../Models/Trip/trip_multimedia.dart';
import '../Services/account_service.dart';
import '../Utilities/Tasks/location_task.dart';
import '../Utilities/Server/web_socket_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';


class TripInterface extends StatefulWidget {
  final bool isOwner;
  final TripMaster trip;


  TripInterface({required this.isOwner, required this.trip});

  @override
  State<TripInterface> createState() => _TripInterfaceState();
}

class _TripInterfaceState extends State<TripInterface> {
  // @override
  // bool get wantKeepAlive => true;
  late bool isLeader;
  late String tripId;

  final String serverAddress = 'ws://156.17.237.132:8080';
  final WebSocketClient client = WebSocketClient('ws://156.17.237.132:8080');
  String lastReceivedId = '0';
  List<String> receivedIds = [];

  bool isTripNotStarted = true;
  String locationMessage = 'Current Location of the User';
  String lat = "";
  String long = "";
  String leaderLat = "";
  String leaderLong = "";
  int _counter = 0;
  List<LatLng> routeCoordinates = [];
  LatLng? lastPosition;
  List<LatLng> positionPack = [];
  List<double> speedPack = [];
  DateTime lastUpdateTime = DateTime.now();

  double lastTime = DateTime
      .now()
      .millisecondsSinceEpoch / 1000.0;

  double speedLimit = 0.8;
  int distanceLimit = 25;
  int maxDistanceLimit = 1;
  int timeLimit = 10;

  bool hasAccelerometer = true;
  double velocity = 0.0;
  double highestVelocity = 0.0;

  List<Marker> markers = [];
  MapController mapController = MapController();

  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<Position>? _positionSubscription;

  final _messageQueue = StreamController<Map<String, dynamic>>(); // Kolejka wiadomości
  bool _isProcessingMessage = false;

  @override
  void initState() {
    super.initState();

    tripId = widget.trip.uuid;
    isLeader = widget.isOwner;

    print("czarnuch: ${widget.trip}");
    setupMessageHandler();

    loadState().then((value) {
      if (!isTripNotStarted) {
        if (isLeader) {
          startAsLeader();
          _liveLocation();
        }
        else {
          startAsParticipant();
          _liveLocation();
        }
      }
    });
    _accelerometerSubscription = userAccelerometerEventStream().listen(
          (UserAccelerometerEvent event) {
        _onAccelerate(event);
      },
      onError: (error) {
        hasAccelerometer = false;
      },
    );
  }



  void setupMessageHandler() {
    _messageQueue.stream.listen((message) async {
      if (_isProcessingMessage) return; // Sprawdzamy, czy już coś przetwarzamy
      _isProcessingMessage = true;

      try {
        await _processMessage(message); // Procesujemy wiadomość
      } catch (e) {
        print("Error processing message: $e");
      } finally {
        _isProcessingMessage = false;
      }
    });
  }

  Future<void> _processMessage(Map<String, dynamic> data) async {
    print("Processing message: $data");

    if (data['type'] == 'new_media') {
      final receivedId = data['id'];
      final filePath = data['filePath'];
      final markerLat = data['lat'];
      final markerLong = data['long'];

      if (!receivedIds.contains(receivedId)) {
        receivedIds.add(receivedId);
        lastReceivedId = receivedId;

        try {
          final uri = Uri.parse("http://156.17.237.132:8000$filePath");
          final response = await http.get(uri);

          if (response.statusCode == 200) {
            final directory = await getTemporaryDirectory();
            final fileName = uri.pathSegments.last;
            final localPath = "${directory.path}/$fileName";
            final file = File(localPath);
            await file.writeAsBytes(response.bodyBytes);
            _addMarker(localPath, LatLng(double.parse(markerLat), double.parse(markerLong)));
          } else {
            print("Failed to download media: ${response.statusCode}");
          }
        } catch (e) {
          print("Error downloading media: $e");
        }
      }

      await saveState(); // Zapisujemy stan
    }
  }



  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();

    // Zapisanie widoczności przycisku
    await prefs.setBool('isTripNotStarted', isTripNotStarted);
    await prefs.setString('lat', lat);
    await prefs.setString('long', long);

    await prefs.setString('lastReceivedId', lastReceivedId);
    await prefs.setStringList('receivedIds', receivedIds);


    // Zapisanie koordynatów trasy jako JSON
    final routeCoords = routeCoordinates
        .map((coord) => {'lat': coord.latitude, 'lng': coord.longitude})
        .toList();
    await prefs.setString('routeCoordinates', jsonEncode(routeCoords));

    // Zapisanie ścieżek multimediów
    final mediaPaths = markers
        .map((marker) => marker.child) // Pobierz dziecko Marker
        .whereType<CustomMarker>() // Filtruj tylko CustomMarker
        .map((customMarker) => customMarker.mediaPath) // Pobierz mediaPath
        .toList();
    await prefs.setStringList('mediaPaths', mediaPaths);

    final markerLocations = markers.map((marker) {
      return {'lat': marker.point.latitude, 'lng': marker.point.longitude};
    }).toList();
    await prefs.setString('markerLocations', jsonEncode(markerLocations));
  }

  Future<void> loadState() async {
    final prefs =  await SharedPreferences.getInstance();

    isTripNotStarted = prefs.getBool('isTripNotStarted') ?? true;
    lat = prefs.getString('lat') ?? "";
    long = prefs.getString('long') ?? "";

    lastReceivedId = prefs.getString('lastReceivedId') ?? "0";
    receivedIds = prefs.getStringList('receivedIds') ?? [];

    if (lat.isNotEmpty && long.isNotEmpty) {
      mapController.move(LatLng(double.parse(lat), double.parse(long)), 17.0);
    }


    final routeCoordsString = prefs.getString('routeCoordinates');
    if (routeCoordsString != null) {
      final routeCoords = jsonDecode(routeCoordsString) as List<dynamic>;
      routeCoordinates = routeCoords
          .map((coord) => LatLng(coord['lat'], coord['lng']))
          .toList();
    }
    final markerLocationsString = prefs.getString('markerLocations');
    List<LatLng> markerLocations = [];
    if (markerLocationsString != null) {
      final locations = jsonDecode(markerLocationsString) as List<dynamic>;
      markerLocations = locations
          .map((loc) => LatLng(loc['lat'], loc['lng']))
          .toList();
    }
    final mediaPaths = prefs.getStringList('mediaPaths') ?? [];
    for (final pair in IterableZip([mediaPaths, markerLocations])) {
      _addMarker(pair[0] as String, pair[1] as LatLng);
    }
  }

  @override
  void dispose() {
    // Anulowanie subskrypcji, gdy widget jest usuwany z drzewa
    saveState();
    print("Disposed");
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void start() {
    print("start metrdasdad");
    setState(() {
      tripId = widget.trip.uuid;
      isLeader = widget.isOwner;
    });
  }

  void startAsLeader() {

    // Połączenie z serwerem WebSocket jako lider
    client.connect().then((_) {
      print('Connected to WebSocket server as Leader.');

      // Wysyłanie pozycji lidera co 5 sekund
      Timer.periodic(Duration(seconds: 5), (timer) {
        final leaderPositionUpdate = jsonEncode({
          'trip_id': tripId,
          'type': 'leader_position',
          'lat': lat,
          'long': long,
        });
        client.sendMessage(leaderPositionUpdate);
      });

      final syncMessage = jsonEncode({
        'trip_id': tripId,
        "type": "sync_media",
        "last_id": lastReceivedId,
      });
      client.sendMessage(syncMessage);
    });

    monitorConnectivity(client);

    // Obsługa przychodzących wiadomości
    // client.onMessage((message) {
    //   final data = jsonDecode(message);
    //
    //   if (data['type'] == 'request_route') {
    //     // Klient prosi o trasę
    //     final routeUpdate = jsonEncode({
    //       'type': 'route_update',
    //       'routeCoordinates': routeCoordinates
    //           .map((coord) => {'lat': coord.latitude, 'lng': coord.longitude})
    //           .toList(),
    //     });
    //     client.sendMessage(routeUpdate);
    //   }
    // });

    client.onMessage((message) async {
      print("Received message: $message");
      final data = jsonDecode(message);

      // Dodajemy wiadomość do kolejki
      _messageQueue.add(data);
    });

    // client.onMessage((message) async {
    //   print(message);
    //   final data = jsonDecode(message);
    //   print("kkakak-5");
    //   if (data['type'] == 'new_media') {
    //     final receivedId = data['id'];
    //     final filePath = data['filePath'];
    //     final markerLat = data['lat'];
    //     final markerLong = data['long'];
    //     print("kkakak-4");
    //     if (!receivedIds.contains(receivedId)) {
    //       receivedIds.add(receivedId);
    //       lastReceivedId = receivedId;
    //       print("kkakak-3");
    //       try {
    //         final uri = Uri.parse("http://156.17.237.132:8000$filePath");
    //         print("kkakak-2");
    //         final response = await http.get(uri);
    //         print("kkakak-1");
    //         if (response.statusCode == 200) {
    //           print("kkakak0");
    //           final directory = await getTemporaryDirectory();
    //           print("kkakak1");
    //           final fileName = uri.pathSegments.last;
    //           final localPath = "${directory.path}/$fileName";
    //           print("kkakak2");
    //           final file = File(localPath);
    //           print("kkakak3");
    //           await file.writeAsBytes(response.bodyBytes);
    //           print("kkakak4");
    //           _addMarker(localPath, LatLng(double.parse(markerLat), double.parse(markerLong)));
    //         } else {
    //           print("Failed to download media: ${response.statusCode}");
    //           return null;
    //         }
    //       } catch (e) {
    //         print("Error downloading media: $e");
    //         return null;
    //       }
    //     }
    //     saveState();
    //   }
    // });
  }

  void startAsParticipant() {
    client.connect().then((_) {
      print('Connected to WebSocket server as participant.');

      final syncMessage = jsonEncode({
        'trip_id': tripId,
        "type": "sync_media",
        "last_id": lastReceivedId,
      });
      client.sendMessage(syncMessage);
    });

    monitorConnectivity(client);

    client.onMessage((message) async {
      final data = jsonDecode(message);

      // if (data['type'] == 'route_update') {
      //   // Aktualizacja trasy
      //   final routeCoordinates = (data['routeCoordinates'] as List)
      //       .map((coord) => LatLng(coord['lat'], coord['lng']))
      //       .toList();
      //   setState(() {
      //     this.routeCoordinates = routeCoordinates;
      //   });
      // }

      if (data['type'] == 'leader_position') {
        // Aktualizacja pozycji lidera
        setState(() {
          leaderLat = data['lat'];
          leaderLong = data['long'];
        });
      }

      if (data['type'] == 'stop_trip') {
        stopClient();
      }

      if (data['type'] == 'new_media') {
        final receivedId = data['id'];
        final filePath = data['filePath'];
        final markerLat = data['lat'];
        final markerLong = data['long'];

        if (!receivedIds.contains(receivedId)) {
          receivedIds.add(receivedId);
          lastReceivedId = receivedId;

          try {
            final uri = Uri.parse("http://156.17.237.132:8000$filePath");
            final response = await http.get(uri);

            if (response.statusCode == 200) {
              final directory = await getTemporaryDirectory();
              final fileName = uri.pathSegments.last;
              final localPath = "${directory.path}/$fileName";

              final file = File(localPath);
              await file.writeAsBytes(response.bodyBytes);
              _addMarker(localPath, LatLng(double.parse(markerLat), double.parse(markerLong)));
            } else {
              print("Failed to download media: ${response.statusCode}");
              return null;
            }
          } catch (e) {
            print("Error downloading media: $e");
            return null;
          }
        }
        saveState();
      }
    });
  }

  void stopAsLeader() {
    final tripService = TripService();
    final stopMessage = jsonEncode({
      'trip_id': tripId,
      "type": "stop_trip",
    });
    client.sendMessage(stopMessage);

    sendFiles();
    tripService.setTripStatus(widget.trip.uuid, TripStatus("finished"));
    stopClient();
  }

  void stopClient() async {
    client.disconnect();
    setState(() {
      isTripNotStarted = true;
      routeCoordinates = [];
      markers = [];
      lat = "";
      long = "";
      leaderLat = "";
      leaderLong = "";
      lastReceivedId = "0";
      receivedIds = [];
    });
    await saveState();
    context.go("/home");
  }

  void monitorConnectivity(WebSocketClient websocketClient) {
    // Nasłuchuj zmian w połączeniach
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        // Użytkownik stracił połączenie z internetem
        print("Lost network connection.");
        websocketClient.disconnect();
      } else {
        // Użytkownik odzyskał połączenie
        print("Network connection restored.");
        if (!websocketClient.isConnected()) {
          websocketClient.connect().then((_) {
            final syncMessage = jsonEncode({
              'trip_id': tripId,
              "type": "sync_media",
              "last_id": lastReceivedId,
            });
            client.sendMessage(syncMessage);
          });
        }
      }
    });
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z
    );

    // if ((newVelocity - velocity).abs() < 0.1) {
    //   return;
    // }

    if (mounted) { // Sprawdzamy, czy widget jest nadal zamontowany, tzn czy nadal włączony jest interfejs
      setState(() {
        velocity = newVelocity;
        speedPack.add(velocity);

        if (velocity > highestVelocity) {
          highestVelocity = velocity;
        }
      });
    }
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permission');
    }


    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      //
      // To restart the service on device reboot or unexpected problem, you need to allow below permission.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }
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
      // _addMarker(mediaPath, LatLng(double.parse(lat), double.parse(long)));
      uploadMedia(mediaPath, lat, long).then((_) {
        print("Media przesłane pomyślnie.");
        saveState();
      }).catchError((error) {
        print("Błąd podczas przesyłania mediów: $error");
      });

    }
  }

  Future<void> uploadMedia(String filePath, String latitude, String longitude) async {
    try {
      final uri = Uri.parse('http://156.17.237.132:8000/upload_media/');
      final request = http.MultipartRequest('POST', uri);

      // Dodaj plik do żądania
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      request.fields['lat'] = latitude;
      request.fields['long'] = longitude;
      request.fields['trip_uuid'] = tripId;
      // Wyślij żądanie
      final response = await request.send();
      // _addMarker(filePath, LatLng(double.parse(latitude), double.parse(longitude)));

      if (response.statusCode == 200) {
        print("File uploaded successfully.");

        final message = jsonEncode({
          'type': 'new_media',
          'filename': filePath.split('/').last,
          'lat': latitude,
          'long': longitude,
        });
        client.sendMessage(message);
      } else {
        print("Failed to upload file. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error uploading file: $e");
    }
  }

  void startForegroundService() async {
    try {
      print("Starting foreground service...");
      await FlutterForegroundTask.startService(
        notificationTitle: 'Tracking Location',
        notificationText: 'Your location is being tracked in the background.',
        callback: startCallback,
      );
      print("Started foreground service");
    } catch (e) {
      print("Error starting foreground service: $e");
    }
  }

  @pragma('vm:entry-point')
  void startCallback() {
    print("startCallback here");
    try {
      FlutterForegroundTask.setTaskHandler(LocationTask());
      print("LocationTask handler set.");
    } catch (e) {
      print("Error setting task handler: $e");
    }
  }

  void stopForegroundService() async {
    await FlutterForegroundTask.stopService();
  }

  void _liveLocation() {
    startForegroundService();
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    _positionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((
        Position position) {
      DateTime currentTime = DateTime.now();
      LatLng tempLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        lat = tempLatLng.latitude.toString();
        long = tempLatLng.longitude.toString();
        //locationMessage = 'Latitude: $lat, Longitude: $long';
        //locationMessage = 'Counter: $_counter';
      });
      positionPack.add(tempLatLng);
      // if (!hasAccelerometer) {
      //   speedPack.add(position.speed);
      // }
      // print(tempLatLng);
      // print(position.speed);
      if (currentTime
          .difference(lastUpdateTime)
          .inSeconds >= timeLimit) {
        LatLng currentPosition = calculateAverageLocation(positionPack);
        double speedAvg = calculateAverageList(speedPack);
        print(positionPack);
        print(speedAvg);
        positionPack = [];
        speedPack = [];
        lastUpdateTime = currentTime;

        if (lastPosition != null) {
          double distance = Geolocator.distanceBetween(
            lastPosition!.latitude,
            lastPosition!.longitude,
            currentPosition.latitude,
            currentPosition.longitude,
          );
          if ((distance >= distanceLimit && speedAvg > speedLimit) ||
              distance >= maxDistanceLimit) {
            setState(() {
              routeCoordinates.add(currentPosition);
              lastPosition = currentPosition;
            });
            saveState();
          }
        } else if (routeCoordinates == []) {
          setState(() {
            routeCoordinates.add(currentPosition);
            lastPosition = currentPosition;
          });
          saveState();
        }
      }
    });
  }

  void _participantLiveLocation() {
    startForegroundService();
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    _positionSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((
        Position position) {
      LatLng tempLatLng = LatLng(position.latitude, position.longitude);
      setState(() {
        lat = tempLatLng.latitude.toString();
        long = tempLatLng.longitude.toString();
        //locationMessage = 'Latitude: $lat, Longitude: $long';
        //locationMessage = 'Counter: $_counter';
      });
    });
  }

  void stopLiveLocation() {
    _positionSubscription?.cancel();
    _positionSubscription = null; // Opcjonalnie ustaw na null dla czytelności.
    stopForegroundService();
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

  double calculateAverageList(List<double> list) {
    if (list.isEmpty) {
      return 0;
    }

    double sum = 0;
    for (var elem in list) {
      sum += elem;
    }

    return sum / list.length;
  }

  void _addMarker(String mediaPath, LatLng coordinates) async {
    Uint8List? thumbnail = await generateThumbnail(mediaPath);
    setState(() {
      markers.add(
        Marker(
          alignment: Alignment.topCenter,
          width: 75.0,
          height: 70.0,
          point: coordinates,
          child: CustomMarker(mediaPath: mediaPath, thumbnail: thumbnail,),
        ),
      );
    }
    );
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

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
        backgroundColor: Color(0xffF0F2F5),
        body: Column(
          children: <Widget>[
            Text(tripId),
            Text("$isLeader"),
            Text("${widget.trip.name}"),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                children: [
                  //debugLocationComponent(locationMessage),
                  if (isTripNotStarted)

                  // wyekstrachowac do komponentow
                    ElevatedButton(
                      onPressed: () {
                        // takie rzeczy na pewno wyekstrahować do osobnych metod
                        _getCurrentLocation().then((value) {
                          lat = '${value.latitude}';
                          long = '${value.longitude}';
                          setState(() {
                            locationMessage =
                            'Latitude: $lat, Longitude: $long';
                            isTripNotStarted = false;
                          });

                          mapController.move(LatLng(value.latitude,
                              value.longitude), 20.0);
                          saveState();
                          start();
                          if (isLeader) {
                            startAsLeader();
                            _liveLocation();
                          }
                          else {
                            startAsParticipant();
                            _liveLocation();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Start trip",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffBDF271)
                        ),
                      ),
                    ),
                  if (!isTripNotStarted)
                    ElevatedButton(
                      onPressed: () {
                        if (client.isConnected() && isLeader) {
                          stopLiveLocation();
                          stopAsLeader();
                        } else if (!isLeader) {
                          stopLiveLocation();
                          stopClient();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: const Text(
                        "End trip",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffBDF271)
                        ),
                      ),
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
                        if (leaderLat.isNotEmpty && leaderLong.isNotEmpty)
                          Marker(
                            width: 25.0,
                            height: 25.0,
                            point: LatLng(double.parse(leaderLat), double.parse(
                                leaderLong)),
                            child: Icon(
                              Icons.circle,
                              color: Colors.yellow,
                              size: 20,
                            ),
                          ),
                        if (lat.isNotEmpty && long.isNotEmpty)
                          Marker(
                            width: 25.0,
                            height: 25.0,
                            point: LatLng(double.parse(lat), double.parse(long)),
                            child: Icon(
                              Icons.circle,
                              color: Colors.blueGrey,
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
          child: !isTripNotStarted
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

  Future<void> sendFiles() async {
    Future.wait(markers.map((m) async {
      final v = m.child as CustomMarker;
      final TripService tripService = TripService();
      final userUUID = await AccountService().getSavedAccountUUID();
      String path = v.getMediaPath;
      TripMultimedia metadata = TripMultimedia(v.getMediaPath, m.point.latitude, m.point.longitude, DateTime.now(), userUUID!, widget.trip.uuid);
      String metadataJson = jsonEncode(metadata);
      try {
        await tripService.uploadEventMultimedia(path, metadataJson);
      } catch (e) {
        print("Error uploading multimedia: $e");
      }
    }));
  }
}


Column debugLocationComponent(String locationMessage) {
  List<String> messages = locationMessage.split(",");
  TextStyle debugLocationMsgStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14
  );
  List<Text> uiMessages = [];
  for (String message in messages) {
    uiMessages.add(Text(
      message,
      style: debugLocationMsgStyle,
    ));
  }
  return Column(
    children: uiMessages,
  );

}

