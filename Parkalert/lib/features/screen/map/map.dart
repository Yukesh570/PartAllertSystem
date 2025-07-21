import 'dart:async';
import 'dart:convert';

import 'package:Parkalert/navigationButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
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
    zoom: 14,
  );

  List<dynamic> listForPlaces = [];

  var uuid = Uuid();

  String tokenForSession = '43305';

  void makesuggestion(String input) async {
    // String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
    String googlePlacesApiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var response = await http.get(Uri.parse(request));
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    var Resultdata = response.body.toString();
    if (response.statusCode == 200) {
      setState(() {
        listForPlaces = jsonDecode(Resultdata)['predictions'];
        print("listForPlaces: $listForPlaces");
      });
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  final List<Marker> _markers = [];
  final List<Marker> _myMarkers = [
    Marker(
      markerId: MarkerId('First'),
      position: LatLng(27.661150186746983, 85.30280431677846),
      infoWindow: InfoWindow(title: 'My Location'),
    ),
    Marker(
      markerId: MarkerId('First'),
      position: LatLng(27.66313817917902, 85.30349125170206),
      infoWindow: InfoWindow(title: 'second'),
    ),
  ];

  void onModify() {
    setState(() {
      tokenForSession = uuid.v4();
    });

    makesuggestion(searchController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.addAll(_myMarkers);

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   packData(); // Only after UI is built
    // });
    searchController.addListener(() {
      onModify();
    });
  }

  @override
  void dispose() {
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
          markerId: MarkerId('First'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: InfoWindow(title: 'My Location'),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Zones')),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  makesuggestion(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            if (listForPlaces.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: listForPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(listForPlaces[index]['description']),
                      onTap: () {
                        // You can use the place_id here to fetch coordinates and go to that location
                        print(
                          'Selected: ${listForPlaces[index]['description']}',
                        );
                      },
                    );
                  },
                ),
              ),

            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialPosition,
                    mapType: MapType.hybrid,
                    markers: Set<Marker>.of(_markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      setState(() {
                        _isMapLoading = false;
                      });
                    },
                  ),
                  if (_isMapLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.transparent,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Iconsax.location),
        onPressed: packData,
      ),
    );
  }
}
