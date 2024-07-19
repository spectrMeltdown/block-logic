import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/random_num.g.dart';

@riverpod
class RandomNum extends _$RandomNum {
  @override
  RandomNum build() => RandomNum();
  int _oldRandNum = 0;

  int getRandomInt() {
    final random = Random();
    int randNum = random.nextInt(100000);
    if (_oldRandNum == randNum) {
      randNum = random.nextInt(100000);
      _oldRandNum = randNum;
    }
    return randNum;
  }
}
