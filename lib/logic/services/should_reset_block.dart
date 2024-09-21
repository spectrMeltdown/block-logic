import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/should_redisplay.g.dart';

// @riverpod
// bool shouldRedisplay(ShouldRedisplayRef ref) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.shouldRedisplay));
//   return result;
// }

final shouldResetBlockProvider = Provider.family.autoDispose<bool, Tuple2<CodeBlockType, String>?>((ref, req) {
  if (req == null) {
    return false;
  }
  final result =
      ref.watch(gameManagerProvider.select((state) => !state.inSelectorUIDs[req.item1]!.contains(req.item2)));
  return result;
});
