import 'package:block_logic/components/back_button.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/text_button.dart';
import 'package:block_logic/components/toggle.dart';
import 'package:block_logic/logic/utils.dart';
import 'package:block_logic/screens/about_us.dart';
import 'package:block_logic/screens/dialogs/change_email.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  BLPanel(
                      child: SizedBox(
                    width: Utils.screenW(context) / 1.2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        const BLSmallTitle('Account'),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BLProfilePic(size: 100),
                            SizedBox(height: 10),
                            BLText(
                              'Tap to edit',
                              fontStyle: FontStyle.italic,
                            )
                          ],
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BLTextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.user, color: Colors.white),
                                    const SizedBox(width: 15),
                                    const BLText('Guest'),
                                    const SizedBox(width: 5),
                                    editIcon
                                  ],
                                )),
                            BLTextButton(
                                onPressed: () {
                                  showDialog(context: context, builder: (context) => ChangeEmail());
                                },
                                child: Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.envelope, color: Colors.white),
                                    const SizedBox(width: 15),
                                    const BLText('Email'),
                                    const SizedBox(width: 5),
                                    editIcon
                                  ],
                                )),
                            BLTextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.lock, color: Colors.white),
                                    const SizedBox(width: 15),
                                    const BLText('Change \npassword'),
                                    const SizedBox(width: 5),
                                    editIcon
                                  ],
                                ))
                          ],
                        )
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
            )
          ],
        ),
      ),
    );
  }
}
