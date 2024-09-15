import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final getSelfDataProvider = Provider.family<GameBlockData?, String?>((ref, uid) {
  // ref.watch(gameManagerProvider.select((tree) => tree.dataTree[uid]));
  final gameManager = ref.read(gameManagerProvider.notifier);
  if (uid == null) {
    return null;
  }
  return gameManager.getSelfData(uid);
});

final getChildrenDataProvider = Provider.family<List<GameBlockData>?, List<String>?>((ref, uids) {
  // ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
  final gameManager = ref.read(gameManagerProvider.notifier);
  if (uids == null) {
    return null;
  }
  return gameManager.getChildrenData(uids);
});

final getRootDataProvider = Provider.autoDispose<List<GameBlockData>>((ref) {
  // ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
  final gameManager = ref.read(gameManagerProvider.notifier);
  return gameManager.getRootData();
});



// import 'package:block_logic/logic/game/block_data.dart';
// import 'package:block_logic/logic/services/game_manager.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/game_provider.g.dart';

// @riverpod
// GameBlockData? getSelfData(GetSelfDataRef ref, String? uid) {
//   // ref.watch(gameManagerProvider.select((tree) => tree.dataTree[uid]));
//   final gameManager = ref.read(gameManagerProvider.notifier);
//   if (uid == null) {
//     return null;
//   }
//   return gameManager.getSelfData(uid);
// }

// @riverpod
// List<GameBlockData>? getChildrenData(GetChildrenDataRef ref, List<String>? uids) {
//   // ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
//   final gameManager = ref.read(gameManagerProvider.notifier);
//   if (uids == null) {
//     return null;
//   }
//   return gameManager.getChildrenData(uids);
// }

// @riverpod
// List<GameBlockData> getRootData(GetRootDataRef ref) {
//   // ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
//   final gameManager = ref.read(gameManagerProvider.notifier);
//   return gameManager.getRootData();
// }
