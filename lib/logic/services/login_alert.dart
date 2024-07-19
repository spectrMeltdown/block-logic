import 'dart:convert';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/firebase_providers/account_settings.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/login_alert.g.dart';

@Riverpod(dependencies: [])
class LoginAlert extends _$LoginAlert {
  late final AuthService _auth;
  late final Future<AccountSettings?> _settings;
  late final BLErrorHandler _errorHandler;
  late final SharedPreferences _preferences;

  @override
  LoginAlert build(FirestoreCollections collection) {
    _auth = ref.watch(authServiceProvider);
    _settings = ref.watch(SettingsProvider(collection).future);
    return LoginAlert();
  }

  Future<void> send() async {
    late Position location;

    try {
      location = await _determinePosition();
    } catch (e) {
      _errorHandler.handleErrors(e);
      return;
    }
    List<Placemark> placemark =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark place = placemark[0];
    String user = _auth.getDisplayName();
    String receiverEmail = _auth.getEmail();
    String locationAddress =
        '${place.street} ${place.locality} ${place.subAdministrativeArea} ${place.postalCode} ${place.administrativeArea} ${place.country}';

    debugPrint(place.toString());
    final settings = await _settings;

    /// check if login alerts are enabled, or if login alert was already sent
    if (settings?.loginAlerts == null ||
        settings!.loginAlerts == false ||
        _preferences.getBool('loginAlertSent') != null &&
            _preferences.getBool('loginAlertSent') == true) {
      debugPrint('login alert not sent');
      return;
    }
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'template_id': 'service_qsw1zlg',
          'service_id': 'template_ozw8xsg',
          'user_id': 'apazwD7SrRfQqT892',
          'accessToken': 'bEzatc-C6xiSF6f-z_g1d',
          'template_params': {
            'user': user,
            'location': locationAddress,
            'receiverEmail': receiverEmail,
          }
        }));
    debugPrint('Login Alert response code: ${response.statusCode}');
    if (response.statusCode == 200) {
      _preferences.setBool('loginAlertSent', true);
    }
    // debugPrint(response.body);
  }

  Future<Position> _determinePosition() async {
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
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // Future<void> _requestPermissions(BuildContext context) async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.storage,
  //   ].request();
  //   debugPrint(statuses.toString());
  // }
}
