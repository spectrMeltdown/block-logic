import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/screens/creator_mode/challenge_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengeSelectorList extends ConsumerStatefulWidget {
  final bool Function(Challenge challenge, {bool remove}) updateSelection;
  final List<Challenge> initialSelection;
  final List<Challenge> challenges;
  const ChallengeSelectorList({
    required this.challenges,
    required this.initialSelection,
    required this.updateSelection,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChallengeSelectorListState();
}

class _ChallengeSelectorListState extends ConsumerState<ChallengeSelectorList> {
  @override
  Widget build(BuildContext context) {
    debugPrint('REBUILT LIST');
    if (widget.challenges.isEmpty) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: BLText(
          'There are no available challenges of this category.',
          softWrap: true,
          alignCenter: true,
        ),
      ));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.challenges.length,
        itemBuilder: (context, i) {
          return ChallengeItem(
            initialSelection: widget.initialSelection,
            challenge: widget.challenges[i],
            updateSelection: widget.updateSelection,
          );
        },
      ),
    );
  }
}

class ChallengeItem extends ConsumerStatefulWidget {
  final Challenge challenge;
  final List<Challenge> initialSelection;
  final bool Function(Challenge challenge, {bool remove}) updateSelection;
  const ChallengeItem({
    required this.initialSelection,
    required this.challenge,
    required this.updateSelection,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChallengeItemState();
}

class _ChallengeItemState extends ConsumerState<ChallengeItem> with AutomaticKeepAliveClientMixin {
  late final DialogService dialog;
  late final Toast toast;
  bool selected = false;
  @override
  void initState() {
    toast = ref.read(toastProvider.notifier);
    dialog = ref.read(dialogServiceProvider.notifier);
    selected = widget.initialSelection.any((j) => j.id == widget.challenge.id);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    debugPrint('REBUILT');
    return GestureDetector(
      onLongPress: () {
        dialog.show(
          context,
          ChallengeDetails(challenge: widget.challenge),
        );
      },
      child: SwitchListTile(
        value: selected,
        onChanged: (value) {
          debugPrint(value.toString());
          if (value) {
            if (widget.updateSelection(widget.challenge) == false) {
              if (!context.mounted) return;
              toast.showToast(context, 'Maximum challenges selected.', type: NotifType.error);
            } else {
              setState(() {
                selected = value;
              });
            }
          } else {
            setState(() {
              selected = value;
            });
            widget.updateSelection(widget.challenge, remove: true);
          }
        },
        title: BLText(widget.challenge.name!),
      ),
    );
  }
}
