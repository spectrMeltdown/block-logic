import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/creator_mode.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteRoomDialog extends ConsumerStatefulWidget {
  final String roomID;
  const DeleteRoomDialog(this.roomID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteRoomDialogState();
}

class _DeleteRoomDialogState extends ConsumerState<DeleteRoomDialog> {
  late final CustomNavigation nav;
  late final Toast toast;
  late final CreatorModeManager room;
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BLSmallTitle('Delete Room'),
        const SizedBox(
          height: 10,
        ),
        const BLText(
          'Are you sure you want to delete this room?',
          softWrap: true,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BLTextButton(
                onPressed: () {
                  nav.pop(context);
                },
                child: const BLText(
                  'No',
                  color: Colors.red,
                )),
            BLTextButton(
                onPressed: () async {
                  if (processing) return;
                  processing = true;
                  nav.pop(context);
                  final result = await room.deleteRoom(widget.roomID);
                  if (result != null) {
                    if (!context.mounted) return;
                    toast.showToast(context, result, type: NotifType.error);
                  }
                  processing = false;
                },
                child: const BLText(
                  'Yes',
                  color: Colors.green,
                ))
          ],
        )
      ],
    ));
  }

  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    room = ref.read(creatorModeManagerProvider.notifier);
    super.initState();
  }
}
