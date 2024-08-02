import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/user.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
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

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    final user = ref.read(UserAccountProvider(auth.getUID())).value;
    oldDisplayName = user?.displayName ?? '';
    displayNameController = TextEditingController(text: oldDisplayName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final nav = ref.read(customNavigationProvider);
    final accountService = ref.read(accountServiceProvider.notifier);
    return BLDialog(
        color: Colors.grey.shade800,
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
                        accountService.changeDisplayName(
                            newDisplayName, FirestoreCollections.users);
                      } else {
                        nav.pop(context);
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
