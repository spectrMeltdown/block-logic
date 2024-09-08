import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengeSelector extends ConsumerStatefulWidget {
  final void Function() addChallengeSelector;
  final void Function(int) removeChallengeSelector;
  final void Function(String) addChallengeID;
  final void Function(String) removeChallengeID;
  final List<Challenge> availableChallenges;
  final int index;
  final String? initialSelection;
  const ChallengeSelector({
    required this.removeChallengeID,
    required this.availableChallenges,
    required this.addChallengeID,
    required this.removeChallengeSelector,
    required this.addChallengeSelector,
    required this.index,
    this.initialSelection,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChallangeSelectorState();
}

class _ChallangeSelectorState extends ConsumerState<ChallengeSelector> {
  String? selectedChallengeID;
  String selectedChallengeName = '';

  @override
  void initState() {
    selectedChallengeID = widget.initialSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration:
                const BoxDecoration(color: Colors.blueGrey, borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 10),
                DropdownButton<String>(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  value: selectedChallengeID,
                  underline: const SizedBox.shrink(),
                  items: widget.availableChallenges.map((challenge) {
                    return DropdownMenuItem<String>(
                      value: challenge.id,
                      child: BLText(challenge.name ?? '--'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (selectedChallengeID != null) {
                      widget.removeChallengeID.call(selectedChallengeID!);
                    }
                    widget.addChallengeID.call(newValue!);
                    setState(() {
                      selectedChallengeID = newValue;
                    });
                  },
                  hint: const BLText('(Select challenge)'),
                ),
                CloseButton(
                  onPressed: () {
                    if (selectedChallengeID != null) {
                      widget.removeChallengeID.call(selectedChallengeID!);
                    }
                    widget.removeChallengeSelector.call(widget.index);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
