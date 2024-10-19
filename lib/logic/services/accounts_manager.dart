import 'dart:convert';

import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/accounts_manager.g.dart';

class AccountManagerState {
  final ErrorHandler _errorHandler;
  final AccountService _accountService;

  AccountManagerState({required ErrorHandler errorHandler, required AccountService accountService})
      : _errorHandler = errorHandler,
        _accountService = accountService;
}

@riverpod
class AccountsManager extends _$AccountsManager {
  @override
  AccountManagerState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final accountService = ref.read(accountServiceProvider.notifier);
    return AccountManagerState(errorHandler: errorHandler, accountService: accountService);
  }

  Future<String?> createAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
    String? responseBody;
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Failed to retrieve auth token');
      }

      final response = await http.post(
        Uri.parse('https://block-logic-admin.onrender.com/create-admin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'email': email, 'name': name, 'password': password}),
      );
      responseBody = response.body;
      dPrint(response.statusCode.toString());
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = await state._accountService.initFirestoreData(
          createdID: decodedResponse['uid'],
          displayName: name,
          type: AccountType.admin,
        );
        if (result != null) {
          return result;
        }
        return null;
      } else {
        dPrint(response.body);
        return decodedResponse['error'];
      }
    } catch (e) {
      dPrint(responseBody);
      dPrint(state._errorHandler.call(e, this));
      return 'Error: $responseBody';
    }
  }

  Future<String?> deleteAccount(String uid, AccountType type) async {
    if (uid.isEmpty) {
      throw (ArgumentError('Uid cannot be empty!!'));
    }
    dPrint('uid to delete: $uid');
    try {
      String? authToken = await getAuthToken();
      if (authToken == null) {
        throw Exception('Failed to retrieve auth token');
      }

      final response = await http.post(
        Uri.parse('https://block-logic-admin.onrender.com/delete-account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        dPrint('User deleted successfully');
        final result = await state._accountService.deleteFirestoreData(uid, type);
        if (result != null) {
          return result;
        }
        return null;
      } else {
        dPrint('Failed to delete user: ${response.body}');
        return response.body;
      }
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }

  Future<String?> getAuthToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null; // No user is signed in.
    }

    // Retrieve the current token and its expiration timestamp.
    final idTokenResult = await user.getIdTokenResult();

    // Check if the token is close to expiration (e.g., within 5 minutes).
    DateTime? expirationTime = idTokenResult.expirationTime;
    Duration timeToExpire = expirationTime!.difference(DateTime.now());

    if (timeToExpire.inMinutes <= 5) {
      return await user.getIdToken(true);
    }

    // If the token is still valid for more than 5 minutes, return it.
    return idTokenResult.token;
  }
}
