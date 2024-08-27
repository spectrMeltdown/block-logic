import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/email.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/login_signup.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/reauth.dart';
import 'package:block_logic/components/panel/panel.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/auth/change_display_name.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:block_logic/screens/auth/change_password.dart';
import 'package:block_logic/screens/checkpoint.dart';
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
                            changeEmail(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.envelope, color: Colors.white),
                              const SizedBox(width: 15),
                              const Flexible(child: BLEmail()),
                              const SizedBox(width: 5),
                              widget.editIcon
                            ],
                          )),
                      BLTextButton(
                          onPressed: () {
                            changePass(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.lock, color: Colors.white),
                              const SizedBox(width: 15),
                              const BLText('Change password'),
                              const SizedBox(width: 5),
                              widget.editIcon
                            ],
                          )),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          BLButton(
                              type: BtnType.red,
                              onPressed: () async {
                                if (widget.processing) return;
                                widget.toggleProcessing.call(true);
                                String? reauth = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) => const ReauthDialog(),
                                );
                                if (reauth == null) {
                                  auth.deleteAccount();
                                }
                                widget.toggleProcessing.call(false);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.delete_forever),
                                  SizedBox(width: 10),
                                  BLText(
                                    'Delete account',
                                    color: Colors.white,
                                  )
                                ],
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          BLButton(
                              type: BtnType.orange,
                              onPressed: () async {
                                if (widget.processing) return;
                                widget.toggleProcessing.call(true);
                                await auth.logout();
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

  void changeEmail(BuildContext context) async {
    if (widget.processing) return;
    widget.toggleProcessing.call(true);
    String? reauth = await showDialog(
      context: context,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!context.mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      await showDialog(context: context, builder: (context) => const ChangeEmail());
    }
    widget.toggleProcessing.call(false);
  }

  void changePass(BuildContext context) async {
    if (widget.processing) return;
    widget.toggleProcessing.call(true);
    String? reauth = await showDialog(
      context: context,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!context.mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      await showDialog(context: context, builder: (context) => const ChangePassword());
    } else if (reauth == 'failed') {
      if (!context.mounted) {
        widget.toggleProcessing.call(false);
        return;
      }
      toast.showToast('Wrong password', type: NotifType.error);
    } else if (reauth == 'cancelled') {
      if (!context.mounted) {
        widget.toggleProcessing.call(true);
        return;
      }
    } else if (reauth == 'TOA') {
      toast.showToast('Too many attempts, try again later', type: NotifType.error);
    }
    widget.toggleProcessing.call(false);
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider);
    toast = ref.read(toastProvider.notifier);
    accountService = ref.read(accountServiceProvider.notifier);
    super.initState();
  }
}
