import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/button/toggle.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/firebase_providers/account_settings.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/persistent_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SystemSettings extends ConsumerWidget {
  const SystemSettings({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettings =
        ref.watch(SettingsProvider(FirestoreCollections.users));
    final dbService = ref.read(dBServiceProvider.notifier);
    final persistentDataNotifier =
        ref.read(persistentDataStateProvider.notifier);
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
            debugPrint('bg music switch');
            gameAudioNotifier.toggleBG();
            //bLAudioManager.playBG(false);
          },
        )
      ]),

      /// NOTIFICATIONS
      SystemSetting(children: [
        const Row(
          children: [
            Icon(FontAwesomeIcons.bell),
            SizedBox(width: 20),
            BLText('Notifications'),
          ],
        ),
        BLSwitch(
          state: persistentDataNotifier.shouldDisplayNotifications(),
          onPressed: (newValue) {
            persistentDataNotifier.toggleNotifications();
          },
        )
      ]),
    ]);

    /// add login alerts only if the user is logged in
    if (isLoggedIn) {
      settings.addAll([
        SystemSetting(children: [
          const Row(
            children: [
              Icon(FontAwesomeIcons.triangleExclamation),
              SizedBox(width: 20),
              BLText('Login Alerts'),
            ],
          ),
          userSettings.when(
              data: (settings) {
                bool processing = false;
                bool loginAlerts = settings?.loginAlerts ?? true;
                return BLSwitch(
                  state: loginAlerts,
                  onPressed: (newValue) async {
                    if (processing) return;
                    processing = true;

                    try {
                      debugPrint('current value loginAlerts = $loginAlerts');
                      await dbService.updateUserSettings(
                          AccountSettings(loginAlerts: !loginAlerts));
                    } catch (e) {
                      if (!context.mounted) {
                        debugPrint('Problem in settings.dart');
                        return;
                      }
                    }
                    processing = false;
                  },
                );
              },
              error: genericError,
              loading: genericLoading)
        ])
      ]);
    }
    return Column(children: settings);
  }
}

class SystemSetting extends ConsumerWidget {
  const SystemSetting({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      width: mediaQuery.size.width / 1.4,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children),
    );
  }
}
