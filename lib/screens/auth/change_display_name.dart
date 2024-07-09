import 'package:block_logic/components/dialog.dart';
import 'package:block_logic/components/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/auth.dart';
import 'package:block_logic/logic/providers/providers.dart';
import 'package:block_logic/logic/utils.dart';
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

  @override
  void initState() {
    final user = ref.read(accountChangesProvider).value;
    oldDisplayName = user?.displayName ?? '';
    displayNameController = TextEditingController(text: oldDisplayName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Enter your new display name'),
        const SizedBox(
          height: 10,
        ),
        BLTextBox(
          controller: displayNameController,
          prefixIcon: const Icon(
            Icons.mail,
            color: Colors.white,
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
                onPressed: () {
                  final newDisplayName = displayNameController.text.trim();
                  if (oldDisplayName != newDisplayName) {
                    AuthService.changeDisplayName(context, newDisplayName);
                  } else {
                    Utils.pop(context);
                  }
                },
                child: const BLText(
                  'Save',
                  color: Colors.green,
                )),
            const SizedBox(
              width: 10,
            )
          ],
        )
      ],
    ));
  }
}
