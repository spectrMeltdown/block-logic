import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/email.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back_button.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/login_signup_btns.dart';
import 'package:block_logic/components/button/text_button.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/toggle.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/firebase_providers/account_settings.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/audio.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db.dart';
import 'package:block_logic/logic/services/media_query.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/persistent_data.dart';
import 'package:block_logic/logic/services/toast.dart';
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
    final user = ref.watch(accountAuthProvider);
    final nav = ref.watch(navProvider);
    final mediaQuery = ref.read(bLMediaQueryProvider);
    final auth = ref.read(authServiceStateProvider.notifier);
    final accountService = ref.read(accountServiceProvider);
    final toast = ref.read(blToastProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          children: [
            const Row(children: [BLBackButton()]),
            Container(color: Colors.transparent),
            const BLTitle('Settings'),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    BLPanel(
                        child: SizedBox(
                      width: mediaQuery.screenW(context) / 1.4,
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
                                    BLProfilePic(auth.getUID(),
                                        onPressed: () async {
                                      if (processing == true) return;
                                      processing = true;
                                      await accountService.changeProfilePic(
                                          FirestoreCollections.users);
                                      processing = false;
                                    }, size: 100),
                                    const SizedBox(height: 10),
                                    const BLText(
                                      //'Tap photo to edit', //if spare time, apply a image cropper
                                      'Tap photo to change',
                                      fontStyle: FontStyle.italic,
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BLTextButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      const ChangeDisplayName());
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons.user,
                                                    color: Colors.white),
                                                const SizedBox(width: 15),
                                                BLDisplayName(
                                                  auth.getUID(),
                                                ),
                                                const SizedBox(width: 5),
                                                widget.editIcon
                                              ],
                                            )),
                                        BLTextButton(
                                            onPressed: () async {
                                              String? reauth = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        const ReauthDialog(),
                                              );
                                              if (reauth == 'success') {
                                                if (!context.mounted) return;
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const ChangeEmail());
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons.envelope,
                                                    color: Colors.white),
                                                const SizedBox(width: 15),
                                                const BLEmail(),
                                                const SizedBox(width: 5),
                                                widget.editIcon
                                              ],
                                            )),
                                        BLTextButton(
                                            onPressed: () async {
                                              String? reauth = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        const ReauthDialog(),
                                              );
                                              if (reauth == 'success') {
                                                if (!context.mounted) return;
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const ChangePassword());
                                              } else if (reauth == 'failed') {
                                                if (!context.mounted) return;
                                                toast.showToast(
                                                    'Wrong password');
                                              } else if (reauth ==
                                                  'cancelled') {
                                                if (!context.mounted) return;
                                              } else if (reauth == 'TOA') {
                                                toast.showToast(
                                                    'Sorry, try again later');
                                              }
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                    FontAwesomeIcons.lock,
                                                    color: Colors.white),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            BLButton(
                                                type: BtnType.red,
                                                onPressed: () async {
                                                  String? reauth =
                                                      await showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        const ReauthDialog(),
                                                  );
                                                  if (reauth == 'success') {
                                                    if (!context.mounted) {
                                                      return;
                                                    }
                                                    auth.deleteAccount();
                                                  }
                                                },
                                                child: const Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.delete_forever,
                                                        color: Colors.white),
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
                                            //       nav.pop(context);
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
                            error: (error, stackTrace) => const BlankWidget(),
                            loading: () => const BlankWidget(),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    BLPanel(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: user.when(
                              data: (user) {
                                return [
                                  const BLSmallTitle('System'),
                                  SystemSettings(isLoggedIn: user != null)
                                ];
                              },
                              error: (error, stackTrace) =>
                                  [const BlankWidget()],
                              loading: () => [const BlankWidget()]),
                        )),
                    SizedBox(
                      height: mediaQuery.screenH(context) / 15,
                    ),
                    BLTextButton(
                        onPressed: () => nav.push(context, const AboutUs()),
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
    final userSettings =
        ref.watch(SettingsProvider(FirestoreCollections.users));
    final dbService = ref.read(dBServiceProvider);
    final persistentData = ref.watch(persistentDataProvider);
    final persistentDataNotifier = ref.read(persistentDataProvider.notifier);
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
          state: persistentData.shouldDisplayNotifications(),
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
                bool processing = false;
                bool loginAlerts = settings?.loginAlerts ?? true;
                return BLSwitch(
                  state: loginAlerts,
                  onPressed: () async {
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
              error: blankError,
              loading: blankLoading)
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
    final mediaQuery = ref.watch(bLMediaQueryProvider);
    return SizedBox(
      width: mediaQuery.screenW(context) / 1.4,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children),
    );
  }
}
