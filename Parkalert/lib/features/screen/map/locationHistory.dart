import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Parkalert/features/controllers/drawerController.dart';
import 'package:Parkalert/features/controllers/pagger.dart';
import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/features/screen/map/currentLocation.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:Parkalert/utils/storage/data/ZoneData.dart';
import 'package:Parkalert/utils/storage/mapStorage/mapStorage.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:Parkalert/utils/storage/zoneStorage/zoneStorage.dart';

class LocationHistory extends StatefulWidget {
  const LocationHistory({Key? key}) : super(key: key);

  @override
  State<LocationHistory> createState() => _LocationHistoryState();
}

class _LocationHistoryState extends State<LocationHistory> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController searchController = TextEditingController();
  bool _isTyping = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.66115, 85.3028), // Kathmandu, Nepal
    zoom: 15,
  );

  final List<LatLng> _drawingPoints = [];
  Set<Polygon> _polygons = {};
  List<dynamic> listForPlaces = [];
  final List<Marker> _placeMarker = [];
  final List<Marker> _geoFench = [];
  final List<Marker> _geo = [];
  late GeofenceService _geofenceService;
  StreamSubscription<Position>? _locationSubscription;

  Set<Marker> _markers = {};

  // final List<Marker> _currrentLocationMarker = [];
  BitmapDescriptor? currentLocationIcon;
  BitmapDescriptor? geofenceIcon;

  var uuid = Uuid();
  String tokenForSession = '43305';
  bool _isDrawing = false;

  // Save polygons to SharedPreferences
  // Future<void> savePolygons() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final jsonStr = encodePolygons(_polygons);
  //   await prefs.setString('saved_polygons', jsonStr);
  // }

  final drawerCtrl = Get.find<DrawerControllerX>();

  List<latlng.LatLng> convertToLatLong2(List<LatLng> googlePoints) {
    return googlePoints
        .map((p) => latlng.LatLng(p.latitude, p.longitude))
        .toList();
  }

  void trackUserLocation() async {
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, // update every 5 meters
          ),
        ).listen((Position position) async {
          final GoogleMapController controller = await _controller.future;
          LatLng userLatLng = LatLng(position.latitude, position.longitude);

          // Smooth camera move
          controller.animateCamera(CameraUpdate.newLatLng(userLatLng));
        });
  }

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

  void _onMapTap(LatLng point) {
    FocusScope.of(context).unfocus(); // hides the keyboard when map tapped
    listForPlaces = [];
    if (_isDrawing) {
      setState(() {
        _drawingPoints.add(point);
      });
      print('Added point: $point');
    }
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

  @override
  void initState() {
    super.initState();
    loadCustomIcon();
    fenceIcon();
    searchController.addListener(_onSearchChanged);
    _geofenceService = GeofenceService(
      showNotification: _showNotification,
      updateState: () => setState(() {}),
    );
    _geofenceService.startMonitoring();
    // loadPolygons();
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

  Future<void> fenceIcon() async {
    try {
      print('Starting to load custom icon...');
      BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/logos/fence.png',
      );
      print('Custom marker icon loaded successfully');
      setState(() {
        geofenceIcon = icon;
      });
    } catch (e) {
      print('Failed to load custom marker icon: $e');
    }
  }

  void _showNotification(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title: $body'), duration: Duration(seconds: 3)),
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _geofenceService.dispose();

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
      // _currrentLocationMarker.add(
      //   Marker(
      //     markerId: MarkerId('UserLocation'),
      //     position: LatLng(value.latitude, value.longitude),

      //     infoWindow: InfoWindow(title: 'My Location'),
      //   ),
      // );
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
      searchController.removeListener(_onSearchChanged);

      setState(() {
        _placeMarker.add(
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
      FocusScope.of(context).unfocus();

      searchController.addListener(_onSearchChanged);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  void _finishDrawing() async {
    if (_drawingPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add at least 3 points to form a polygon')),
      );
      return;
    }
    final convertedPoints = convertToLatLong2(
      _drawingPoints,
    ); // latlong2 LatLng

    // savePolygons();
  }

  LatLngBounds getPolygonBounds(List<LatLng> points) {
    double? minLat, maxLat, minLng, maxLng;
    print("points: ${points}");
    for (var point in points) {
      if (minLat == null || point.latitude < minLat) minLat = point.latitude;
      if (maxLat == null || point.latitude > maxLat) maxLat = point.latitude;
      if (minLng == null || point.longitude < minLng) minLng = point.longitude;
      if (maxLng == null || point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat!, minLng!),
      northeast: LatLng(maxLat!, maxLng!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final allMarkers = {
      ..._geo,
      ..._markers,
      ..._geoFench,
      ..._placeMarker,
      // ..._currrentLocationMarker,
      // ..._predefinedMarkers,
      ..._drawingPoints.map(
        (point) => Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      ),
    };

    return PageWrapper(
      routeName: '/locationHistory',
      child: Scaffold(
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
                    Positioned.fill(
                      child: CustomPaint(
                        painter: BackgroundCirclesPainter(dark),
                      ),
                    ),

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
                                      initialCameraPosition: _initialPosition,
                                      myLocationEnabled: true,
                                      polygons: _polygons,
                                      markers: allMarkers,
                                      onMapCreated: (controller) =>
                                          _controller.complete(controller),
                                      onTap: _onMapTap,
                                      myLocationButtonEnabled: false,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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

                    // Positioned(
                    //   bottom: MediaQuery.of(context).padding.bottom + 20,
                    //   right: 20,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       if (_polygons.isNotEmpty) {
                    //         goToPolygon(_polygons.first);
                    //       }
                    //     },
                    //     child: Text('Go to first Geofence'),
                    //   ),
                    // ),
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
                    onPressed: () {
                      drawerCtrl.goBack(); // update drawer highlight

                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        // Optionally handle the case where there's no back route
                        print("No screen to go back to");
                      }
                    },
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
      ),
    );
  }
}
