import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/challenge_manager.g.dart';

@riverpod
class ChallengeManager extends _$ChallengeManager {
  FirebaseFirestore? _db;
  ErrorHandler? _errorHandler;
  @override
  void build() {
    _db = FirebaseFirestore.instance;
    _errorHandler = ref.read(errorHandlerProvider.notifier);
  }

  Future<String?> create(Challenge challenge) async {
    try {
      await _db!.collection('challenges').doc(challenge.id).set(challenge.toFirestore());
      return null;
    } catch (e) {
      return _errorHandler?.call(e, this);
    }
  }

  Future<String?> delete(String id) async {
    try {
      await _db!.collection('challenges').doc(id).delete();
      return null;
    } catch (e) {
      return _errorHandler?.call(e, 'challenge manager');
    }
  }

  Future<String?> update(Challenge challenge) async {
    try {
      await _db!.collection('challenges').doc(challenge.id).update(challenge.toFirestore());
      return null;
    } catch (e) {
      return _errorHandler?.call(e, this);
    }
  }
}
