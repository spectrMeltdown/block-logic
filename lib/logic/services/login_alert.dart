import 'dart:convert';

import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/login_alert.g.dart';

class LoginAlertState {
  final AuthService _auth;
  final AccountSettings? _settings;
  final ErrorHandler _errorHandler;
  final SharedPreferences _sharedPref;
  LoginAlertState({
    required AuthService auth,
    required AccountSettings? settings,
    required ErrorHandler errorHandler,
    required SharedPreferences sharedPref,
  })  : _auth = auth,
        _settings = settings,
        _errorHandler = errorHandler,
        _sharedPref = sharedPref;
}

@riverpod
class LoginAlert extends _$LoginAlert {
  @override
  LoginAlertState build(AccountSettings? settings) {
    final auth = ref.read(authServiceProvider.notifier);
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    return LoginAlertState(
        auth: auth,
        settings: settings,
        errorHandler: errorHandler,
        sharedPref: sharedPref);
  }

  Future<String?> send() async {
    late Position location;

    try {
      location = await _determinePosition();
    } catch (e) {
      return state._errorHandler.call(e);
    }
    List<Placemark> placemark =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark place = placemark[0];
    String user = state._auth.getDisplayName();
    String receiverEmail = state._auth.getEmail();
    String locationAddress =
        '${place.street} ${place.locality} ${place.subAdministrativeArea} ${place.postalCode} ${place.administrativeArea} ${place.country}';

    debugPrint(place.toString());
    final settings = state._settings;

    /// check if login alerts are enabled, or if login alert was already sent
    if (settings != null) {
      if (settings.loginAlerts != null ||
          settings.loginAlerts == false ||
          state._sharedPref.getBool('loginAlertSent') != null &&
              state._sharedPref.getBool('loginAlertSent') == true) {
        return 'noalerts';
      }
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
      state._sharedPref.setBool('loginAlertSent', true);
      return null;
    }
    return 'Problem sending login alert..';
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

// import 'dart:convert';

// import 'package:block_logic/logic/enums.dart';
// import 'package:block_logic/logic/firebase_models/account_settings.dart';
// import 'package:block_logic/logic/firebase_providers/account_settings.dart';
// import 'package:block_logic/logic/services/auth.dart';
// import 'package:block_logic/logic/services/error_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// final loginAlertProvider = StateNotifierProvider.family<LoginAlertState,
//     LoginAlert, FirestoreCollections>((ref, FirestoreCollections collection) {
//   final auth = ref.read(authServiceProvider.notifier);

//   ref.watch(SettingsProvider(FirestoreCollections.users));
//   return LoginAlertState();
// });

// class LoginAlert {
//   final AuthServiceState? _auth = null;
//   final AccountSettings? _settings = null;
//   final ErrorHandler? _errorHandler = null;
//   final SharedPreferences? _preferences = null;
//   LoginAlert();
// }

// class LoginAlertState extends StateNotifier<LoginAlert> {
//   LoginAlertState({
//     required AuthServiceState auth,
//     required Future<AccountSettings?> settings,
//     required ErrorHandler errorHandler,
//     required SharedPreferences preferences,
//   }) : super(LoginAlert());

//   Future<void> send() async {
//     late Position location;

//     try {
//       location = await _determinePosition();
//     } catch (e) {
//       state._errorHandler.handleErrors(e);
//       return;
//     }
//     List<Placemark> placemark =
//         await placemarkFromCoordinates(location.latitude, location.longitude);
//     Placemark place = placemark[0];
//     String user = state._auth.getDisplayName();
//     String receiverEmail = state._auth.getEmail();
//     String locationAddress =
//         '${place.street} ${place.locality} ${place.subAdministrativeArea} ${place.postalCode} ${place.administrativeArea} ${place.country}';

//     debugPrint(place.toString());
//     final settings = await state._settings;

//     /// check if login alerts are enabled, or if login alert was already sent
//     if (settings?.loginAlerts == null ||
//         settings!.loginAlerts == false ||
//         state._preferences.getBool('loginAlertSent') != null &&
//             state._preferences.getBool('loginAlertSent') == true) {
//       debugPrint('login alert not sent');
//       return;
//     }
//     final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
//     final response = await http.post(url,
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'template_id': 'service_qsw1zlg',
//           'service_id': 'template_ozw8xsg',
//           'user_id': 'apazwD7SrRfQqT892',
//           'accessToken': 'bEzatc-C6xiSF6f-z_g1d',
//           'template_params': {
//             'user': user,
//             'location': locationAddress,
//             'receiverEmail': receiverEmail,
//           }
//         }));
//     debugPrint('Login Alert response code: ${response.statusCode}');
//     if (response.statusCode == 200) {
//       state._preferences.setBool('loginAlertSent', true);
//     }
//     // debugPrint(response.body);
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition();
//   }

//   // Future<void> _requestPermissions(BuildContext context) async {
//   //   Map<Permission, PermissionStatus> statuses = await [
//   //     Permission.location,
//   //     Permission.storage,
//   //   ].request();
//   //   debugPrint(statuses.toString());
//   // }
// }
