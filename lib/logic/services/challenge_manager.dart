import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/challenge_manager.g.dart';

@riverpod
class ChallengeManager extends _$ChallengeManager {
  FirebaseDatabase? _db;
  ErrorHandler? _errorHandler;
  @override
  void build() {
    _db = FirebaseDatabase.instance;
    _errorHandler = ref.read(errorHandlerProvider.notifier);
  }

  Future<String?> create(Challenge challenge) async {
    try {
      await _db!.ref('challenges').push().set(challenge.toJSON());
      return null;
    } catch (e) {
      return _errorHandler?.call(e, this);
    }
  }

  Future<String?> delete(String id) async {
    if (id.isEmpty) return 'Error getting ID';
    try {
      await _db!.ref('challenges').child(id).remove();
      return null;
    } catch (e) {
      return _errorHandler?.call(e, 'challenge manager');
    }
  }

  Future<String?> update(Challenge challenge) async {
    if (challenge.id!.isEmpty) return 'Error getting ID';
    try {
      // TODO: UPDATE TO USE TRANSACTION
      await _db!.ref('challenges').child(challenge.id!).update(challenge.toJSON());
      return null;
    } catch (e) {
      return _errorHandler?.call(e, this);
    }
  }
}
