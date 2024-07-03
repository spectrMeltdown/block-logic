import 'package:block_logic/components/account_details.dart';
import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button.dart';
import 'package:block_logic/components/login_signup_btns.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/components/toggle.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/components/custom_widgets.dart';
import 'package:block_logic/logic/db.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/about_us.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:flame_audio/flame_audio.dart';
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
                                      'Tap photo to edit',
                                      fontStyle: FontStyle.italic,
                                    ),
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BLTextButton(
                                            onPressed: () {},
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
                                            onPressed: () {
                                              showDialog(context: context, builder: (context) => const ChangeEmail());
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
                                            onPressed: () {},
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
                                                  AuthService.deleteAccount(context);
                                                  Utils.pop(context);
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
                          children: [
                            const BLSmallTitle(
                              'System',
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width: Utils.screenW(context) / 1.4,
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(FontAwesomeIcons.volumeHigh),
                                            SizedBox(width: 20),
                                            BLText('Sound Effects'),
                                          ],
                                        ),
                                        BLSwitch(
                                          state: false,
                                          onPressed: () {},
                                        )
                                      ]),
                                ),
                                SizedBox(
                                  width: Utils.screenW(context) / 1.4,
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(FontAwesomeIcons.music),
                                            SizedBox(width: 20),
                                            BLText('Background Music'),
                                          ],
                                        ),
                                        BLSwitch(
                                          state: FlameAudio.bgm.isPlaying,
                                          onPressed: () {
                                            if (FlameAudio.bgm.isPlaying == false) {
                                              FlameAudio.bgm.resume();
                                            } else {
                                              FlameAudio.bgm.pause();
                                            }
                                          },
                                        )
                                      ]),
                                ),
                                SizedBox(
                                  width: Utils.screenW(context) / 1.4,
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(FontAwesomeIcons.bell),
                                            SizedBox(width: 20),
                                            BLText('Notifications'),
                                          ],
                                        ),
                                        BLSwitch(state: false, onPressed: () {})
                                      ]),
                                ),
                                SizedBox(
                                  width: Utils.screenW(context) / 1.4,
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(FontAwesomeIcons.triangleExclamation),
                                            SizedBox(width: 20),
                                            BLText('Login Alerts'),
                                          ],
                                        ),
                                        BLSwitch(state: false, onPressed: () {})
                                      ]),
                                )
                              ],
                            )
                          ],
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
