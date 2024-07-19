import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/rooms.g.dart';

@Riverpod(dependencies: [])
Stream<List<Room>> rooms(RoomsRef ref) async* {
  final db = ref.watch(dbProvider).i;
  final roomsStream = db.collection('rooms').snapshots();
  await for (final rooms in roomsStream) {
    final List<Room> result = [];
    if (rooms.docs.isNotEmpty) {
      for (final room in rooms.docs) {
        result.add(Room.fromFirestore(room));
      }
    }
    yield result;
  }
}
