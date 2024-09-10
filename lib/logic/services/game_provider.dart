import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/game_provider.g.dart';

@riverpod
GameBlockData getBlockData(GetBlockDataRef ref, List<int> indexPath) {
  ref.watch(gameManagerProvider.select((tree) => tree.blockDataTree));
  final gameManager = ref.read(gameManagerProvider.notifier);
  return gameManager.getBlockData(indexPath);
}

@riverpod
List<GameBlockData> getRootData(GetRootDataRef ref) {
  ref.watch(gameManagerProvider.select((tree) => tree.blockDataTree));
  final gameManager = ref.read(gameManagerProvider.notifier);
  return gameManager.getRootTree();
}
