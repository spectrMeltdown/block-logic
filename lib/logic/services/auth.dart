import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/auth.g.dart';

@riverpod
class AuthService extends _$AuthService {
  Future<void> addPhoneNumber(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatic verification (e.g., on Android)
        await auth.currentUser?.updatePhoneNumber(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        debugPrint('Phone number verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        debugPrint('Verification code sent. Verification ID: $verificationId');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
        debugPrint('Code auto-retrieval timeout. Verification ID: $verificationId');
      },
    );
  }

  @override
  AuthServiceState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final account = ref.read(accountServiceProvider.notifier);
    return AuthServiceState(errorHandler: errorHandler, sharedPref: sharedPref, account: account);
  }

  Future<String?> changeEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(email.trim());
      // state._toast.showToast('A verification has been sent to your new email.');
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

  Future<String?> createAccount({
    required String email,
    required String password,
    required String displayName,
    required String phoneNum,
    required AccountType type,
  }) async {
    try {
      /// create account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

      /// save phoneNum temporarily, if app data is cleared and signup was not completed
      await state._account.initFirestoreData(displayName: displayName, phoneNum: phoneNum, type: type);
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> deleteAccount() async {
    try {
      /// delete account in firebase _auth
      await FirebaseAuth.instance.currentUser!.delete();

      state._account.deleteFirestoreData();
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

  /// user's display name
  String getDisplayName() => state._auth.currentUser?.displayName ?? '';

  /// user's email
  String getEmail() => state._auth.currentUser?.email ?? '';
  // user's uid
  String getUID() => state._auth.currentUser?.uid ?? '';

  /// email verified or not
  bool isEmailVerified() => state._auth.currentUser!.emailVerified != false;

  /// logged in or not
  bool isLoggedIn() => state._auth.currentUser != null;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await state._auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  /// logout
  Future<void> logout() async {
    await state._sharedPref.setBool('loginAlertSent', false);
    await state._auth.signOut();
  }

  /// display when the user has to reauthenticate themselves
  Future<String?> reauth(String password) async {
    AuthCredential userCred = EmailAuthProvider.credential(email: getEmail(), password: password);
    try {
      await state._auth.currentUser?.reauthenticateWithCredential(userCred);
      return null;
    } catch (e) {
      return 'failed';
    }
  }

  /// refresh
  Future<void> reload() async => state._auth.currentUser?.reload();

  Future<String?> sendEmailVerification({bool showNotif = true}) async {
    try {
      await state._auth.currentUser!.sendEmailVerification();
      return null;
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> verifyOTP({
    required String verificationId,
    String? otp,
    required AccountType type,
    String? phoneNum,
  }) async {
    try {
      /// first time verifying
      if (verificationId.isEmpty) {
        await state._auth.verifyPhoneNumber(
          phoneNumber: phoneNum,
          verificationCompleted: (PhoneAuthCredential credential) async {
            state._auth.currentUser!.linkWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            debugPrint('Verification failed: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            /// update with new verification ID
            if (type == AccountType.user) {
              state._account.update(user: UserAccount(verificationID: verificationId));
            } else {
              state._account.update(admin: AdminAccount(verificationID: verificationId));
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
        return 'sent';
      }

      /// for 2nd ++ attempt
      else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp!,
        );
        await state._auth.currentUser?.updatePhoneNumber(credential);
        return 'done';
      }
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }
}

class AuthServiceState {
  final ErrorHandler _errorHandler;
  final SharedPreferences _sharedPref;
  final _auth = FirebaseAuth.instance;
  final AccountService _account;
  AuthServiceState({
    required AccountService account,
    required ErrorHandler errorHandler,
    required SharedPreferences sharedPref,
  })  : _errorHandler = errorHandler,
        _account = account,
        _sharedPref = sharedPref;
}
