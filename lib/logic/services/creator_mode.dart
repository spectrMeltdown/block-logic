import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/creator_mode.g.dart';

@riverpod
class CreatorMode extends _$CreatorMode {
  @override
  CreatorModeState build() {
    final errorHander = ref.read(errorHandlerProvider.notifier);
    return CreatorModeState(errorHandler: errorHander);
  }

  Future<String?> addRoom({
    required String roomName,
    required int maxPlayers,
    required List<Challenge> challenges,
    String? password,
  }) async {
    try {
      if (maxPlayers == -1) {
        throw ArgumentError('-1 number called!! tryParsefailed');
      }
      return null;
    } catch (e) {
      state._errorHandler.call(e);
      return 'Error';
    }
  }

  Future<String?> editRoom({
    String? roomName,
    int? maxPlayers,
    List<Challenge>? challenges,
    String? password,
  }) async {
    try {
      return null;
    } catch (e) {
      state._errorHandler.call(e);
      return 'Error';
    }
  }

  Future<String?> deleteRoom(String roomID) async {
    try {
      return null;
    } catch (e) {
      state._errorHandler.call(e);
      return 'Error';
    }
  }
}

class CreatorModeState {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  final ErrorHandler _errorHandler;

  CreatorModeState({required ErrorHandler errorHandler})
      : _errorHandler = errorHandler;
}
