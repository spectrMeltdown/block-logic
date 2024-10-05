import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/spaced_col.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/services/block_data_manager.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestingPage extends ConsumerWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toast = ref.read(toastProvider.notifier);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: SafeArea(
          child: Center(
            child: SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                BLButton(
                    onPressed: () {
                      if (!context.mounted) return;
                      toast.showToast(context, 'Test notif', type: NotifType.info);
                    },
                    child: const BLText('Notif')),
                BLButton(
                  onPressed: () async {
                    final db = FirebaseDatabase.instance;
                    try {
                      final room = Room(
                          id: 'testing',
                          players: <String, bool>{},
                          challengeIDs: ['testing1', 'testing2'],
                          hostID: 'CVWQCLBCpSMr8t739d8xFlTMETF2',
                          // icon: 'default',
                          maxPlayers: 10,
                          name: 'Testing room',
                          status: RoomStatus.available);
                      final challenges = [
                        Challenge(
                          id: 'testing1',
                          name: 'Leap Year Check',
                          shortDescription: 'Check if the given year is a leap year.',
                          additionalInfo: 'A leap year has 366 days, with an extra day in February (29 days instead of 28). It occurs every four years to keep the calendar year aligned with the solar year.',
                          limitations: ['5 block lines', 'No functions', 'No classes'],
                          blocks: AllBlocks().getAll(),
                          difficulty: Difficulty.intermediate,
                          tags: ['conditionals', ''],
                        ),
                        // Challenge(
                        //   id: 'testing2',
                        //   name: 'Vowel Count',
                        //   shortDescription: 'Count the number of vowels in a given string.',
                        //   additionalInfo: '',
                        //   limitations: ['2 block lines', 'Use one function', ''],
                        //   blocks: AllBlocks().getAll(),
                        //   difficulty: Difficulty.beginner,
                        //   tags: [
                        //     'conditionals',
                        //     'functions',
                        //   ],
                        // )
                      ];
                      await db.ref('rooms').child('testing').set(room.toJSON());
                      for (int i = 0; i <= challenges.length - 1; i++) {
                        await db.ref('challenges').child('testing$i').set(challenges[i].toJSON());
                      }
                      if (!context.mounted) return;
                      toast.showToast(context, 'Creating success', type: NotifType.success);
                    } catch (e) {
                      final errorHandler = ErrorHandler();
                      errorHandler.call(e, this);
                      if (!context.mounted) return;
                      toast.showToast(context, 'Creating failed', type: NotifType.error);
                    }
                  },
                  child: const BLText('Create test data'),
                ),
                BLButton(
                  onPressed: () async {
                    final db = FirebaseDatabase.instance;
                    try {
                      await db.ref('rooms').child('testing').remove();
                      await db.ref('challenges').child('testing1').remove();
                      await db.ref('challenges').child('testing2').remove();
                      if (!context.mounted) return;
                      toast.showToast(context, 'Deleting success', type: NotifType.success);
                    } catch (e) {
                      final errorHandler = ErrorHandler();
                      errorHandler.call(e, this);
                      if (!context.mounted) return;
                      toast.showToast(context, 'Deleting failed', type: NotifType.error);
                    }
                  },
                  child: const BLText('Delete test data'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
