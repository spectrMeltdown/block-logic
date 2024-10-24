import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/tutorials.g.dart';

@riverpod
TutorialData tutorialData(Ref ref) {
  return TutorialData();
}

class TutorialData {
  final paragraphStyle = const TextStyle(color: Colors.white, height: 1.5);
}
