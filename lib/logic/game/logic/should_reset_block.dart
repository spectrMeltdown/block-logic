import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/should_redisplay.g.dart';

// @riverpod
// bool shouldRedisplay(ShouldRedisplayRef ref) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.shouldRedisplay));
//   return result;
// }

final shouldResetBlockProvider = Provider.family<bool, Tuple2<CodeBlockType, String>?>((ref, req) {
  if (req == null) {
    debugPrint('Tuple was null!!');
    return false;
  }
  // debugPrint('shouldResetBlockProvider called!');
  // debugPrint('${req.item1}{${req.item2}');
  final result = ref.watch(
    gameManagerProvider.select(
      (state) {
        // debugPrint('${state.inSelectorUIDs[req.item1]} ITEMS');
        if (state.inSelectorUIDs[req.item1] != null) {
          return !state.inSelectorUIDs[req.item1]!.contains(req.item2);
        }
        return true;
      },
    ),
  );
  return result;
});
