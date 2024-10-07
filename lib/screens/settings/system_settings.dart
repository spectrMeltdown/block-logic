import 'package:block_logic/components/button/toggle.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SystemSetting extends ConsumerWidget {
  final List<Widget> children;
  const SystemSetting({super.key, required this.children});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: mediaQuery.size.width / 1.4,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children),
    );
  }
}

class SystemSettings extends ConsumerWidget {
  final bool isLoggedIn;
  const SystemSettings({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userSettings = ref.watch(SettingsProvider(FirestoreCollections.users));
    final gameAudio = ref.watch(bLAudioStateProvider);
    final gameAudioNotifier = ref.read(bLAudioStateProvider.notifier);

    /// initialize the list to return
    List<Widget> settings = [];

    /// these settings apply to both logged out and logged in users
    settings.addAll([
      /// Sound effects
      SystemSetting(children: [
        const Row(
          children: [
            Icon(FontAwesomeIcons.volumeHigh),
            SizedBox(width: 20),
            BLText('Sound Effects'),
          ],
        ),
        BLSwitch(
          state: gameAudio.soundEffects,
          onPressed: (newValue) {
            gameAudioNotifier.toggleSoundEffects();
          },
        )
      ]),

      /// BG MUSIC
      SystemSetting(children: [
        const Row(
          children: [
            Icon(FontAwesomeIcons.music),
            SizedBox(width: 20),
            BLText('Background Music'),
          ],
        ),
        BLSwitch(
          state: gameAudio.backgroundMusic,
          onPressed: (newValue) {
            // debugPrint('bg music switch');
            gameAudioNotifier.toggleBG();
            //bLAudioManager.playBG(false);
          },
        )
      ]),
    ]);
    return Column(children: settings);
  }
}
