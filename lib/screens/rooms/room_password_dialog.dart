import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomPasswordDialog extends ConsumerStatefulWidget {
  final String pass;
  final String hostID;

  const RoomPasswordDialog({
    required this.pass,
    required this.hostID,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => RoomPasswordDialogState();
}

class RoomPasswordDialogState extends ConsumerState<RoomPasswordDialog> {
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Widget msg = const BlankWidget();
  bool processing = false;
  late final CustomNavigation nav;
  late final TextValidator validator;
  late final RoomManager roomManager;

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    validator = ref.read(textValidatorProvider.notifier);
    roomManager = ref.read(roomManagerProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BLSmallTitle('Room password:'),
          const SizedBox(height: 10),
          BLTextBox(
            controller: passController,
            isObscure: true,
            maxLength: 50,
            prefixIcon: const Icon(
              FontAwesomeIcons.lock,
              color: Colors.white,
            ),
            validator: (pass) => validator.validatePassword(pass),
          ),
          const SizedBox(height: 10),
          msg,
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BLTextButton(
                  onPressed: () {
                    nav.pop(context, false);
                  },
                  // type: BtnType.red,
                  child: const BLText(
                    'Back',
                    color: Colors.red,
                  )),
              const SizedBox(height: 10),
              BLTextButton(
                  onPressed: () async {
                    if (processing) return;
                    processing = true;
                    if (formKey.currentState!.validate()) {
                      // dPrint(widget.hostID);
                      final correctInput = await roomManager.validatePassword(
                        input: passController.text.trim(),
                        pass: widget.pass,
                        hostID: widget.hostID,
                      );
                      if (correctInput) {
                        if (!context.mounted) return;
                        nav.pop(context, true);
                      } else {
                        setState(() {
                          msg = const BLText(
                            'Wrong password.',
                            color: Colors.red,
                          );
                        });
                      }
                    }
                    processing = false;
                  },
                  child: const BLText(
                    'Submit',
                    color: Colors.green,
                  )),
            ],
          )
        ],
      ),
    ));
  }
}
