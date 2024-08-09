import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/auth.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  AuthServiceState build() {
    final dbService = ref.read(dBServiceProvider.notifier);
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final toast = ref.read(toastProvider.notifier);
    return AuthServiceState(
        dbService: dbService,
        errorHandler: errorHandler,
        sharedPref: sharedPref,
        toast: toast);
  }

  // user's uid
  String getUID() => state._auth.currentUser?.uid ?? '';

  /// user's display name
  String getDisplayName() => state._auth.currentUser?.displayName ?? '';

  /// user's email
  String getEmail() => state._auth.currentUser?.email ?? '';

  /// logged in or not
  bool isLoggedIn() => state._auth.currentUser != null;

  /// email verified or not
  bool isEmailVerified() => state._auth.currentUser!.emailVerified != false;

  /// refresh
  Future<void> reload() async => state._auth.currentUser?.reload();

  /// logout
  Future<void> logout() async {
    await state._sharedPref.setBool('loginAlertSent', false);
    await FirebaseAuth.instance.signOut();
    //state._toast.showToast('Logged out, bye!');
  }

  Future<String?> login(
      {required String email, required String password}) async {
    try {
      /// signin user
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      /// show notification
      //state._toast.dismissAllToast();

      //state._toast.showToast('Welcome back, \n ${getDisplayName()}');

      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> createAccount(
      {required String email,
      required String password,
      required String displayName,
      required String phoneNum}) async {
    try {
      /// create account
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      /// assign display name
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(displayName.trim());

      /// save phoneNum temporarily, if app data is cleared and signup was not completed
      await state._dbService.updateUserAccount(UserAccount(phoneNum: phoneNum));
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> sendEmailVerification({bool showNotif = true}) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> forgotPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> changePass(String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(password.trim());
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> changeEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(email.trim());
      // state._toast.showToast('A verification has been sent to your new email.');
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> deleteAccount() async {
    try {
      /// delete account in firebase _auth
      await FirebaseAuth.instance.currentUser!.delete();

      /// display info about delayed deletion
      // state._toast.showToast('Account Deleted');
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  /// display when the user has to reauthenticate themselves
  Future<String?> reauth(String password) async {
    AuthCredential userCred =
        EmailAuthProvider.credential(email: getEmail(), password: password);
    try {
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(userCred);
      return 'success';
    } catch (e) {
      return 'failed';
    }
  }
}

class AuthServiceState {
  final DBService _dbService;
  final ErrorHandler _errorHandler;
  final SharedPreferences _sharedPref;
  final Toast _toast;
  final _auth = FirebaseAuth.instance;
  AuthServiceState(
      {required DBService dbService,
      required ErrorHandler errorHandler,
      required SharedPreferences sharedPref,
      required Toast toast})
      : _dbService = dbService,
        _errorHandler = errorHandler,
        _sharedPref = sharedPref,
        _toast = toast;
}
