import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_in_game.g.dart';

@Riverpod(dependencies: [])
Future<Room?> gameRoom(GameRoomRef ref, String roomID) async {
  final db = FirebaseFirestore.instance;
  // TODO: update this later
  final gameRoom = await db.collection('rooms').doc(roomID).get();
  if (gameRoom.exists) {
    return Room.fromFirestore(gameRoom);
  }
  return null;
}
