import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePhoneNum extends ConsumerStatefulWidget {
  final AccountType type;
  const ChangePhoneNum(this.type, {super.key});

  @override
  ConsumerState<ChangePhoneNum> createState() => _ChangePhoneNumState();
}

class _ChangePhoneNumState extends ConsumerState<ChangePhoneNum> {
  String? oldPhoneNum;
  late TextEditingController phoneNumController;
  late final AccountService accountService;
  late final AsyncValue<UserAccount?> user;
  late final TextValidator validator;
  late final AuthService authService;
  final formKey = GlobalKey<FormState>();
  Widget msg = const BlankWidget();
  bool processing = false;
  bool set = false;
  @override
  Widget build(BuildContext context) {
    final nav = ref.watch(customNavigationProvider);
    return BLDialog(
        child: Stack(
      children: [
        user.when(
            data: (user) {
              if (user == null) {
                return const BLText('Couldn\'t find that user...');
              }
              oldPhoneNum ??= user.phoneNum;
              if (set == false) {
                setState(() {
                  phoneNumController = TextEditingController(text: oldPhoneNum);
                  set = true;
                });
              }

              return Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BLSmallTitle('Enter your new phone number:'),
                    const SizedBox(
                      height: 10,
                    ),
                    BLTextBox(
                      controller: phoneNumController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      validator: (value) => validator.validatePhoneNum(value, required: true),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    msg,
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const BLText(
                              'Cancel',
                              color: Colors.red,
                            )),
                        TextButton(
                            onPressed: () async {
                              if (processing) return;
                              setState(() {
                                processing = true;
                              });
                              if (formKey.currentState!.validate()) {
                                final newPhoneNum = phoneNumController.text.trim();

                                if (oldPhoneNum != newPhoneNum) {
                                  String? result;
                                  if (widget.type == AccountType.admin) {
                                    //result = await

                                    result = await accountService.update(
                                        admin: AdminAccount(
                                            id: FirebaseAuth.instance.currentUser!.uid,
                                            phoneNum: newPhoneNum,
                                            verificationID: ''));
                                  } else {
                                    // result = await authService.addPhoneNumber(newPhoneNum);
                                    result = await accountService.update(
                                        user: UserAccount(
                                            id: FirebaseAuth.instance.currentUser!.uid,
                                            phoneNum: newPhoneNum,
                                            verificationID: ''));
                                  }
                                  if (result != null) {
                                    setState(() {
                                      msg = BLText(
                                        result!,
                                        color: Colors.deepOrange,
                                      );
                                    });
                                  } else {
                                    if (!context.mounted) return;
                                    nav.pop(context);
                                  }
                                }
                              }
                              setState(() {
                                processing = false;
                              });
                            },
                            child: BLText(
                              'Save',
                              color: processing == true ? Colors.grey : Colors.green,
                            )),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    )
                  ],
                ),
              );
            },
            error: genericError,
            loading: genericLoading),
      ],
    ));
  }

  @override
  void initState() {
    accountService = ref.read(accountServiceProvider.notifier);
    authService = ref.read(authServiceProvider.notifier);
    user = ref.read(SelectedUserProvider(FirebaseAuth.instance.currentUser!.uid));
    validator = ref.read(textValidatorProvider.notifier);
    super.initState();
  }
}
