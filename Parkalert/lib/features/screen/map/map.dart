import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:Parkalert/features/screen/helperWidget/Button.dart';
import 'package:Parkalert/features/screen/helperWidget/appColor.dart';
import 'package:Parkalert/features/screen/helperWidget/backgroundCirlce.dart';
import 'package:Parkalert/l10n/app_localizations.dart';
import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:uuid/uuid.dart';

class Mappage extends StatefulWidget {
  const Mappage({Key? key}) : super(key: key);

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController searchController = TextEditingController();
  bool _isTyping = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(27.66115, 85.3028), // Kathmandu, Nepal
    zoom: 15,
  );

  final List<LatLng> _drawingPoints = [];
  final Set<Polygon> _polygons = {};
  List<dynamic> listForPlaces = [];
  final List<Marker> _placeMarker = [];
  final List<Marker> _currrentLocationMarker = [];
  BitmapDescriptor? currentLocationIcon;

  var uuid = Uuid();

  String tokenForSession = '43305';
  // final List<Marker> _predefinedMarkers = [
  //   Marker(
  //     markerId: MarkerId('marker1'),
  //     position: LatLng(27.66115, 85.3028),
  //     infoWindow: InfoWindow(title: 'Marker 1'),
  //   ),
  //   Marker(
  //     markerId: MarkerId('marker2'),
  //     position: LatLng(27.6631, 85.3035),
  //     infoWindow: InfoWindow(title: 'Marker 2'),
  //   ),
  // ];

  bool _isDrawing = false;
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

  void _startDrawing() {
    setState(() {
      _isDrawing = true;
      _drawingPoints.clear();
      // _polygons.clear();
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

  @override
  void initState() {
    super.initState();
    loadCustomIcon();

    searchController.addListener(_onSearchChanged);
  }

  void _finishDrawing() {
    if (_drawingPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add at least 3 points to form a polygon')),
      );
      return;
    }

    final String polygonId = 'polygon_${_polygons.length + 1}';
    final polygon = Polygon(
      polygonId: PolygonId(polygonId),
      points: List.from(_drawingPoints),
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
      strokeWidth: 3,
    );
    print("======polygon: ${polygon.points}");

    setState(() {
      _polygons.add(polygon);
      _isDrawing = false;
      _drawingPoints.clear();
    });
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
      _currrentLocationMarker.add(
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

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final allMarkers = {
      ..._placeMarker,
      ..._currrentLocationMarker,
      // ..._predefinedMarkers,
      ..._drawingPoints.map(
        (point) => Marker(
          markerId: MarkerId(point.toString()),
          position: point,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      ),
    };

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
                  Positioned.fill(
                    child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
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
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: FloatingActionButton(
                      onPressed: _isDrawing ? _finishDrawing : _startDrawing,
                      backgroundColor: _isDrawing
                          ? Colors
                                .greenAccent
                                .shade700 // Active color
                          : Colors.blueAccent.shade400, // Idle color
                      shape:
                          const CircleBorder(), // Ensures it's perfectly round
                      elevation: 6,
                      splashColor: Colors.white.withOpacity(0.3),
                      tooltip: _isDrawing ? 'Finish Zone' : 'Start Zone',

                      child: _isDrawing
                          ? const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 28,
                            )
                          : const Icon(
                              Icons.edit_location_alt,
                              color: Colors.white,
                              size: 28,
                            ),
                    ),
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
