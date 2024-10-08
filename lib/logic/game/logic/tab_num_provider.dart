import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/game/logic/game_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/custom_tab.g.dart';

// @riverpod
// int customTab(CustomTabRef ref, CodeBlockType type) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.categoryCount[type]));
//   return result!;
// }

final tabNumberProvider = Provider.family<int, CodeBlockType>((ref, type) {
  final result = ref.watch(gameManagerProvider.select((state) => state.countsPerTab[type]?.currentCount));
  return result ?? 0;
});
