import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenge.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/challenge_manager.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/bl_segmented_button.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/screens/challenges/block_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CreateEditChallenge extends ConsumerStatefulWidget {
  final String selectedChallengeID;
  final bool createMode;
  const CreateEditChallenge({required this.createMode, this.selectedChallengeID = '', super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectedChallengeState();
}

class _SelectedChallengeState extends ConsumerState<CreateEditChallenge> {
  TextEditingController? additionalInfo;
  TextEditingController? shortDescription;
  TextEditingController? name;
  final tagBtnKey = GlobalKey();
  final limitationBtnKey = GlobalKey();
  late final Toast toast;
  List<String> tags = [];
  // List<String> limitations = [];
  int totalSelected = 0;
  late final DialogService dialog;
  Map<CodeBlockType, List<GameBlockData>>? blocks;
  bool processing = false;
  Difficulty? difficultySelection;
  late final ChallengeManager challengeManager;
  final formKey = GlobalKey<FormState>();
  final List<String> challengeProps = [
    'Name',
    'Short Description',
    'Additional Info',
    //'Limitations',
    'Blocks',
    'Difficulty',
    // 'Tags',
  ];

  void addTagPop(BuildContext context) async {
    if (processing) return;
    processing = true;
    final RenderBox button = tagBtnKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final tagController = TextEditingController();
    await showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: tagController.text,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Tag:'),
              const SizedBox(height: 8),
              BLTextBox(
                controller: tagController,
              ),
              BLAdminButton(
                type: AdminBtnType.green,
                child: const BLText('Save'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ],
      elevation: 8.0,
    );
    if (tagController.text.trim().isNotEmpty) {
      setState(() {
        tags.add(tagController.text.trim());
      });
    }
    processing = false;
  }

  @override
  void dispose() {
    dPrint('disposed!!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.createMode) dPrint('in edit challenge: ${widget.selectedChallengeID}');
    final selectedChallenge = ref.watch(SelectedChallengeProvider(widget.selectedChallengeID, createMode: widget.createMode));
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Header(title: '${widget.createMode ? 'Create' : 'Edit'} challenge'),
        SizedBox(height: 20),
        FadeIn(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000, minWidth: 200),
              child: selectedChallenge.when(
                  data: (challenge) {
                    if (challenge == null) {
                      return const Center(
                        child: BLText('Couldn\'t load that challenge..'),
                      );
                    }
                    if (!widget.createMode) {
                      tags = challenge.tags ?? [];
                      // limitations = challenge.limitations ?? [];
                      difficultySelection ??= challenge.difficulty;
                      blocks ??= challenge.blocks;
                      if (blocks != null) {
                        totalSelected = getCount(blocks!);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: BLCardSimple(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                ...List.generate(challengeProps.length, (i) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // spacing: 15,
                                    // runSpacing: 15,
                                    children: [
                                      const SizedBox(height: 10),
                                      BLText('${challengeProps[i]} : '),
                                      const SizedBox(height: 5),
                                      getInputWidget(challengeProps[i], challenge),
                                    ],
                                  );
                                }),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AdminBackBtn(
                                      useContext: true,
                                      text: 'Cancel',
                                    ),
                                    const SizedBox(width: 10),
                                    BLAdminButton(
                                      type: AdminBtnType.green,
                                      onPressed: () => save(),
                                      child: BLText(
                                        widget.selectedChallengeID.isEmpty ? 'Create' : 'Save changes',
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  error: widget.selectedChallengeID.isEmpty
                      ? (error, stackTrace) => ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: width <= desktopMin ? width * 0.8 : width * 0.4,
                            ),
                            child: const Center(
                              child: BLText('Select a challenge'),
                            ),
                          )
                      : genericError,
                  loading: genericLoading),
            ),
          ),
        )
      ],
    );
  }

  Widget getInputWidget(String challengeProp, Challenge challenge) {
    switch (challengeProp) {
      case 'Name':
        name ??= TextEditingController(text: challenge.name);
        return BLTextBox(
          controller: name,
          hintText: 'E.x Code is fun!',
          onFieldSubmitted: (p0) => save(),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Cannot be empty';
            }
            return null;
          },
        );
      case 'Short Description':
        shortDescription ??= TextEditingController(text: challenge.shortDescription);
        return BLTextBox(
          controller: shortDescription,
          keyboardType: TextInputType.multiline,
          hintText: 'E.x. Create an program ...',
          maxLines: null,
          onFieldSubmitted: (p0) => save(),
          validator: (text) {
            if (text == null || text.isEmpty) {
              return 'Cannot be empty';
            }
            return null;
          },
        );
      case 'Additional Info':
        additionalInfo ??= TextEditingController(text: challenge.additionalInfo);
        return BLTextBox(
          controller: additionalInfo,
          keyboardType: TextInputType.multiline,
          hintText: 'E.x. Use functions...',
          maxLines: null,
          onFieldSubmitted: (p0) => save(),
        );
      // case 'Limitations':
      //   return ChipStrip(
      //       btnKey: limitationBtnKey,
      //       onPressed: () => addLimitationPop(context),
      //       children: List.generate(
      //           limitations.length,
      //           (i) => BlChip(
      //                 label: BLText(limitations[i]),
      //                 onDeleted: () {
      //                   setState(() {
      //                     limitations.removeWhere((j) => limitations[i] == j);
      //                   });
      //                 },
      //               )));
      // case 'Tags':
      //   return ChipStrip(
      //       btnKey: tagBtnKey,
      //       onPressed: () => addTagPop(context),
      //       children: List.generate(
      //           tags.length,
      //           (i) => BlChip(
      //                 label: BLText(tags[i]),
      //                 onDeleted: () {
      //                   setState(() {
      //                     tags.removeWhere((j) => j == tags[i]);
      //                   });
      //                 },
      //               )));
      case 'Difficulty':
        return BlSegmentedButton(
            selected: {
              difficultySelection
            },
            segments: const [
              ButtonSegment(
                  value: Difficulty.beginner,
                  label: BLText('Beginner'),
                  icon: Icon(
                    Icons.circle,
                    color: Colors.green,
                  )),
              ButtonSegment(
                  value: Difficulty.intermediate,
                  label: BLText('Intermediate'),
                  icon: Icon(
                    Icons.circle,
                    color: Colors.amber,
                  )),
              ButtonSegment(
                  value: Difficulty.advanced,
                  label: BLText('Advanced'),
                  icon: Icon(
                    Icons.circle,
                    color: Colors.deepOrange,
                  ))
            ],
            onSelectionChanged: (selection) {
              dPrint(selection.toString());
              setState(() {
                difficultySelection = selection.first;
              });
            });
      case 'Blocks':
        return BLAdminButton(
            type: AdminBtnType.orange,
            onPressed: () async {
              if (processing) return;
              processing = true;
              final newBlocks = await dialog.show(
                  context,
                  BlockSelectorDialog(
                    initialBlocks: blocks ?? {},
                  ));
              if (newBlocks is Map<CodeBlockType, List<GameBlockData>>) {
                dPrint(newBlocks.toString());
                blocks = newBlocks;
                totalSelected = getCount(blocks!);
                setState(() {});
                // ref.invalidate(selectedChallengeProvider);
              } else {
                dPrint('blocks not updated!');
              }
              processing = false;
            },
            child: BLText(
              'Edit ($totalSelected selected)',
              color: Colors.white,
            ));
      default:
        return const BlankWidget();
    }
  }

  @override
  void initState() {
    dialog = ref.read(dialogServiceProvider.notifier);
    challengeManager = ref.read(challengeManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }

  void toggleProcessing() {
    setState(() {
      processing = !processing;
    });
  }

  Future<void> save() async {
    if (processing) return;
    toggleProcessing();
    if (formKey.currentState!.validate()) {
      // assert(shortDescription?.text.trim() is String);
      if (difficultySelection == null) {
        toast.showToast(context, 'Select a difficulty.', type: NotifType.error);
        toggleProcessing();
        return;
      }
      dPrint('blocks are: ${blocks?.values}');
      if (blocks == null || blocks!.values.isEmpty || blocks!.values.length <= 2) {
        toast.showToast(context, 'A minimum of 2 blocks must be selected.', type: NotifType.error);
        toggleProcessing();
        return;
      }
      final challenge = Challenge(
        id: widget.createMode ? null : widget.selectedChallengeID,
        name: name?.text.trim(),
        shortDescription: shortDescription?.text.trim(),
        additionalInfo: additionalInfo?.text.trim(),
        // limitations: limitations,
        tags: tags,
        difficulty: difficultySelection,
      );
      final result = widget.createMode ? await challengeManager.create(challenge) : await challengeManager.update(challenge);
      if (result == null) {
        if (!mounted) return;
        toast.showToast(context, widget.createMode ? 'Challenge created' : 'Edited successfully', type: NotifType.success);
        context.go('/challenges');
      } else {
        if (!mounted) return;
        toast.showToast(context, result.toString(), type: NotifType.error);
      }
    }
    toggleProcessing();
  }

  int getCount(Map<CodeBlockType, List<GameBlockData>> blocks) {
    int count = 0;
    for (final entry in blocks.entries) {
      for (int i = 0; i < entry.value.length; i++) {
        count++;
      }
    }
    return count;
  }
}
