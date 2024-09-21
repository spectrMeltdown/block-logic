import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/auth.g.dart';

@riverpod
class AuthService extends _$AuthService {
  /// Returns verificationID
  // Future<String?> addPhoneNumber(String phoneNumber) async {
  //   String? verificationID;

  //   await state._auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // Automatic verification (e.g., on Android)
  //       await state._auth.currentUser?.updatePhoneNumber(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //
  //     codeSent: (String verificationId, int? resendToken) {
  //
  //       verificationID = verificationId;
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Auto-retrieval timeout

  //     },
  //   );
  //   return verificationID;
  // }

  @override
  AuthServiceState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final account = ref.read(accountServiceProvider.notifier);
    final user = ref.watch(authChangesProvider);
    return switch (user) {
      AsyncValue<User?>() => AuthServiceState(
          errorHandler: errorHandler,
          sharedPref: sharedPref,
          account: account,
        ),
    };
  }

  Future<String?> loginCheck(String uid) async {
    try {
      final result = UserAccount.fromFirestore(await state._db.doc(uid).get());
      if (result.isLoggedIn ?? false) return 'You are already logged in another device.';
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> changeEmail(String email) async {
    try {
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(email.trim());
      // state._toast.showToast('A verification has been sent to your new email.');
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> changePass(String password) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(password.trim());
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> createAccountWithEmail({
    required String email,
    required String password,
    required String displayName,
    required AccountType type,
  }) async {
    try {
      /// create account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      assert(FirebaseAuth.instance.currentUser != null);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

      await state._account.initFirestoreData(displayName: displayName, phoneNum: null, type: type);
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> createAccountWithPhone({
    required String phoneNum,
    required String password,
    required String displayName,
    required AccountType type,
    required String smsCode,
    required String verificationId,
  }) async {
    try {
      /// sign in after creating account with phone
      await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        ),
      );

      assert(FirebaseAuth.instance.currentUser != null);
      await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

      await state._account.initFirestoreData(displayName: displayName, phoneNum: phoneNum, type: type);
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> deleteAccount() async {
    final String uid = state._auth.currentUser!.uid;
    try {
      final idTokenResult = await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);

      final Object? isAdmin = idTokenResult?.claims?['admin'];
      debugPrint('Role of account being deleted, is admin? : $isAdmin');

      if (isAdmin is bool && isAdmin == true) {
        await state._account.deleteFirestoreData(uid, AccountType.admin);
      } else {
        /// do not await, this could take some time (especially if user has lots of data)
        state._account.deleteFirestoreData(uid, AccountType.user);
      }

      /// delete account in firebase _auth
      await FirebaseAuth.instance.currentUser!.delete();

      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> forgotPass(String email, {bool useEmail = true}) async {
    try {
      if (useEmail) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
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

  Future<String?> loginEmail({
    required String email,
    required String password,
  }) async {
    try {
      await state._auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> loginPhone({
    required String phone,
    required String code,
    required String verificationID,
  }) async {
    try {
      await state._auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationID,
          smsCode: code,
        ),
      );
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  /// logout
  Future<void> logout() async {
    //await state._sharedPref.setBool('loginAlertSent', false);
    await FirebaseAuth.instance.signOut();
  }

  /// display when the user has to reauthenticate themselves
  Future<String?> reauth(String password) async {
    AuthCredential userCred = EmailAuthProvider.credential(email: getEmail(), password: password);
    try {
      await state._auth.currentUser?.reauthenticateWithCredential(userCred);
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  /// refresh
  Future<void> reload() async => state._auth.currentUser?.reload();

  Future<String?> sendEmailVerification({bool showNotif = true}) async {
    try {
      await state._auth.currentUser!.sendEmailVerification();
      return null;
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  // Future<String?> verifyOTP({
  //   required String verificationId,
  //   required AccountType type,
  //   String otp = '',
  //   String? phoneNum,
  // }) async {
  //   try {
  //     /// first time verifying
  //     if (verificationId.isEmpty && otp.isEmpty) {
  //       await state._auth.verifyPhoneNumber(
  //         phoneNumber: phoneNum,
  //         verificationCompleted: (PhoneAuthCredential credential) async {
  //           state._auth.currentUser!.linkWithCredential(credential);
  //         },
  //         verificationFailed: (FirebaseAuthException e) {
  //           debugPrint('Verification failed: ${e.message}');
  //         },
  //         codeSent: (String verificationId, int? resendToken) {
  //           /// update with new verification ID
  //           if (type == AccountType.user) {
  //             state._account.update(user: UserAccount(phoneVerified: phoneVerified));
  //           } else {
  //             state._account.update(admin: AdminAccount(phoneVerified: phoneVerified));
  //           }
  //         },
  //         codeAutoRetrievalTimeout: (String verificationId) {},
  //       );
  //       return 'sent';
  //     }

  //     /// for 2nd ++ attempt
  //     else {
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId,
  //         smsCode: otp,
  //       );
  //       await state._auth.currentUser?.updatePhoneNumber(credential);
  //       return null;
  //     }
  //   } catch (e) {
  //     return state._errorHandler.call(e, this);
  //   }
  // }
}

class AuthServiceState {
  final ErrorHandler _errorHandler;
  final SharedPreferences _sharedPref;
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection('users');
  final AccountService _account;
  AuthServiceState({
    required AccountService account,
    required ErrorHandler errorHandler,
    required SharedPreferences sharedPref,
  })  : _errorHandler = errorHandler,
        _account = account,
        _sharedPref = sharedPref;
}
