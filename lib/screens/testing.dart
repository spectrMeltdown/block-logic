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
import 'package:cloud_firestore/cloud_firestore.dart';
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
        child: Center(
          child: SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              BLButton(
                  onPressed: () {
                    toast.showToast('Test notif', type: NotifType.info);
                  },
                  child: const BLText('Notif')),
              BLButton(
                onPressed: () async {
                  final db = FirebaseFirestore.instance;
                  try {
                    final room = Room(
                        id: 'testing',
                        players: [],
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
                        additionalInfo:
                            'A leap year has 366 days, with an extra day in February (29 days instead of 28). It occurs every four years to keep the calendar year aligned with the solar year.',
                        limitations: ['5 block lines', 'No functions', 'No classes'],
                        blocks: AllBlocks().getAll(),
                        difficulty: Difficulty.intermediate,
                        tags: ['conditionals', ''],
                      ),
                      Challenge(
                        id: 'testing2',
                        name: 'Vowel Count',
                        shortDescription: 'Count the number of vowels in a given string.',
                        additionalInfo: '',
                        limitations: ['2 block lines', 'Use one function', ''],
                        blocks: AllBlocks().getAll(),
                        difficulty: Difficulty.beginner,
                        tags: [
                          'conditionals',
                          'functions',
                        ],
                      )
                    ];
                    await db.collection('rooms').doc('testing').update(room.toFirestore());
                    for (int i = 0; i <= challenges.length - 1; i++) {
                      await db
                          .collection('challenges')
                          .doc('testing$i')
                          .set(challenges[i].toFirestore(), SetOptions(merge: true));
                    }
                    toast.showToast('Creating success', type: NotifType.success);
                  } catch (e) {
                    final errorHandler = ErrorHandler();
                    errorHandler.call(e, this);
                    toast.showToast('Creating failed', type: NotifType.error);
                  }
                },
                child: const BLText('Create test data'),
              ),
              BLButton(
                onPressed: () async {
                  final db = FirebaseFirestore.instance;
                  try {
                    await db.collection('rooms').doc('testing').delete();
                    await db.collection('challenges').doc('testing1').delete();
                    await db.collection('challenges').doc('testing2').delete();
                    toast.showToast('Deleting success', type: NotifType.success);
                  } catch (e) {
                    final errorHandler = ErrorHandler();
                    errorHandler.call(e, this);
                    toast.showToast('Deleting failed', type: NotifType.error);
                  }
                },
                child: const BLText('Delete test data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
