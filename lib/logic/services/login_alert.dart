import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/email.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/login_alert.g.dart';

@riverpod
class LoginAlert extends _$LoginAlert {
  @override
  LoginAlertState build(
      //AccountSettings? settings
      ) {
    final auth = ref.read(authServiceProvider.notifier);
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final email = ref.read(emailServiceProvider.notifier);
    return LoginAlertState(
      auth: auth,
      //  settings: settings,
      errorHandler: errorHandler,
      sharedPref: sharedPref,
      emailService: email,
    );
  }

  Future<String?> send() async {
    late Position location;

    try {
      final testLocation = await _determinePosition();
      if (testLocation == null) {
        return '';
      } else {
        location = testLocation;
      }
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
    List<Placemark> placemark = await placemarkFromCoordinates(location.latitude, location.longitude);
    Placemark place = placemark[0];
    String user = state._auth.getDisplayName();
    String receiverEmail = state._auth.getEmail();
    String locationAddress = '${place.street} ${place.locality} ${place.subAdministrativeArea} ${place.postalCode} ${place.administrativeArea} ${place.country}';
    //final settings = state._settings;

    /// check if login alerts are enabled, or if login alert was already sent
    // if (state._sharedPref.getBool('loginAlertSent') != null && state._sharedPref.getBool('loginAlertSent') == true) {
    //   return 'noalerts';
    // }
    // if (settings != null) {
    //   if ((settings.loginAlerts != null && settings.loginAlerts == false) ||
    //       (state._sharedPref.getBool('loginAlertSent') != null &&
    //           state._sharedPref.getBool('loginAlertSent') == true)) {
    //     return 'noalerts';
    //   }
    // }
    final response = await state._emailService.send({
      'user': user,
      'location': locationAddress,
      'receiverEmail': receiverEmail,
    });
    final code = int.tryParse(response ?? '');
    if (code != null && code == 200) {
      return null;
    } else {
      return response;
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }
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

class LoginAlertState {
  final AuthService _auth;
  //final AccountSettings? _settings;
  final ErrorHandler _errorHandler;
  // final SharedPreferences _sharedPref;
  final EmailService _emailService;
  LoginAlertState({
    required AuthService auth,
    //required AccountSettings? settings,
    required ErrorHandler errorHandler,
    required SharedPreferences sharedPref,
    required EmailService emailService,
  })  : _auth = auth,
        // _settings = settings,
        _errorHandler = errorHandler,
        // _sharedPref = sharedPref,
        _emailService = emailService;
}
