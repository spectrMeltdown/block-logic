import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/components/toggle.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/about_us.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final Widget editIcon = const Padding(
    padding: EdgeInsets.only(left: 8.0),
    child: Icon(
      FontAwesomeIcons.penToSquare,
      color: Colors.amber,
      size: 20,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          children: [
            const Row(
              children: [BLBackButton()],
            ),
            const BLTitle(
              'Settings',
            ),
            const SizedBox(),
            BLPanel(
                child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                const BLSmallTitle('Account'),
                Wrap(
                  spacing: 20,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Wrap(
                        direction: Axis.vertical,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: BLProfilePic(size: 100),
                          ),
                          BLText(
                            'Tap to edit',
                            fontStyle: FontStyle.italic,
                          )
                        ],
                      ),
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        BLTextButton(
                            onPressed: () {},
                            child: Wrap(
                              spacing: 10,
                              children: [
                                const Icon(FontAwesomeIcons.user, color: Colors.white),
                                const BLText('Guest'),
                                editIcon
                              ],
                            )),
                        BLTextButton(
                            onPressed: () {},
                            child: Wrap(
                              spacing: 10,
                              children: [
                                const Icon(FontAwesomeIcons.envelope, color: Colors.white),
                                const BLText('Email'),
                                editIcon
                              ],
                            )),
                        BLTextButton(
                            onPressed: () {},
                            child: Wrap(
                              spacing: 10,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Icon(FontAwesomeIcons.lock, color: Colors.white),
                                const BLText('Change \npassword'),
                                editIcon
                              ],
                            ))
                      ],
                    )
                  ],
                )
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            BLPanel(
                padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const BLSmallTitle(
                      'System',
                    ),
                    Wrap(
                      direction: Axis.vertical,
                      children: [
                        SizedBox(
                          width: Utils.screenW(context) / 1.5,
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 15,
                              children: [
                                const Wrap(
                                  spacing: 20,
                                  children: [
                                    Icon(FontAwesomeIcons.volumeHigh),
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
                          width: Utils.screenW(context) / 1.5,
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 15,
                              children: [
                                const Wrap(
                                  spacing: 20,
                                  children: [
                                    Icon(FontAwesomeIcons.music),
                                    BLText('Background'),
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
                          width: Utils.screenW(context) / 1.5,
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 15,
                              children: [
                                const Wrap(
                                  spacing: 20,
                                  children: [
                                    Icon(FontAwesomeIcons.bell),
                                    BLText('Notifications'),
                                  ],
                                ),
                                BLSwitch(state: false, onPressed: () {})
                              ]),
                        ),
                        SizedBox(
                          width: Utils.screenW(context) / 1.5,
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 15,
                              children: [
                                const Wrap(
                                  spacing: 20,
                                  children: [
                                    Icon(FontAwesomeIcons.triangleExclamation),
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
                onPressed: () => Utils.push(context, AboutUs()),
                child: const BLText(
                  'About Us',
                  underlined: true,
                ))
          ],
        ),
      ),
    );
  }
}
