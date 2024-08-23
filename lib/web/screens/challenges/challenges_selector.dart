import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/all_challenges.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengesSelector extends ConsumerStatefulWidget {
  final void Function(String) updateSelectedChallengeID;
  const ChallengesSelector(this.updateSelectedChallengeID, {super.key});

  @override
  ConsumerState<ChallengesSelector> createState() => _ChallengesSelectorState();
}

class _ChallengesSelectorState extends ConsumerState<ChallengesSelector> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final challenges = ref.watch(challengesProvider);
    return challenges.when(
        data: (challenges) {
          if (challenges.isEmpty) {
            return const Center(
              child: BLText('No challenges found.'),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(15),
            child: BLTable(
              columns: const [
                DataColumn(label: BLText('Name')),
                DataColumn(label: BLText('Short Description')),
                DataColumn(label: BLText('Difficulty')),
                DataColumn(label: BLText('Tags')),
              ],
              rows: List.generate(challenges.length, (i) {
                return DataRow(
                    onSelectChanged: (value) {
                      widget.updateSelectedChallengeID(challenges[i].id!);
                    },
                    cells: [
                      DataCell(BLText(challenges[i].name ?? '--')),
                      DataCell(
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width * 0.1),
                          child: BLText(
                            challenges[i].shortDescription ?? 'Not set',
                            softWrap: true,
                            maxLines: 3,
                          ),
                        ),
                      ),
                      DataCell(BLText(challenges[i].difficulty?.name ?? '--')),
                      DataCell(Row(
                        children:
                            List.generate(challenges[i].tags!.length, (j) {
                          return BLText(challenges[i].tags![j]);
                        }),
                      )),
                    ]);
              }),
            ),
          );
        },
        error: genericError,
        loading: genericLoading);
  }
}
