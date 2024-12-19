import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/spaced_col.dart';
import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/accounts_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAdmin extends ConsumerStatefulWidget {
  const CreateAdmin({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateAdminState();
}

class _CreateAdminState extends ConsumerState<CreateAdmin> {
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late final CustomNavigation nav;
  late final TextValidator validator;
  late final AccountsManager account;
  late final Toast toast;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Stack(
        children: [
          Form(
            key: formKey,
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                const BLSmallTitle('New admin'),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    SizedBox(width: 150, child: const BLText('Display Name', size: 16)),
                    BLTextBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      onFieldSubmitted: (p0) => submit(),
                      controller: nameController,
                      validator: (name) => validator.validateDisplayName(name),
                    )
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    SizedBox(width: 150, child: const BLText('Email', size: 16)),
                    BLTextBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      onFieldSubmitted: (p0) => submit(),
                      controller: emailController,
                      validator: (email) => validator.validateEmail(email),
                    )
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    SizedBox(width: 150, child: const BLText('Password')),
                    BLTextBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      onFieldSubmitted: (p0) => submit(),
                      controller: passController,
                      isObscure: true,
                      validator: (name) => validator.validatePassword(name),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                SpacedRow(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    const AdminBackBtn(),
                    BLAdminButton(
                      type: AdminBtnType.teal,
                      child: const BLText('Submit'),
                      onPressed: () => submit(),
                    ),
                    const SizedBox(width: 15),
                  ],
                )
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Visibility(
                visible: processing,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const BLLoading(
                    message: 'Creating admin (don\'t exit) ...',
                  ),
                )),
          )
        ],
      ),
    ));
  }

  @override
  void initState() {
    validator = ref.read(textValidatorProvider.notifier);
    account = ref.read(accountsManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  void submit() async {
    if (processing) return;
    setState(() {
      processing = true;
    });
    if (formKey.currentState!.validate()) {
      final result = await account.createAdmin(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      if (result == null) {
        if (mounted) {
          nav.pop(context);
          if (!context.mounted) return;
          toast.showToast(context, 'Admin created successfully.', type: NotifType.success);
        }
      } else {
        if (!mounted) return;
        toast.showToast(context, result, type: NotifType.error);
      }
    }
    if (!mounted) return;
    setState(() {
      processing = false;
    });
  }
}
