import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_provider.g.dart';

@riverpod
GameBlockData getSelfData(GetSelfDataRef ref, String uid) {
  ref.watch(gameManagerProvider.select((tree) => tree.dataTree[uid]));
  final gameManager = ref.read(gameManagerProvider.notifier);
  return gameManager.getSelfData(uid);
}

@riverpod
List<GameBlockData> getChildrenData(GetChildrenDataRef ref, List<String> uids) {
  ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
  final gameManager = ref.read(gameManagerProvider.notifier);
  return gameManager.getChildrenData(uids);
}

@riverpod
List<GameBlockData> getRootData(GetRootDataRef ref) {
  ref.watch(gameManagerProvider.select((tree) => tree.dataTree));
  final gameManager = ref.read(gameManagerProvider.notifier);
  return gameManager.getRootData();
}
