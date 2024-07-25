import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/auth.g.dart';

class AuthService {
  final _dbService = DBService();
  final _errorHandler = BLErrorHandler();
  final _toast = BLToast();
  final _auth = FirebaseAuth.instance;
  late final SharedPreferences _sharedPref;
  AuthService({required SharedPreferences sharePref}) : _sharedPref = sharePref;
}

@riverpod
class AuthServiceState extends _$AuthServiceState {
  @override
  AuthService build() {
    final sharedPref = ref.watch(sharedPrefProvider);
    return AuthService(sharePref: sharedPref);
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
    state._toast.showToast('Logged out, bye!');
  }

  Future<void> login({required String email, required String password}) async {
    try {
      /// show notification
      state._toast.showToast('Logging in');

      /// signin user
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      /// show notification
      state._toast.dismissAllToast();
      state._toast.showToast('Welcome back, \n ${getDisplayName()}');
    } catch (e) {
      state._errorHandler.handleErrors(e);
    }
  }

  Future<void> createAccount(
      {required String email,
      required String password,
      required String displayName,
      required String phoneNum}) async {
    try {
      /// show notification of account creation
      state._toast.showToast('Creating account ...');

      /// create account
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      /// assign display name
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(displayName.trim());

      /// save phoneNum temporarily, if app data is cleared and signup was not completed
      await state._dbService.updateUserAccount(UserAccount(phoneNum: phoneNum));

      /// send email verification
      sendEmailVerification();
    } catch (e) {
      state._errorHandler.handleErrors(e);
    }
  }

  Future<void> sendEmailVerification({bool showNotif = true}) async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      /// notify user
      if (showNotif == true) state._toast.showToast('Email verification sent!');
    } catch (e) {
      state._errorHandler.handleErrors(e);
    }
  }

  Future<void> forgotPass(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      state._errorHandler.handleErrors(e);
    }
  }

  void changePass(String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(password.trim());
    } catch (e) {
      state._errorHandler.handleErrors(e);
    }
  }

  void changeEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!
          .verifyBeforeUpdateEmail(email.trim());
      state._toast.showToast('A verification has been sent to your new email.');
    } catch (e) {
      state._errorHandler.handleErrors(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      /// delete account in firebase _auth
      await FirebaseAuth.instance.currentUser!.delete();

      /// display info about delayed deletion
      state._toast.showToast('Account Deleted');
    } catch (e) {
      state._errorHandler.handleErrors(e);
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
      state._errorHandler.handleErrors(e);
    }
    return 'failed';
  }
}
