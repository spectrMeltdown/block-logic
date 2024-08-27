import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/random_num.g.dart';

@riverpod
class RandomNum extends _$RandomNum {
  @override
  RandomNumState build() => RandomNumState();

  int getRandomInt(int rangeNum, [int? additional]) {
    final random = Random();
    int randNum = random.nextInt(rangeNum);
    if (additional != null) {
      randNum + additional;
    }
    if (state._previous == randNum) {
      randNum = random.nextInt(900000);
      state._previous = randNum;
    }
    return randNum;
  }
}

class RandomNumState {
  int _previous = 0;
}
