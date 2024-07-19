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
  late final DBService _dbService;
  late final BLErrorHandler _errorHandler;
  late final BLToast _toast;
  late final SharedPreferences _sharedPref;
  final _auth = FirebaseAuth.instance;
  @override
  AuthService build() {
    _dbService = ref.watch(dBServiceProvider);
    _toast = ref.watch(blToastProvider);
    _sharedPref = ref.watch(sharedPrefProvider);
    return AuthService();
  }

  // user's uid
  String getUID() => _auth.currentUser?.uid ?? '';

  /// user's display name
  String getDisplayName() => _auth.currentUser?.displayName ?? '';

  /// user's email
  String getEmail() => _auth.currentUser?.email ?? '';

  /// logged in or not
  bool isLoggedIn() => _auth.currentUser != null;

  /// email verified or not
  bool isEmailVerified() => _auth.currentUser!.emailVerified != false;

  /// refresh
  Future<void> reload() async => _auth.currentUser?.reload();

  /// logout
  Future<void> logout() async {
    await _sharedPref.setBool('loginAlertSent', false);
    await FirebaseAuth.instance.signOut();
    _toast.showToast('Logged out, bye!');
  }

  Future<void> login({required String email, required String password}) async {
    try {
      /// show notification
      _toast.showToast('Logging in');

      /// signin user
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      /// show notification
      _toast.dismissAllToast();
      _toast.showToast('Welcome back, \n ${getDisplayName()}');
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  Future<void> createAccount(
      {required String email,
      required String password,
      required String displayName,
      required String phoneNum}) async {
    try {
      /// show notification of account creation
      _toast.showToast('Creating account ...');

      /// create account
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      /// assign display name
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(displayName.trim());

      /// save phoneNum temporarily, if app data is cleared and signup was not completed
      await _dbService.updateUserAccount(UserAccount(phoneNum: phoneNum));

      /// send email verification
      sendEmailVerification();
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  Future<void> sendEmailVerification({bool showNotif = true}) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      /// notify user
      if (showNotif == true) _toast.showToast('Email verification sent!');
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  Future<void> forgotPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  void changePass(String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(password.trim());
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  void changeEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(email.trim());
      _toast.showToast('A verification has been sent to your new email.');
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      /// delete account in firebase _auth
      await FirebaseAuth.instance.currentUser!.delete();

      /// display info about delayed deletion
      _toast.showToast('Account Deleted');
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
  }

  /// display when the user has to reauthenticate themselves
  Future<String> reauth(String password) async {
    AuthCredential userCred =
        EmailAuthProvider.credential(email: getEmail(), password: password);
    try {
      await FirebaseAuth.instance.currentUser
          ?.reauthenticateWithCredential(userCred);
      return 'success';
    } catch (e) {
      _errorHandler.handleErrors(e);
    }
    return 'failed';
  }
}
