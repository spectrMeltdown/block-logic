import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_providers/selected_challenge.dart';
import 'package:block_logic/logic/game/block_data.dart';
import 'package:block_logic/logic/services/challenge_manager.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/bl_chip.dart';
import 'package:block_logic/web/components/bl_segmented_button.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/screens/challenges/block_selector_dialog.dart';
import 'package:block_logic/web/screens/challenges/chip_strip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditChallenge extends ConsumerStatefulWidget {
  final String selectedChallengeID;
  const EditChallenge(this.selectedChallengeID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectedChallengeState();
}

class _SelectedChallengeState extends ConsumerState<EditChallenge> {
  final tagBtnKey = GlobalKey();
  final limitationBtnKey = GlobalKey();
  late final Toast toast;
  List<String> tags = [];
  List<String> limitations = [];
  String? shortDescription;
  String? additionalInfo;
  String? name;
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
              BLAdminButton(type: AdminBtnType.green, child: const BLText('Save'), onPressed: () => Navigator.pop(context))
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
  Widget build(BuildContext context) {
    final selectedChallenge = ref.watch(SelectedChallengeProvider(widget.selectedChallengeID));
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Header(title: 'Edit challenge'),
        selectedChallenge.when(
            data: (challenge) {
              if (challenge == null) {
                return ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600, maxHeight: 500),
                  child: const Center(
                    child: BLText('Couldn\'t load that challenge..'),
                  ),
                );
              }
              tags = challenge.tags ?? [];
              limitations = challenge.limitations ?? [];
              difficultySelection ??= challenge.difficulty;
              blocks ??= challenge.blocks;
              if (blocks != null) {
                int count = 0;
                for (final entry in blocks!.entries) {
                  for (final block in entry.value) {
                    count++;
                  }
                }
                totalSelected = count;
              }
              return FadeIn(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: BLCardSimple(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                ...List.generate(challengeProps.length, (i) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // spacing: 15,
                                    // runSpacing: 15,
                                    children: [
                                      const SizedBox(height: 10),
                                      BLText('${challengeProps[i]} : '),
                                      const SizedBox(height: 5),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 700),
                                        child: getInputWidget(challengeProps[i], challenge),
                                      ),
                                    ],
                                  );
                                }),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const AdminBackBtn(
                                      useContext: true,
                                    ),
                                    const SizedBox(width: 10),
                                    BLAdminButton(
                                        type: AdminBtnType.green,
                                        onPressed: () {
                                          save();
                                        },
                                        child: const BLText('Save changes', color: Colors.white))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
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
                        maxHeight: height * 0.5,
                      ),
                      child: const Center(
                        child: BLText('Select a challenge'),
                      ),
                    )
                : genericError,
            loading: genericLoading)
      ],
    );
  }

  Widget getInputWidget(String challengeProp, Challenge challenge) {
    switch (challengeProp) {
      case 'Name':
        return BLTextBox(
          controller: TextEditingController(text: challenge.name),
          onSaved: (value) {
            name = value;
          },
        );
      case 'Short Description':
        return BLTextBox(
          controller: TextEditingController(text: challenge.shortDescription),
          keyboardType: TextInputType.multiline,
          onSaved: (value) {
            shortDescription = value;
          },
          maxLines: null,
        );
      case 'Additional Info':
        return BLTextBox(
          controller: TextEditingController(text: challenge.additionalInfo),
          keyboardType: TextInputType.multiline,
          onSaved: (value) {
            additionalInfo = value;
          },
          maxLines: null,
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
              debugPrint(selection.toString());
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
              await dialog.show(
                  context,
                  BlockSelectorDialog(
                    initialBlocks: blocks,
                  ));
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

  Future<void> save() async {
    if (processing) return;
    processing = true;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final challenge = Challenge(
        id: widget.selectedChallengeID,
        name: name,
        shortDescription: shortDescription,
        additionalInfo: additionalInfo,
        limitations: limitations,
        tags: tags,
        difficulty: difficultySelection,
      );
      final result = await challengeManager.update(challenge);
      if (result == null) {
        if (!mounted) return;
        toast.showToast(context, 'Edited successfully', type: NotifType.success);
      } else {
        if (!mounted) return;
        toast.showToast(context, result.toString(), type: NotifType.error);
      }
    }
    processing = false;
  }
}
