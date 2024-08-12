import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLRoomState extends ConsumerWidget {
  final RoomStatus? status;
  const BLRoomState(this.status, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (status) {
      case RoomStatus.available:
        return const BLText(
          'Available',
          color: Colors.lightGreen,
        );
      case RoomStatus.inGame:
        return const BLText(
          'In game',
          color: Colors.amber,
        );
      case RoomStatus.finalizing:
        return const BLText(
          'Available',
          color: Colors.amber,
        );
      default:
        return const BLText('--');
    }
  }
}
