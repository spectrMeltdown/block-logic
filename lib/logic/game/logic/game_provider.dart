import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final getSelfDataProvider = Provider.family.autoDispose<GameBlockData?, String?>((ref, uid) {
  // ref.watch(gameManagerProvider.select((tree) => tree.dataTree[uid]));
  final state = ref.read(gameManagerProvider);
  final data = state.dataTree[uid];
  if (data == null) {
    // debugPrint(data?.parentUID);
    // debugPrint('UID does not exist!');
  }
  return data;
});

final getChildrenDataProvider = Provider.family.autoDispose<List<GameBlockData>, List<String>?>((ref, uids) {
  // ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
  final state = ref.read(gameManagerProvider);
  if (uids == null) {
    return [];
  }
  final List<GameBlockData> result = [];
  for (final uid in uids) {
    if (state.dataTree[uid] == null) {
      // debugPrint(uid);
      // debugPrint('UID does not exist!');
      continue;
    }
    result.add(state.dataTree[uid]!);
  }
  return result;
});

final getRootDataProvider = Provider.autoDispose<List<GameBlockData>>((ref) {
  // ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
  final state = ref.read(gameManagerProvider);
  final List<GameBlockData> result = [];
  for (final data in state.dataTree.values) {
    if (data.parentUID == 'root') {
      result.add(data);
    } else {
      // debugPrint(data.parentUID);
      // debugPrint('UID does not exist!');
    }
  }
  return result;
});
