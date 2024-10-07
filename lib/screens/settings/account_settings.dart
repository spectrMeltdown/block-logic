import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/email.dart';
import 'package:block_logic/components/account/phone_num.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/login_signup.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/reauth.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/auth/change_display_name.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:block_logic/screens/auth/change_password.dart';
import 'package:block_logic/screens/auth/change_phone_num.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountSettingsWidget extends ConsumerWidget {
  final Widget editIcon = const Padding(
    padding: EdgeInsets.only(left: 8.0),
    child: Icon(
      FontAwesomeIcons.penToSquare,
      color: Colors.amber,
      size: 20,
    ),
  );
  final bool processing;
  final void Function(bool) toggleProcessing;
  const AccountSettingsWidget(this.processing, this.toggleProcessing, {super.key});

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.read(authServiceProvider.notifier);
    final nav = ref.read(customNavigationProvider.notifier);
    final toast = ref.read(toastProvider.notifier);
    final accountService = ref.read(accountServiceProvider.notifier);
    final sharedPref = ref.read(sharedPrefProvider);
    final reportManager = ref.read(reportsManagerProvider.notifier);
    final user = ref.watch(authChangesProvider);

    void changeEmail() async {
      if (processing) return;
      // toggleProcessing.call(true);
      // final reauth = null;
      final reauth = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const ReauthDialog(),
      );
      if (reauth == null) {
        if (!context.mounted) {
          toggleProcessing.call(false);
          return;
        }
        await showDialog(context: context, builder: (context) => const ChangeEmail());
      }
      toggleProcessing.call(false);
    }

    void changePass() async {
      if (processing) return;
      toggleProcessing.call(true);
      final reauth = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const ReauthDialog(),
      );
      if (reauth == null) {
        if (!context.mounted) {
          toggleProcessing.call(false);
          return;
        }
        await showDialog(context: context, builder: (context) => const ChangePassword());
      } else if (reauth == 'failed') {
        if (!context.mounted) {
          toggleProcessing.call(false);
          return;
        }
        if (!context.mounted) return;
        toast.showToast(context, 'Wrong password', type: NotifType.error);
      } else if (reauth == 'cancelled') {
        if (!context.mounted) {
          toggleProcessing.call(true);
          return;
        }
      } else if (reauth == 'TOA') {
        if (!context.mounted) return;
        toast.showToast(context, 'Too many attempts, try again later', type: NotifType.error);
      }
      toggleProcessing.call(false);
    }

    void changePhoneNum() async {
      if (processing) return;
      toggleProcessing(true);

      final reauth = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const ReauthDialog(),
      );
      if (reauth == null) {
        if (!context.mounted) {
          toggleProcessing.call(false);
          return;
        }
        await showDialog(context: context, builder: (context) => const ChangePhoneNum(AccountType.user));
      } else if (reauth == 'failed') {
        if (!context.mounted) {
          toggleProcessing.call(false);
          return;
        }
        if (!context.mounted) return;
        toast.showToast(context, 'Wrong password', type: NotifType.error);
      } else if (reauth == 'cancelled') {
        if (!context.mounted) {
          toggleProcessing.call(true);
          return;
        }
      } else if (reauth == 'TOA') {
        if (!context.mounted) return;
        toast.showToast(context, 'Too many attempts, try again later', type: NotifType.error);
      }
      toggleProcessing(false);
    }

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
              final email = FirebaseAuth.instance.currentUser?.email;
              return Column(
                children: [
                  BLProfilePic(
                    type: AccountType.user,
                    auth.getUID(),
                    onPressed: () async {
                      if (processing) return;
                      toggleProcessing.call(true);
                      await accountService.changeProfilePic(FirestoreCollections.users);
                      toggleProcessing.call(false);
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
                    children: [
                      BLTextButton(
                          onPressed: () async {
                            if (processing) return;
                            toggleProcessing.call(true);
                            await showDialog(context: context, builder: (context) => const ChangeDisplayName());
                            toggleProcessing.call(false);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.user, color: Colors.white),
                              const SizedBox(width: 15),
                              Flexible(
                                  child: BLDisplayName(
                                auth.getUID(),
                                AccountType.user,
                              )),
                              const SizedBox(width: 5),
                              editIcon
                            ],
                          )),
                      BLTextButton(
                          onPressed: () {
                            changeEmail();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.envelope, color: Colors.white),
                              const SizedBox(width: 15),
                              const Flexible(
                                  child: BLEmail(
                                nullMessage: 'Add email',
                              )),
                              const SizedBox(width: 5),
                              editIcon,
                            ],
                          )),
                      BLTextButton(
                          onPressed: () {
                            changePhoneNum();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.numbers, color: Colors.white),
                              const SizedBox(width: 15),
                              const Flexible(
                                  child: BLPhoneNum(
                                nullMessage: 'Add phone',
                              )),
                              const SizedBox(width: 5),
                              editIcon,
                            ],
                          )),
                      if (email != null && email.isNotEmpty)
                        BLTextButton(
                            onPressed: () {
                              changePass();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(FontAwesomeIcons.lock, color: Colors.white),
                                const SizedBox(width: 15),
                                const BLText('Change password'),
                                const SizedBox(width: 5),
                                editIcon,
                              ],
                            )),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          BLTextButton(
                              // type: BtnType.red,
                              onPressed: () async {
                                if (processing) return;
                                toggleProcessing.call(true);
                                String? reauth = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => const ReauthDialog(),
                                );
                                // debugPrint('Reauth result = $reauth');
                                if (reauth == null) {
                                  if (!kIsWeb) {
                                    await reportManager.remove(userUID: user.uid);
                                  }
                                  await auth.deleteAccount();
                                  if (!context.mounted) return;
                                  nav.pushAndRemove(context, const Checkpoint());
                                } else {
                                  toggleProcessing.call(false);
                                }
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 10),
                                  BLText(
                                    'Delete account',
                                    bold: true,
                                    color: Colors.red,
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          BLButton(
                              type: BtnType.red,
                              onPressed: () async {
                                if (processing) return;
                                toggleProcessing.call(true);
                                // TODO: Temporarily changed firebase rules to public because providers need to die when logging out.
                                // - tried using ref.invalidate after logging out, but exception still happens
                                // - must try doing:
                                // 1. nav to a logging out screen using nav.pushAndRemove
                                // 2. invalidate all firebase providers
                                // 3. log out the user
                                await sharedPref.remove('sessionID');
                                await auth.uploadSessionID('');
                                await auth.logout();
                                ref.invalidate(authServiceProvider);
                                toggleProcessing.call(false);
                                if (!context.mounted) return;
                                nav.pushAndRemove(context, const Checkpoint());
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  BLText(
                                    'Logout',
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }
          },
          error: genericError,
          loading: genericLoading,
        ),
        const SizedBox(height: 15),
      ],
    ));
  }
}
