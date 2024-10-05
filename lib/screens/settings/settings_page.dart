import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/about_us.dart';
import 'package:block_logic/screens/settings/account_settings.dart';
import 'package:block_logic/screens/settings/system_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool processing = false;
  late final CustomNavigation nav;

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authChangesProvider);
    return PopScope(
      canPop: !processing,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Background(
              child: SafeArea(
                child: Column(
                  children: [
                    const Row(children: [
                      BLBackButton(),
                    ]),
                    const BLTitle(
                      'Settings',
                      bottomPadding: 10,
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                        children: [
                          AccountSettingsWidget(processing, toggleProcessing),
                          const SizedBox(
                            height: 20,
                          ),
                          BLPanel(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              child: user.when(
                                  data: (user) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [const BLSmallTitle('System'), SystemSettings(isLoggedIn: user != null)],
                                    );
                                  },
                                  error: genericError,
                                  loading: genericLoading)),
                          const SizedBox(
                            height: 20,
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
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
            Visibility(
                visible: processing,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const BLLoading(
                    message: 'Loading ...',
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void toggleProcessing(bool newState) {
    setState(() {
      processing = newState;
    });
  }
}
