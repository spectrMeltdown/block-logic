import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BLBackButton extends ConsumerStatefulWidget {
  const BLBackButton({super.key});

  @override
  ConsumerState<BLBackButton> createState() => _BLBackButtonState();
}

class _BLBackButtonState extends ConsumerState<BLBackButton> {
  @override
  Widget build(BuildContext context) {
    final audio = ref.read(gameAudioProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: IconButton(
          onPressed: () {
            audio.playBtn();
            Utils.pop(context);
          },
          icon: const Icon(
            FontAwesomeIcons.circleArrowLeft,
            size: 32,
          )),
    );
  }
}
