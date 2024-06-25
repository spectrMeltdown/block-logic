import 'dart:convert';

import 'package:block_logic/logic/db.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

Future<bool> loginAlert() async {
  Position location = await determinePosition();
  List<Placemark> placemark = await placemarkFromCoordinates(location.latitude, location.longitude);
  Placemark place = placemark[0];
// TODO: Replace with values from DBService
  String user = '';
  String receiverEmail = '';
  String locationAddress =
      '${place.street} ${place.locality} ${place.subAdministrativeArea} ${place.postalCode} ${place.administrativeArea} ${place.country}';

  debugPrint(place.toString());

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'template_id': 'template_n9qyuvq',
        'service_id': 'service_zii6429',
        'user_id': 'apazwD7SrRfQqT892',
        'accessToken': 'bEzatc-C6xiSF6f-z_g1d',
        'template_params': {
          'user': user,
          'location': locationAddress,
          'receiverEmail': receiverEmail,
        }
      }));
  debugPrint(response.statusCode.toString());
  debugPrint(response.body);
  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<void> requestPermissions(BuildContext context) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.storage,
  ].request();
  debugPrint(statuses.toString());
}
