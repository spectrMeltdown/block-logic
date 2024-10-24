import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'generated/shared_pref.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPref(Ref ref) => throw UnimplementedError();
