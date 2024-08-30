import 'dart:convert';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/accounts_manager.g.dart';

@riverpod
class AccountsManager extends _$AccountsManager {
  ErrorHandler? _errorHandler;
  @override
  void build() {
    _errorHandler = ref.read(errorHandlerProvider.notifier);
  }

  Future<String?> createAdmin({
    required String name,
    required String email,
    required String password,
  }) async {
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

      if (response.statusCode == 200) {
        debugPrint('Created successfully');
        return null;
      } else {
        debugPrint('Failed to create user: ${response.body}');
        return 'Failed to create account';
      }
    } catch (e) {
      return _errorHandler?.call(e);
    }
  }

  Future<String?> deleteAccount(String uid, AccountType type) async {
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
        debugPrint('User deleted successfully');
        return null;
      } else {
        debugPrint('Failed to delete user: ${response.body}');
        return 'Failed to delete user: ${response.body}';
      }
    } catch (e) {
      return _errorHandler?.call(e);
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
