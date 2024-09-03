import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RedirectingWebPage extends ConsumerWidget {
  const RedirectingWebPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Background(
          child: Center(
        child: BLSmallTitle('Redirecting ...'),
      )),
    );
  }
}
