import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_manager.g.dart';

@riverpod
class RoomManager extends _$RoomManager {
  ErrorHandler? _errorHandler;
  Encryption? _encryption;
  @override
  void build() {
    _errorHandler = ref.read(errorHandlerProvider.notifier);
    _encryption = ref.read(encryptionProvider.notifier);
  }

  Future<void> joinRoom(String roomID, List<String> newPlayers) async {
    final db = FirebaseFirestore.instance;
    try {
      await db
          .collection('rooms')
          .doc(roomID)
          .set({'players': newPlayers}, SetOptions(merge: true));
    } catch (e) {
      _errorHandler?.call(e);
    }
  }

  Future<bool> validatePassword({
    required String input,
    required String pass,
    required String hostID,
  }) async {
    return input == _encryption?.decryptString(encrypted: pass, key: hostID);
  }
}
