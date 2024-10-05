import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/room_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InGameControlsDialog extends ConsumerStatefulWidget {
  final String roomID;
  final bool notWaitingRoom;
  const InGameControlsDialog(this.roomID, {this.notWaitingRoom = false, super.key});

  @override
  ConsumerState<InGameControlsDialog> createState() => _InGameControlsState();
}

class _InGameControlsState extends ConsumerState<InGameControlsDialog> {
  late final CustomNavigation nav;
  late final Toast toast;
  late final RoomManager roomM;
  Widget msg = const BlankWidget();
  bool processing = false;
  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    roomM = ref.read(roomManagerProvider.notifier);
    super.initState();
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Room Controls:'),
        const SizedBox(
          height: 25,
        ),
        BLButton(
            type: processing ? BtnType.grey : BtnType.normal,
            onPressed: () {
              nav.pop(context, 'kickPlayer');
            },
            child: const BLText('Kick a player')),
        const SizedBox(
          height: 15,
        ),
        BLButton(
            type: processing ? BtnType.grey : BtnType.normal,
            onPressed: () async {
              if (processing) return;
              toggleProcessing();
              final String? result = await roomM.removePlayers(widget.roomID, [], removeAll: true);
              if (result == null) {
                if (!context.mounted) return;
                if (!widget.notWaitingRoom) {
                  nav.pop(context);
                }
              } else {
                setState(() {
                  msg = BLText(
                    result,
                    color: Colors.red,
                  );
                });
              }
              toggleProcessing();
            },
            child: const BLText('Disband room')),
        const SizedBox(
          height: 15,
        ),
        msg,
        const SizedBox(
          height: 15,
        ),
        BLTextButton(
            onPressed: () {
              nav.pop(context);
            },
            child: const BLText(
              'Back',
              color: Colors.deepOrange,
              bold: true,
              size: 20,
            )),
      ],
    ));
  }
}
