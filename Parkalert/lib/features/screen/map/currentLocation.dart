import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final List<Marker> _markers = [];
final Completer<GoogleMapController> _controller = Completer();

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
  });
}
