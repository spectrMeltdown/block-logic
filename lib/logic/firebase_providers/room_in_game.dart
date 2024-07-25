import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/room_in_game.g.dart';

@Riverpod(dependencies: [])
Future<Room?> gameRoom(GameRoomRef ref, String roomID) async {
  final db = ref.watch(dbProvider).i;
  // TODO: update this later
  final gameRoom = await db.collection('rooms').doc(roomID).get();
  if (gameRoom.exists) {
    return Room.fromFirestore(gameRoom);
  }
  return null;
}
