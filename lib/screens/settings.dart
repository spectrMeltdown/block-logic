import 'package:block_logic/components/account_details.dart';
import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/components/login_signup_btns.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/components/toggle.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/models.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/toast.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/about_us.dart';
import 'package:block_logic/screens/auth/change_display_name.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:block_logic/screens/auth/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  final Widget editIcon = const Padding(
    padding: EdgeInsets.only(left: 8.0),
    child: Icon(
      FontAwesomeIcons.penToSquare,
      color: Colors.amber,
      size: 20,
    ),
  );

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(accountProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          children: [
            const Row(
              children: [BLBackButton()],
            ),
            Container(
              color: Colors.transparent,
            ),
            const BLTitle(
              'Settings',
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    BLPanel(
                        child: SizedBox(
                      width: Utils.screenW(context) / 1.4,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          const BLSmallTitle('Account'),
                          const SizedBox(
                            height: 10,
                          ),
                          user.when(
                            data: (user) {
                              if (user == null) {
                                return const BLLoginSignupBtns();
                              } else {
                                return Column(
                                  children: [
                                    BLProfilePic(
                                        onPressed: () async {
                                          if (processing == true) return;
                                          processing = true;
                                          await DBService().changeProfilePic(context);
                                          processing = false;
                                        },
                                        size: 100),
                                    const SizedBox(height: 10),
                                    const BLText(
                                      //'Tap photo to edit', //if spare time, apply a image cropper
                                      'Tap photo to change',
                                      fontStyle: FontStyle.italic,
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BLTextButton(
                                            onPressed: () {
                                              showDialog(context: context, builder: (context) => const ChangeDisplayName());
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(FontAwesomeIcons.user, color: Colors.white),
                                                const SizedBox(width: 15),
                                                const BLDisplayName(),
                                                const SizedBox(width: 5),
                                                widget.editIcon
                                              ],
                                            )),
                                        BLTextButton(
                                            onPressed: () async {
                                              String? reauth = await blShowReauthDialog(context);
                                              if (reauth == 'success') {
                                                if (!context.mounted) return;
                                                showDialog(context: context, builder: (context) => const ChangeEmail());
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(FontAwesomeIcons.envelope, color: Colors.white),
                                                const SizedBox(width: 15),
                                                const BLEmail(),
                                                const SizedBox(width: 5),
                                                widget.editIcon
                                              ],
                                            )),
                                        BLTextButton(
                                            onPressed: () async {
                                              String? reauth = await blShowReauthDialog(context);
                                              if (reauth == 'success') {
                                                if (!context.mounted) return;
                                                showDialog(
                                                    context: context, builder: (context) => const ChangePassword());
                                              } else if (reauth == 'failed') {
                                                if (!context.mounted) return;
                                                showToast('Wrong password');
                                              } else if (reauth == 'cancelled') {
                                                if (!context.mounted) return;
                                              } else if (reauth == 'TOA') {
                                                showToast('Sorry, try again later');
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(FontAwesomeIcons.lock, color: Colors.white),
                                                const SizedBox(width: 15),
                                                const BLText('Change password'),
                                                const SizedBox(width: 5),
                                                widget.editIcon
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            BLButton(
                                                type: BtnType.red,
                                                onPressed: () async {
                                                  String? reauth = await blShowReauthDialog(context);
                                                  if (reauth == 'success') {
                                                    if (!context.mounted) return;
                                                    AuthService.deleteAccount(context);
                                                  }
                                                },
                                                child: const Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.delete_forever, color: Colors.white),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    BLText(
                                                      'Delete account',
                                                      color: Colors.white,
                                                    )
                                                  ],
                                                ))
                                            // BLButton(
                                            //     type: BtnType.red,
                                            //     onPressed: () async {
                                            //       AuthService.logout();
                                            //       Utils.pop(context);
                                            //     },
                                            //     child: Row(
                                            //       mainAxisSize: MainAxisSize.min,
                                            //       children: [
                                            //         Icon(Icons.logout, color: Colors.white),
                                            //         SizedBox(
                                            //           width: 15,
                                            //         ),
                                            //         BLText(
                                            //           'Logout',
                                            //           color: Colors.white,
                                            //         )
                                            //       ],
                                            //     ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                            error: (error, stackTrace) => blankWidget,
                            loading: () => blankWidget,
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    BLPanel(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: user.when(
                              data: (user) {
                                return [const BLSmallTitle('System'), SystemSettings(isLoggedIn: user != null)];
                              },
                              error: (error, stackTrace) => [blankWidget],
                              loading: () => [blankWidget]),
                        )),
                    SizedBox(
                      height: Utils.screenH(context) / 15,
                    ),
                    BLTextButton(
                        onPressed: () => Utils.push(context, const AboutUs()),
                        child: const BLText(
                          'About Us',
                          underlined: true,
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SystemSettings extends ConsumerWidget {
  const SystemSettings({super.key, required this.isLoggedIn});
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSettings = ref.watch(userSettingsProvider);
    final persistentData = ref.watch(persistentDataStateProvider);
    final persistentDataNotifier = ref.read(persistentDataStateProvider.notifier);
    final gameAudio = ref.watch(gameAudioProvider);
    final gameAudioNotifier = ref.read(gameAudioProvider.notifier);

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
          onPressed: () {
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
          onPressed: () {
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
          state: persistentData.notifications,
          onPressed: () {
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
                bool loginAlerts = settings?.loginAlerts ?? false;
                return BLSwitch(
                  state: loginAlerts,
                  onPressed: () async {
                    DBService().updateUserSettings(AccountSettings(loginAlerts: !loginAlerts));
                  },
                );
              },
              error: blankError,
              loading: blankLoading)
        ])
      ]);
    }
    return Column(children: settings);
  }
}

class SystemSetting extends StatelessWidget {
  const SystemSetting({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Utils.screenW(context) / 1.4,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children),
    );
  }
}
