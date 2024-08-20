import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_user.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangeDisplayName extends ConsumerStatefulWidget {
  const ChangeDisplayName({super.key});

  @override
  ConsumerState<ChangeDisplayName> createState() => _ChangeDisplayNameState();
}

class _ChangeDisplayNameState extends ConsumerState<ChangeDisplayName> {
  late final String oldDisplayName;
  late final TextEditingController displayNameController;
  late final AuthService auth;
  final formKey = GlobalKey<FormState>();
  bool processing = false;
  Widget msg = const BlankWidget();

  @override
  Widget build(BuildContext context) {
    final nav = ref.read(customNavigationProvider);
    final accountService = ref.read(accountServiceProvider.notifier);
    final validator = ref.read(textValidatorProvider);
    return BLDialog(
        color: Colors.grey.shade800,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BLSmallTitle('Enter your new display name'),
              const SizedBox(
                height: 10,
              ),
              BLTextBox(
                controller: displayNameController,
                maxLength: 20,
                keyboardType: TextInputType.name,
                prefixIcon: const Icon(
                  Icons.abc,
                  color: Colors.white,
                ),
                validator: (name) => validator.validateDisplayName(name),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BLTextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const BLText(
                        'Cancel',
                        color: Colors.deepOrange,
                      )),
                  BLTextButton(
                      onPressed: () async {
                        if (processing) return;
                        processing = true;
                        if (formKey.currentState!.validate()) {
                          final newName = displayNameController.text.trim();
                          if (oldDisplayName != newName) {
                            final result =
                                await accountService.changeDisplayName(
                                    newName, FirestoreCollections.users);
                            if (result != null) {
                              setState(() {
                                msg = BLText(result);
                              });
                              processing = false;
                              return;
                            }
                            if (!context.mounted) return;
                            nav.pop(context, true);
                          } else {
                            // name was the same, so just go back
                            nav.pop(context);
                          }
                        }
                        processing = false;
                      },
                      child: const BLText(
                        'Save',
                        color: Colors.green,
                      )),
                  const SizedBox(width: 10)
                ],
              )
            ],
          ),
        ));
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    final user = ref.read(SelectedUserProvider(auth.getUID())).value;
    oldDisplayName = user?.displayName ?? '';
    displayNameController = TextEditingController(text: oldDisplayName);
    super.initState();
  }
}
