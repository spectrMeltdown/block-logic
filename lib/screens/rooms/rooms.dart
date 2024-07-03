import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Rooms extends ConsumerStatefulWidget {
  const Rooms({super.key});

  @override
  ConsumerState<Rooms> createState() => _RoomsState();
}

class _RoomsState extends ConsumerState<Rooms> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: Column(
        children: [
          user.when(
            data: (user) => Text(user?.uid ?? 'aa'),
            error: (error, stackTrace) => blankWidget,
            loading: () => blankWidget,
          )
        ],
      )),
    );
  }
}
