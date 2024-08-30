import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/spaced_col.dart';
import 'package:block_logic/components/util/spaced_row.dart';
import 'package:block_logic/logic/services/accounts_manager.dart';
import 'package:block_logic/logic/services/validator_text.dart';
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
  late final TextValidator validator;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      spacing: 10,
      children: [
        SpacedRow(
          spacing: 10,
          children: [
            const BLText('Display Name'),
            BLTextBox(
              onFieldSubmitted: (p0) => submit(),
              controller: nameController,
              validator: (name) => validator.validateDisplayName(name),
            )
          ],
        ),
        SpacedRow(
          spacing: 10,
          children: [
            const BLText('Email'),
            BLTextBox(
              onFieldSubmitted: (p0) => submit(),
              controller: emailController,
              validator: (email) => validator.validateEmail(email),
            )
          ],
        ),
        SpacedRow(
          spacing: 10,
          children: [
            const BLText('Password'),
            BLTextBox(
              onFieldSubmitted: (p0) => submit(),
              controller: passController,
              validator: (name) => validator.validatePassword(name),
            )
          ],
        ),
        BLAdminButton(type: AdminBtnType.teal, child: const BLText('Submit'), onPressed: () => submit())
      ],
    );
  }

  @override
  void initState() {
    validator = ref.read(textValidatorProvider.notifier);
    account = ref.read(accountsManagerProvider);
    super.initState();
  }

  void submit() {
    if (processing) return;
    processing = true;
    final result = account
    processing = false;
  }
}
