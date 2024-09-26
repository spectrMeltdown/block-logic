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
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/auth/change_display_name.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:block_logic/screens/auth/change_password.dart';
import 'package:block_logic/screens/auth/change_phone_num.dart';
import 'package:block_logic/screens/checkpoint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountSettingsWidget extends ConsumerStatefulWidget {
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
  ConsumerState<AccountSettingsWidget> createState() => _AccountSettingsWidgetState();
}

class _AccountSettingsWidgetState extends ConsumerState<AccountSettingsWidget> {
  late final AuthService auth;
  late final AccountService accountService;
  late final Toast toast;
  late final CustomNavigation nav;
  late final SharedPreferences sharedPref;
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authChangesProvider);
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
                      if (widget.processing) return;
                      widget.toggleProcessing.call(true);
                      await accountService.changeProfilePic(FirestoreCollections.users);
                      widget.toggleProcessing.call(false);
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
                            if (widget.processing) return;
                            widget.toggleProcessing.call(true);
                            await showDialog(context: context, builder: (context) => const ChangeDisplayName());
                            widget.toggleProcessing.call(false);
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
                              widget.editIcon
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
                              widget.editIcon,
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
                              widget.editIcon,
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
                                widget.editIcon,
                              ],
                            )),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          BLTextButton(
                              // type: BtnType.red,
                              onPressed: () async {
                                if (widget.processing) return;
                                widget.toggleProcessing.call(true);
                                String? reauth = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) => const ReauthDialog(),
                                );
                                debugPrint('Reauth result = $reauth');
                                if (reauth == null) {
                                  await auth.deleteAccount();
                                  if (!context.mounted) return;
                                  nav.pushAndRemove(context, const Checkpoint());
                                } else {
                                  widget.toggleProcessing.call(false);
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
                                if (widget.processing) return;
                                widget.toggleProcessing.call(true);
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
                                widget.toggleProcessing.call(false);
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

  void changeEmail() async {
    if (widget.processing) return;
    // widget.toggleProcessing.call(true);
    // final reauth = null;
    final reauth = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      await showDialog(context: context, builder: (context) => const ChangeEmail());
    }
    widget.toggleProcessing.call(false);
  }

  void changePass() async {
    if (widget.processing) return;
    widget.toggleProcessing.call(true);
    final reauth = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      await showDialog(context: context, builder: (context) => const ChangePassword());
    } else if (reauth == 'failed') {
      if (!context.mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      if (!mounted) return;
      toast.showToast(context, 'Wrong password', type: NotifType.error);
    } else if (reauth == 'cancelled') {
      if (!context.mounted) {
        widget.toggleProcessing.call(true);
        return;
      }
    } else if (reauth == 'TOA') {
      if (!mounted) return;
      toast.showToast(context, 'Too many attempts, try again later', type: NotifType.error);
    }
    widget.toggleProcessing.call(false);
  }

  void changePhoneNum() async {
    if (widget.processing) return;
    widget.toggleProcessing(true);

    final reauth = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      await showDialog(context: context, builder: (context) => const ChangePhoneNum(AccountType.user));
    } else if (reauth == 'failed') {
      if (!context.mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      if (!mounted) return;
      toast.showToast(context, 'Wrong password', type: NotifType.error);
    } else if (reauth == 'cancelled') {
      if (!context.mounted) {
        widget.toggleProcessing.call(true);
        return;
      }
    } else if (reauth == 'TOA') {
      if (!mounted) return;
      toast.showToast(context, 'Too many attempts, try again later', type: NotifType.error);
    }
    widget.toggleProcessing(false);
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    accountService = ref.read(accountServiceProvider.notifier);
    sharedPref = ref.read(sharedPrefProvider);
    super.initState();
  }
}
