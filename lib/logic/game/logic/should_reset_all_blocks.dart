import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/should_redisplay.g.dart';

// @riverpod
// bool shouldRedisplay(ShouldRedisplayRef ref) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.shouldRedisplay));
//   return result;
// }

final shouldResetAllBlocksProvider = Provider<bool>((ref) {
  final result = ref.watch(gameManagerProvider.select((state) => state.shouldResetAllBlocks));
  return result;
});
