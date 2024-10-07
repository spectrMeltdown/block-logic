import 'package:block_logic/logic/services/game/game_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/time_box.g.dart';

// @riverpod
// bool runTimer(RunTimerRef ref) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.runTimer));
//   return result;
// }

final runTimerProvider = Provider.autoDispose<bool>((ref) {
  final result = ref.watch(gameManagerProvider.select((state) => state.runTimer));
  return result;
});
