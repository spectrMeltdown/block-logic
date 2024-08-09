import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/selected_room_names.g.dart';

@riverpod
Future<List<String>> selectedRoomNames(
  SelectedRoomNamesRef ref,
  List<Room> rooms,
) async {
  List<String> roomNames = [];
  for (final room in rooms) {
    roomNames.add(room.name ?? '');
  }
  return roomNames;
}
