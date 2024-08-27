import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotFound extends ConsumerWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Background(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BLTitle('404'),
              BLSmallTitle('Page not found'),
              BLText(
                  'The page you are looking for doesn\'t exist or another error occurred.')
            ],
          ),
        ),
      ),
    );
  }
}
