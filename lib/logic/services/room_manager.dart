import 'package:block_logic/logic/services/auth.dart';
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

  Future<bool> joinRoom(String roomID) async {
    final db = FirebaseFirestore.instance;
    final id = ref.read(authServiceProvider.notifier).getUID();
    try {
      await db.collection('rooms').doc(roomID).set({
        'players': FieldValue.arrayUnion([id]),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      _errorHandler?.call(e);
      return false;
    }
  }

  Future<bool> leaveRoom(String roomID) async {
    final db = FirebaseFirestore.instance;
    final id = ref.read(authServiceProvider.notifier).getUID();
    try {
      await db.collection('rooms').doc(roomID).set({
        'players': FieldValue.arrayRemove([id])
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      _errorHandler?.call(e);
      return false;
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
