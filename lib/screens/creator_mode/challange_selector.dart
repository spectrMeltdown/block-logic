import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_providers/all_challenges.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/screens/creator_mode/challenge_selector_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengeSelector extends ConsumerStatefulWidget {
  final List<Challenge> initialSelection;
  final bool Function(Challenge challenge, {bool remove}) updateSelection;
  const ChallengeSelector({
    required this.initialSelection,
    required this.updateSelection,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChallengeSelectorState();
}

class _ChallengeSelectorState extends ConsumerState<ChallengeSelector> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late final CustomNavigation nav;
  final List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced']; // don't change the order
  late List<Challenge> selection;
  late bool isset = false;
  @override
  void initState() {
    tabController = TabController(length: difficulties.length, vsync: this);
    nav = ref.read(customNavigationProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final challenges = ref.watch(ChallengesProvider());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
          child: SafeArea(
              child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const BLSmallTitle('Select challenges'),
          TabBar(
            controller: tabController,
            tabs: List.generate(
              difficulties.length,
              (i) => Tab(
                child: BLText(difficulties[i]),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: challenges.when(
                data: (challenges) {
                  if (challenges.isEmpty) {
                    return const Center(
                        child: BLText(
                      'There are no available \nchallenges at the moment.',
                      alignCenter: true,
                    ));
                  }
                  final challengesCategory = [
                    challenges.where((i) => i.difficulty == Difficulty.beginner).toList(),
                    challenges.where((i) => i.difficulty == Difficulty.intermediate).toList(),
                    challenges.where((i) => i.difficulty == Difficulty.advanced).toList(),
                  ];
                  final initialSelectionCategory = [
                    widget.initialSelection.where((i) => i.difficulty == Difficulty.beginner).toList(),
                    widget.initialSelection.where((i) => i.difficulty == Difficulty.intermediate).toList(),
                    widget.initialSelection.where((i) => i.difficulty == Difficulty.advanced).toList(),
                  ];
                  return BLBorderedPanel(
                    child: TabBarView(
                      controller: tabController,
                      children: List.generate(
                        difficulties.length,
                        (i) => ChallengeSelectorList(
                          initialSelection: initialSelectionCategory[i],
                          updateSelection: widget.updateSelection,
                          challenges: challengesCategory[i],
                        ),
                      ),
                    ),
                  );
                },
                error: genericError,
                loading: genericLoading),
          ),
          const SizedBox(
            height: 20,
          ),
          BLButton(
              onPressed: () {
                nav.pop(context);
              },
              type: BtnType.green,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check),
                  SizedBox(
                    width: 10,
                  ),
                  BLText(
                    'Done',
                    color: Colors.white,
                  )
                ],
              )),
          const SizedBox(
            height: 30,
          ),
        ],
      ))),
    );
  }
}
