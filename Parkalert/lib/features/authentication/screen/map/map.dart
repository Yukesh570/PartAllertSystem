import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  // Default location (Kathmandu) shown immediately
  LatLng currentLocation = LatLng(27.7172, 85.3240);

  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // You may want to show a dialog here
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      // Move map to current location
      _mapController.move(currentLocation, 15.0);
    });
  }

  Future<void> _searchAndNavigate() async {
    String query = _searchController.text;
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final newLatLng = LatLng(loc.latitude, loc.longitude);
        setState(() {
          currentLocation = newLatLng;
        });
        _mapController.move(newLatLng, 15.0);
      } else {
        _showError("Location not found");
      }
    } catch (e) {
      _showError("Error searching location");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Location on Map')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _searchAndNavigate(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchAndNavigate,
                  child: const Text('Go'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.parkAlert.Parkalert',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: currentLocation,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
