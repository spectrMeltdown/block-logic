import 'package:block_logic/logic/services/game/game_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/return_block.g.dart';

// @riverpod
// bool returnBlock(ReturnBlockRef ref) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.returnBlock));
//   return result;
// }

final returnBlockProvider = Provider.autoDispose<bool>((ref) {
  final result = ref.watch(gameManagerProvider.select((state) => state.returnBlock));
  return result;
});
