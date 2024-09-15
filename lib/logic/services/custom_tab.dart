import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/game_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/custom_tab.g.dart';

// @riverpod
// int customTab(CustomTabRef ref, CodeBlockType type) {
//   final result = ref.watch(gameManagerProvider.select((state) => state.categoryCount[type]));
//   return result!;
// }

final customTabProvider = Provider.family.autoDispose<int, CodeBlockType>((ref, type) {
  final result = ref.watch(gameManagerProvider.select((state) => state.categoryCount[type]));
  return result!;
});
