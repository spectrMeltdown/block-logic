import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/email.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/reauth.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_admin.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/screens/auth/change_display_name.dart';
import 'package:block_logic/screens/auth/change_email.dart';
import 'package:block_logic/screens/auth/change_password.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AdminSettings extends ConsumerStatefulWidget {
  const AdminSettings({super.key});
  final Widget editIcon = const Padding(
    padding: EdgeInsets.only(left: 8.0),
    child: Icon(
      FontAwesomeIcons.penToSquare,
      color: Colors.amber,
      size: 20,
    ),
  );
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends ConsumerState<AdminSettings> {
  final pageScrollController = ScrollController();
  late final AuthService auth;
  late TextEditingController nameController;
  late TextEditingController emailController;
  // late TextEditingController phoneNumController;
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool processing = false;
  Widget msg = const BlankWidget();
  late final AccountService accountService;
  late final Toast toast;
  late final TextValidator validator;

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(SelectedAdminProvider(auth.getUID()));
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: pageScrollController,
            child: SingleChildScrollView(
              controller: pageScrollController,
              child: Column(
                children: [
                  const Header(title: 'Settings'),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        BLProfilePic(
                          type: AccountType.admin,
                          auth.getUID(),
                          size: 150,
                        ),
                        const SizedBox(height: 10),
                        BLTextButton(
                            onPressed: () {
                              updateProfilePic();
                            },
                            child: const BLText('Change', underlined: true)),
                        const SizedBox(height: 50),
                        account.when(
                            data: (account) {
                              if (account == null) {
                                return const Center(
                                  child: BLText('Sorry, there was a problem getting your account details.'),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  BLTextButton(
                                      onPressed: () async {
                                        if (processing) return;
                                        processing = true;
                                        await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const ChangeDisplayName(),
                                        );
                                        processing = false;
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
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
                                  const SizedBox(height: 15),
                                  BLTextButton(
                                      onPressed: () {
                                        changeEmail(context);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [const Icon(FontAwesomeIcons.envelope, color: Colors.white), const SizedBox(width: 15), const Flexible(child: BLEmail()), const SizedBox(width: 5), widget.editIcon],
                                      )),
                                  const SizedBox(height: 15),
                                  BLTextButton(
                                      onPressed: () {
                                        changePass(context);
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [const Icon(FontAwesomeIcons.lock, color: Colors.white), const SizedBox(width: 15), const BLText('Change password'), const SizedBox(width: 5), widget.editIcon],
                                      )),
                                  const SizedBox(height: 25),
                                  BLTextButton(
                                      // type: BtnType.red,
                                      onPressed: () async {
                                        if (processing) return;
                                        processing = true;
                                        String? reauth = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) => const ReauthDialog(),
                                        );
                                        debugPrint('Reauth result = $reauth');
                                        if (reauth == null) {
                                          await auth.deleteAccount();
                                          if (!context.mounted) return;
                                          context.go('/login');
                                        } else {
                                          processing = false;
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
                                            color: Colors.red,
                                          )
                                        ],
                                      )),
                                ],
                              );
                            },
                            error: genericError,
                            loading: genericLoading)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    emailController = TextEditingController(text: auth.getEmail());
    accountService = ref.read(accountServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    super.initState();
  }

  Future<void> updateProfilePic() async {
    if (processing) return;
    processing = true;
    final result = await accountService.changeProfilePic(FirestoreCollections.admins);
    if (result != null) {
      if (result == 'cancel') {
        processing = false;
        return;
      }
      setState(() {
        msg = BLText(
          result,
          color: Colors.red,
        );
      });
    } else {
      if (!mounted) return;
      toast.showToast(context, 'Success', type: NotifType.success);
    }
    processing = false;
  }

  void changeEmail(BuildContext context) async {
    if (processing) return;
    processing = true;
    String? reauth = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!context.mounted) {
        processing = false;
        return;
      }
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const ChangeEmail(),
      );
    }
    processing = false;
  }

  void changePass(BuildContext context) async {
    if (processing) return;
    processing = true;
    String? reauth = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const ReauthDialog(),
    );
    if (reauth == null) {
      if (!context.mounted) {
        processing = false;
        return;
      }
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const ChangePassword(),
      );
    } else if (reauth == 'failed') {
      if (!context.mounted) {
        processing = false;
        return;
      }
      if (!context.mounted) return;
      toast.showToast(context, 'Wrong password', type: NotifType.error);
    } else if (reauth == 'cancelled') {
      if (!context.mounted) {
        processing = true;
        return;
      }
    } else if (reauth == 'TOA') {
      if (!context.mounted) return;
      toast.showToast(context, 'Too many attempts, try again later', type: NotifType.error);
    }
    processing = false;
  }
}
