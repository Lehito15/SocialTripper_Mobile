import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const FirstWidget()
    );
  }
}

class FirstWidget extends StatefulWidget {
  const FirstWidget({super.key});

  @override
  State<FirstWidget> createState() => _FirstWidgetState();
}

class _FirstWidgetState extends State<FirstWidget> {
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

  double speedLimit = 0.5;
  int distanceLimit = 20;
  int timeLimit = 10;

  bool hasAccelerometer = true;
  double velocity = 0.0;
  double highestVelocity = 0.0;

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

    if ((newVelocity - velocity).abs() < 0.1) {
      return;
    }

    setState(() {
      velocity = newVelocity;

      if (velocity > highestVelocity) {
        highestVelocity = velocity;
      }
    });
    //print(velocity);
  }

  // Future<void> _checkForAccelerometer() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //
  //   if (androidInfo.hardware.contains("qcom")) {
  //     setState(() {
  //       hasAccelerometer = true;
  //     });
  //   } else {
  //     setState(() {
  //       hasAccelerometer = false;
  //       print('xddddddddddddddddd');
  //     });
  //   }
  //
  //   print("Accelerometer available: $hasAccelerometer");
  // }

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
        positionPack = [];
        speedPack = [];

        setState(() {
          lat = currentPosition.latitude.toString();
          long = currentPosition.longitude.toString();
          locationMessage = 'Latitude: $lat, Longitude: $long';
        });

        // Sprawdzenie, czy poprzednia pozycja jest dostępna
        if (lastPosition != null) {
          // Obliczenie odległości między ostatnią a obecną pozycją
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

    // Oblicz średnią szerokość i długość
    double avgLat = sumLat / coordinates.length;
    double avgLng = sumLng / coordinates.length;

    // Zwróć średnią lokalizację jako LatLng
    return LatLng(avgLat, avgLng);
  }

// Funkcja do wygładzania lokalizacji
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('MOBBYN'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(locationMessage, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation().then((value) {
                    print('Button pressed! Attempting to get location...');
                    lat = '${value.latitude}';
                    long = '${value.longitude}';
                    setState(() {
                      locationMessage = 'Latitude: $lat, Longitude: $long';
                    });
                    _liveLocation();
                  });
                },
                child: const Text("Get Current Location"),
              ),

              SizedBox(
                height: 300, // Set the height of the map
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(51.103, 17.085),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        if (lat.isNotEmpty && long.isNotEmpty)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(double.parse(lat), double.parse(long)),
                            child: Icon(Icons.location_pin),
                          ),
                      ],
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
                  ],
                ),
              ),


              const Text(
                'You have pushed',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
