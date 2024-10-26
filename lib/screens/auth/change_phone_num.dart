import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/auth.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/screens/auth/verify_phone_num.dart';
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
  late final AsyncValue<User?> user;
  late final TextValidator validator;
  late final AuthService authService;
  late final CustomNavigation nav;
  final formKey = GlobalKey<FormState>();
  Widget msg = const BlankWidget();
  bool processing = false;
  bool set = false;
  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Stack(
      children: [
        user.when(
            data: (user) {
              if (user == null) {
                return const BLText('Couldn\'t find that user...');
              }
              if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
                oldPhoneNum ??= user.phoneNumber?.substring(3, user.phoneNumber!.length) ?? '';
              }
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
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: BLText(
                          '+63',
                          bold: true,
                          color: Colors.white,
                        ),
                      ),
                      validator: (value) => validator.validatePhoneNum(value, required: true),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: msg,
                      ),
                    ),
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
                                  // String? result;
                                  if (widget.type == AccountType.admin) {
                                    //result = await

                                    // result = await accountService.update(admin: AdminAccount(id: FirebaseAuth.instance.currentUser!.uid, phoneNum: newPhoneNum, verificationID: ''));
                                  } else {
                                    final phoneNum = phoneNumController.text.trim();
                                    // check if phone belongs to another account
                                    final phoneExists = await authService.checkPhoneNumDup(phoneNum);
                                    if (phoneExists != null) {
                                      setState(() {
                                        msg = BLText(
                                          phoneExists,
                                          color: Colors.red,
                                          softWrap: true,
                                          alignCenter: true,
                                        );
                                        processing = false;
                                      });
                                      return;
                                    }
                                    // go to otp verify
                                    if (!context.mounted) return;
                                    nav.pushReplace(context, VerifyPhoneNum(phoneNum));
                                    // result = await authService.addPhoneNumber(newPhoneNum);
                                    // result = await accountService.update(user: UserAccount(id: FirebaseAuth.instance.currentUser!.uid, phoneNum: newPhoneNum, verificationID: ''));
                                  }
                                  // if (result != null) {
                                  //   setState(() {
                                  //     msg = BLText(
                                  //       result!,
                                  //       color: Colors.deepOrange,
                                  //     );
                                  //   });
                                  // } else {
                                  //   if (!context.mounted) return;
                                  //   nav.pop(context);
                                  // }
                                } else {
                                  nav.pop(context);
                                }
                              }
                              setState(() {
                                processing = false;
                              });
                            },
                            child: BLText(
                              'Proceed',
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
    super.initState();
    accountService = ref.read(accountServiceProvider.notifier);
    authService = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    user = ref.read(authChangesProvider);
    validator = ref.read(textValidatorProvider.notifier);
  }
}
