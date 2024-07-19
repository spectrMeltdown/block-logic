import 'package:block_logic/logic/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/internet_connection.g.dart';

@riverpod
Future<bool> checkInternetConnection(CheckInternetConnectionRef ref,
    {bool showNotif = true}) async {
  final toast = ref.watch(blToastProvider);
  bool result = await InternetConnectionChecker().hasConnection;
  if (result == true) {
    if (showNotif == true) toast.showToast('Internet connection restored');
    debugPrint('Internet restored');
    return true;
  }
  if (showNotif == true) toast.showToast('Internet connection lost');
  debugPrint('Internet lost');
  return false;
}
