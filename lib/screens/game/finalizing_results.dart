import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinalizingResults extends ConsumerStatefulWidget {
  const FinalizingResults({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinalizingResultsState();
}

class _FinalizingResultsState extends ConsumerState<FinalizingResults> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Background(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [BLLoading()],
      )),
    );
  }
}
