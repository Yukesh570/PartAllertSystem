import 'dart:async';
import 'dart:convert';

import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  bool _isMapLoading = true;

  final Completer<GoogleMapController> _controller = Completer();

  final TextEditingController searchController = TextEditingController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.661150186746983, 85.30280431677846),
    zoom: 17,
  );

  List<dynamic> listForPlaces = [];

  var uuid = Uuid();

  String tokenForSession = '43305';

  void makesuggestion(String input) async {
    String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  bool _isTyping = false;
  List<Circle> _geoFenceCircles = [];
  List<LatLng> _drawingPoints = [];
  Set<Polygon> _polygons = {};
  bool _isDrawing = false; // true when user is adding points

  final List<Marker> _markers = [];
  final List<Marker> _myMarkers = [
    Marker(
      markerId: MarkerId('First'),
      position: LatLng(27.661150186746983, 85.30280431677846),
      infoWindow: InfoWindow(title: 'My Location'),
    ),
    Marker(
      markerId: MarkerId('Second'),
      position: LatLng(27.66313817917902, 85.30349125170206),
      infoWindow: InfoWindow(title: 'Second'),
    ),
  ];
  void _onMapTap(LatLng tappedPoint) {
    for (int i = 0; i < _geoFenceCircles.length; i++) {
      final circle = _geoFenceCircles[i];
      final distance = Geolocator.distanceBetween(
        tappedPoint.latitude,
        tappedPoint.longitude,
        circle.center.latitude,
        circle.center.longitude,
      );
      if (distance <= circle.radius) {
        _showRadiusSlider(i);
        return;
      }
    }

    final String circleIdVal = 'geofence_circle_${_geoFenceCircles.length + 1}';
    final Circle newCircle = Circle(
      circleId: CircleId(circleIdVal),
      center: tappedPoint,
      radius: 150,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
    setState(() {
      // rebuild the user interface
      _geoFenceCircles.add(newCircle);
    });
  }

  void _startDrawing() {
    setState(() {
      _isDrawing = true;
      _drawingPoints = [];
    });
  }

  void _finishDrawing() {
    if (_drawingPoints.length < 3) {
      return;
    }
    final String polygonIdVal = 'polygon_${_polygons.length + 1}';
    final polygon = Polygon(
      polygonId: PolygonId(polygonIdVal),
      points: _drawingPoints,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
    setState(() {
      _polygons.add(polygon);
      _drawingPoints = [];
      _isDrawing = false;
    });
  }

  void _showRadiusSlider(int index) {
    double radius = _geoFenceCircles[index].radius;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModelState) {
            return Container(
              padding: EdgeInsets.all(20),
              height: 150,
              child: Column(
                children: [
                  Text('Adjust Radius ${radius.round()} meters'),
                  Slider(
                    value: radius,
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    label: radius.round().toString(),
                    onChanged: (value) {
                      setModelState(() {
                        radius = value;
                      });
                      _updateCircleRadisus(index, value);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _geoFenceCircles.removeAt(index);
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Remove Geofence'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _updateCircleRadisus(int index, double newRadius) {
    final oldCirlce = _geoFenceCircles[index];
    setState(() {
      _geoFenceCircles[index] = Circle(
        circleId: oldCirlce.circleId,
        center: oldCirlce.center,
        radius: newRadius,
        fillColor: oldCirlce.fillColor,
        strokeColor: oldCirlce.strokeColor,
        strokeWidth: oldCirlce.strokeWidth,
      );
    });
  }

  void onModify() {
    setState(() {
      tokenForSession = uuid.v4();
    });

    makesuggestion(searchController.text);
  }

  void _onSearchChanged() {
    onModify();
  }

  BitmapDescriptor? currentLocationIcon;

  @override
  void initState() {
    super.initState();
    loadCustomIcon();

    _markers.addAll(_myMarkers);
    searchController.addListener(_onSearchChanged);
  }

  Future<void> loadCustomIcon() async {
    try {
      print('Starting to load custom icon...');
      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/logos/currentLocation.png',
      );
      print('Custom marker icon loaded successfully');
      setState(() {
        currentLocationIcon = icon;
      });
    } catch (e) {
      print('Failed to load custom marker icon: $e');
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError((
      error,
      stackTrace,
    ) {
      print(error);
    });
    return await Geolocator.getCurrentPosition();
  }

  packData() {
    getUserLocation().then((value) async {
      _markers.add(
        Marker(
          markerId: MarkerId('UserLocation'),
          position: LatLng(value.latitude, value.longitude),
          icon:
              currentLocationIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'My Location'),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 17,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<void> goToPlace(String placeId) async {
    String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googlePlacesApiKey';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var location = data['result']['geometry']['location'];
      double latitude = location['lat'];
      double longitude = location['lng'];
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 17),
        ),
      );
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('Second'),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(title: 'Second'),
          ),
        );
        listForPlaces = [];
        searchController.text = data['result']['name'];
        _isTyping = false;
      });
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dark ? Colors.black : Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          loc.freezones,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, color: dark ? Colors.white : Colors.black),
          ),
        ),
      ),
      drawer: const navButton(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Background circles painter behind the map
                  Positioned.fill(
                    child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
                  ),

                  // Map and Search stacked
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color.fromARGB(255, 20, 20, 20)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Set no-alert zones',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Stack(
                              children: [
                                // Google Map
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: GoogleMap(
                                    circles: Set<Circle>.of(_geoFenceCircles),
                                    // polygons: _polygons,
                                    initialCameraPosition: _initialPosition,
                                    mapType: MapType.terrain,
                                    markers: _drawingPoints
                                        .map(
                                          (point) => Marker(
                                            markerId: MarkerId(
                                              point.toString(),
                                            ),
                                            position: point,
                                            icon:
                                                BitmapDescriptor.defaultMarkerWithHue(
                                                  BitmapDescriptor.hueBlue,
                                                ),
                                          ),
                                        )
                                        .toSet(),
                                    onTap: _onMapTap,

                                    onMapCreated:
                                        (GoogleMapController controller) {
                                          _controller.complete(controller);
                                          setState(() {
                                            _isMapLoading = false;
                                          });
                                        },
                                    zoomControlsEnabled: false,
                                  ),
                                ),

                                // Search bar positioned on top
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  right: 10,
                                  child: Material(
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(10),
                                    child: TextFormField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        setState(() {
                                          _isTyping = value.isNotEmpty;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: _isTyping ? '' : 'Search',
                                        filled: true,
                                        fillColor: Colors.white,
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Suggestions dropdown overlay
                                if (listForPlaces.isNotEmpty)
                                  Positioned(
                                    top: 60,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 200,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: listForPlaces.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              listForPlaces[index]['description'],
                                            ),
                                            onTap: () {
                                              final placeId =
                                                  listForPlaces[index]['place_id'];
                                              goToPlace(placeId);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (_isMapLoading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircularIconButton(
                  context: context,
                  icon: Icons.arrow_back,
                  onPressed: () {},
                ),
                buildMainButton(
                  text: 'Main',
                  onPressed: () {},
                  context: context,
                ),
                buildCircularIconButton(
                  context: context,
                  icon: Iconsax.location,
                  onPressed: packData,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
