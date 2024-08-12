import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/email.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/login_signup.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/reauth.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/auth/change_display_name.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:block_logic/screens/auth/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountSettingsWidget extends ConsumerStatefulWidget {
  final Widget editIcon = const Padding(
    padding: EdgeInsets.only(left: 8.0),
    child: Icon(
      FontAwesomeIcons.penToSquare,
      color: Colors.amber,
      size: 20,
    ),
  );
  const AccountSettingsWidget({super.key});
  @override
  ConsumerState<AccountSettingsWidget> createState() =>
      _AccountSettingsWidgetState();
}

class _AccountSettingsWidgetState extends ConsumerState<AccountSettingsWidget> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    final accountService = ref.read(accountServiceProvider.notifier);
    final user = ref.read(accountAuthProvider);
    final nav = ref.read(customNavigationProvider);
    return BLPanel(
        child: Column(
      mainAxisSize: MainAxisSize.min,
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
                    auth.getUID(),
                    onPressed: () async {
                      if (processing == true) return;
                      processing = true;
                      await accountService
                          .changeProfilePic(FirestoreCollections.users);
                      processing = false;
                    },
                    size: 100,
                  ),
                  const SizedBox(height: 10),
                  const BLText(
                    'Profile picture',
                    size: 18,
                    bold: true,
                  ),
                  const BLText(
                    //'Tap photo to edit', //if spare time, apply a image cropper
                    'Tap photo to change',
                    fontStyle: FontStyle.italic,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BLTextButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) =>
                                    const ChangeDisplayName());
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.user,
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
                              builder: (BuildContext context) =>
                                  const ReauthDialog(),
                            );
                            if (reauth == 'success') {
                              if (!context.mounted) return;
                              await showDialog(
                                  context: context,
                                  builder: (context) => const ChangeEmail());
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.envelope,
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
                              builder: (BuildContext context) =>
                                  const ReauthDialog(),
                            );
                            if (reauth == 'success') {
                              if (!context.mounted) return;
                              await showDialog(
                                  context: context,
                                  builder: (context) => const ChangePassword());
                            } else if (reauth == 'failed') {
                              if (!context.mounted) return;
                              // toast.showToast('Wrong password');
                            } else if (reauth == 'cancelled') {
                              if (!context.mounted) return;
                            } else if (reauth == 'TOA') {
                              // toast.showToast('Sorry, try again later');
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.lock,
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
                      Center(
                        child: Column(
                          children: [
                            BLButton(
                                type: BtnType.red,
                                onPressed: () async {
                                  auth.logout();
                                  nav.pop(context);
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    BLText(
                                      'Logout',
                                      color: Colors.white,
                                    )
                                  ],
                                )),
                            BLTextButton(
                                onPressed: () async {
                                  String? reauth = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    BLText(
                                      'Delete account',
                                      color: Colors.red,
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
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
    ));
  }
}
