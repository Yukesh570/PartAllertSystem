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

  bool _isTyping = false;

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

  void _onSearchChanged() {
    onModify();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers.addAll(_myMarkers);

    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   packData(); // Only after UI is built
    // });
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged); // ✅ important
    searchController.dispose(); // ✅ then dispose
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
        zoom: 17,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      // This means localization isn't yet loaded or context is not in a localized widget tree
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
                  // Background
                  Positioned.fill(
                    child: CustomPaint(painter: BackgroundCirclesPainter(dark)),
                  ),

                  // Main card with map and search
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
                          // Title
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

                          // Search bar and suggestions
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              children: [
                                Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextFormField(
                                    controller: searchController,
                                    onChanged: (value) {
                                      setState(() {
                                        _isTyping = value.isNotEmpty;
                                      });

                                      // Trigger your prediction fetch logic here
                                      // Example: fetchAutocompleteSuggestions(value);
                                    },
                                    decoration: InputDecoration(
                                      hintText: _isTyping ? '' : 'Search',
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(Icons.search),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                if (listForPlaces.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
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
                                            print(
                                              'Selected: ${listForPlaces[index]['description']}',
                                            );
                                            // TODO: handle tap (e.g. update map location)
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Google Map
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GoogleMap(
                                  initialCameraPosition: _initialPosition,
                                  mapType: MapType.terrain,
                                  markers: Set<Marker>.of(_markers),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Loading Spinner
                  if (_isMapLoading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Footer Buttons
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


 //build  
