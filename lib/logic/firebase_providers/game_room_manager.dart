// import 'package:block_logic/logic/firebase_models/room.dart';
// import 'package:block_logic/logic/services/error_handler.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/game_room_manager.g.dart';

// @Riverpod()
// class InGameRoomManager extends _$InGameRoomManager {
//   @override
//   InGameRoomManagerState build() {
//     final errorHandler = ref.read(errorHandlerProvider.notifier);
//     return InGameRoomManagerState(errorHandler);
//   }

//   Future<void> getRoom(String roomID) async {
//     try {
//       state._room = await state._db.collection('rooms').doc(roomID).get().then((room) => Room.fromFirestore(room));
//     } catch (e) {
//       state._errorHandler.call(e, 'game room manager');
//     }
//   }
// }

// class InGameRoomManagerState {
//   final _db = FirebaseFirestore.instance;
//   final ErrorHandler _errorHandler;
//   Room? _room;
//   InGameRoomManagerState(this._errorHandler);
// }
