import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_admin.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSettings extends ConsumerStatefulWidget {
  const AdminSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends ConsumerState<AdminSettings> {
  final pageScrollController = ScrollController();
  late final AuthService auth;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumController;
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool processing = false;
  Widget msg = const BlankWidget();
  late final AccountService accountService;
  late final Toast toast;
  @override
  Widget build(BuildContext context) {
    final account = ref.watch(SelectedAdminProvider(auth.getUID()));
    accountService = ref.read(accountServiceProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    final validator = ref.read(textValidatorProvider);
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
                        account.when(
                            data: (account) {
                              if (account == null) {
                                return const Center(
                                  child: BLText(
                                      'Sorry, there was a problem getting your account details.'),
                                );
                              }
                              nameController = TextEditingController(
                                  text: account.displayName);
                              phoneNumController =
                                  TextEditingController(text: account.phoneNum);
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: width * 0.3),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const BLText('Display Name:'),
                                                BLTextBox(
                                                  controller: nameController,
                                                  validator: (name) => validator
                                                      .validateDisplayName(
                                                          name),
                                                ),
                                              ],
                                            )),
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: width * 0.3),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const BLText('Email:'),
                                                BLTextBox(
                                                  controller: emailController,
                                                  validator: (email) =>
                                                      validator
                                                          .validateEmail(email),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    const BLText('Password:'),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: [
                                        ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: width * 0.3),
                                            child: BLTextBox(
                                              controller: passController,
                                              labelText: 'New password',
                                              isObscure: true,
                                            )),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                              maxWidth: width * 0.3),
                                          child: BLTextBox(
                                            controller: confirmPassController,
                                            labelText: 'Confirm new password',
                                            isObscure: true,
                                          ),
                                        )
                                      ],
                                    ),
                                    const BLText('Phone Number:'),
                                    ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: width * 0.3),
                                        child: BLTextBox(
                                          controller: phoneNumController,
                                        )),
                                  ],
                                ),
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
    super.initState();
  }

  Future<void> updateProfilePic() async {
    if (processing) return;
    processing = true;
    final result =
        await accountService.changeProfilePic(FirestoreCollections.admins);
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
      toast.showToast('Success', type: NotifType.success);
    }
    processing = false;
  }
}
