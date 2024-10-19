import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/button/toggle.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/all_challenges.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/creator_mode.dart';
import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:block_logic/screens/creator_mode/challange_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class EditRoomBottomSheet extends ConsumerStatefulWidget {
  final String roomID;
  const EditRoomBottomSheet(this.roomID, {super.key});

  @override
  ConsumerState<EditRoomBottomSheet> createState() => _EditRoomBottomSheetState();
}

class _EditRoomBottomSheetState extends ConsumerState<EditRoomBottomSheet> {
  TextEditingController roomNameController = TextEditingController();
  TextEditingController maxPlayersController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Challenge> selectedChallenges = [];
  bool includesPassword = false;
  bool processing = false;
  bool issetChallenges = false;
  bool isset = false;
  String? originalRoomName;
  Widget errorMsg = const BlankWidget();
  final newRoomFormKey = GlobalKey<FormState>();
  late final TextValidator textValidator;
  late final Toast toast;
  late final CreatorModeManager creatorMode;
  late final CustomNavigation nav;
  late final Encryption encryption; // for reading pass if already set

  bool updateSelection(Challenge challenge, {bool remove = false}) {
    if (remove) {
      // dPrint('updated in remove');
      setState(() {
        selectedChallenges.removeWhere((i) => i.id == challenge.id);
      });
      return true;
    } else {
      if (selectedChallenges.length == 5) {
        // dPrint('updated in length');
        return false;
      }
      // dPrint('updated in add');
      setState(() {
        selectedChallenges.add(challenge);
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final roomsProvider = ref.watch(SelectedRoomsProvider(FirebaseAuth.instance.currentUser!.uid)); // used to get currently existing room names, to prevent dups on room names
    final selectedRoom = ref.watch(SelectedRoomProvider(widget.roomID, futureOnly: true)); // set to future only, to avoid showing changes when updating
    final challenges = ref.watch(ChallengesProvider()); // to get challenges from challenge ids
    return PopScope(
      canPop: processing,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Background(
          child: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: SingleChildScrollView(
                        child: BLBorderedPanel(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                            child: selectedRoom.when(
                                data: (selectedRoom) {
                                  if (selectedRoom == null) {
                                    return const BLText('Couldn\'t find that room ...');
                                  }
                                  if (isset == false) {
                                    setState(() {
                                      roomNameController = TextEditingController(text: selectedRoom.name);
                                      maxPlayersController = TextEditingController(text: selectedRoom.maxPlayers.toString());
                                      if (selectedRoom.password != null) {
                                        passwordController = TextEditingController(text: encryption.decryptString(encrypted: selectedRoom.password!, key: selectedRoom.hostID!));
                                        includesPassword = true;
                                      }
                                    });
                                    isset = true;
                                    originalRoomName ??= selectedRoom.name;
                                    // TODO: set selected challenges
                                  }

                                  return roomsProvider.when(
                                      data: (rooms) {
                                        List<String> roomNames = [];
                                        for (final room in rooms) {
                                          roomNames.add(room.name ?? '');
                                        }
                                        return Form(
                                          key: newRoomFormKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [
                                                  BLBackButton(
                                                    paddingY: 0,
                                                    disabled: processing,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const BLSmallTitle(
                                                    'Edit room',
                                                    bottomPadding: 0,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const BLText('Room name'),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: BLTextBox(
                                                    prefixIcon: const Icon(
                                                      Icons.abc,
                                                    ),
                                                    labelText: 'My room',
                                                    keyboardType: TextInputType.name,
                                                    controller: roomNameController,
                                                    maxLength: 100,
                                                    validator: (roomName) => textValidator.validateRoomName(roomName),
                                                  ),
                                                ),
                                              ),
                                              const BLText('Max players'),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: BLTextBox(
                                                    prefixIcon: const Icon(
                                                      Icons.numbers,
                                                    ),
                                                    labelText: 'Max 20, min 1',
                                                    maxLength: 2,
                                                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                    keyboardType: TextInputType.number,
                                                    controller: maxPlayersController,
                                                    validator: (maxPlayers) => textValidator.validateMaxPlayers(maxPlayers),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const BLText('Require password?'),
                                                  const SizedBox(width: 10),
                                                  BLSwitch(
                                                      state: includesPassword,
                                                      onPressed: (newValue) {
                                                        setState(() {
                                                          includesPassword = newValue;
                                                        });
                                                      })
                                                ],
                                              ),
                                              Visibility(
                                                visible: includesPassword,
                                                child: Flexible(
                                                  child: WidgetAnimator(
                                                    incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
                                                    outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: BLTextBox(
                                                        prefixIcon: const Icon(
                                                          FontAwesomeIcons.lock,
                                                        ),
                                                        labelText: 'Your secure password ...',
                                                        controller: passwordController,
                                                        isObscure: true,
                                                        validator: (pass) => textValidator.validateRoomPass(pass),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const BLText('Selected Challenges :'),
                                              challenges.when(
                                                  data: (challenges) {
                                                    if (challenges.isEmpty) {
                                                      return const BLText('Sorry, there are no challenges available');
                                                    }
                                                    if (!issetChallenges) {
                                                      setState(() {
                                                        selectedChallenges = challenges.where((i) => selectedRoom.challengeIDs!.contains(i.id)).toList();
                                                        issetChallenges = true;
                                                      });
                                                    }
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        if (selectedChallenges.isNotEmpty)
                                                          ...List.generate(selectedChallenges.length, (i) {
                                                            final currentChallenge = selectedChallenges[i];
                                                            return Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 5),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Container(
                                                                    clipBehavior: Clip.antiAlias,
                                                                    decoration: const BoxDecoration(
                                                                      color: Colors.blueGrey,
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(20),
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        const SizedBox(width: 10),
                                                                        ConstrainedBox(
                                                                          constraints: const BoxConstraints(maxWidth: 150),
                                                                          child: BLText(
                                                                            currentChallenge.name ?? '--',
                                                                            softWrap: true,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(width: 10),
                                                                        ConstrainedBox(
                                                                          constraints: const BoxConstraints(maxWidth: 50),
                                                                          child: SingleChildScrollView(
                                                                            scrollDirection: Axis.horizontal,
                                                                            child: BLText(
                                                                              currentChallenge.difficulty?.capName() ?? '--',
                                                                              bold: true,
                                                                              color: currentChallenge.difficulty == Difficulty.beginner
                                                                                  ? Colors.green
                                                                                  : currentChallenge.difficulty == Difficulty.intermediate
                                                                                      ? Colors.amber
                                                                                      : Colors.deepOrange,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        CloseButton(
                                                                          onPressed: () {
                                                                            setState(() {
                                                                              selectedChallenges.removeWhere((challenge) => challenge.id == currentChallenge.id);
                                                                            });
                                                                          },
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            BLTextButton(
                                                                onPressed: () {
                                                                  nav.push(
                                                                    context,
                                                                    ChallengeSelector(
                                                                      initialSelection: selectedChallenges,
                                                                      updateSelection: updateSelection,
                                                                    ),
                                                                  );
                                                                },
                                                                child: const Row(
                                                                  children: [
                                                                    BLText(
                                                                      'Choose Challenges',
                                                                      color: Colors.green,
                                                                    ),
                                                                    Icon(
                                                                      Icons.arrow_forward,
                                                                      color: Colors.green,
                                                                    ),
                                                                  ],
                                                                )),
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  },
                                                  error: genericError,
                                                  loading: genericLoading),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                                child: Center(child: errorMsg),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                                  child: BLButton(
                                                    onPressed: () async {
                                                      if (newRoomFormKey.currentState!.validate()) {
                                                        if (processing == true) return;
                                                        processing = true;

                                                        // check if room name has a dup
                                                        if (originalRoomName != roomNameController.text.trim()) {
                                                          if (roomNames.contains(roomNameController.text.trim())) {
                                                            processing = false;
                                                            setState(() {
                                                              errorMsg = const BLText('A room with this name already exists. Try another.');
                                                            });
                                                            return;
                                                          }
                                                        }

                                                        // check if no challenges are selected
                                                        if (selectedChallenges.isEmpty) {
                                                          processing = false;
                                                          setState(() {
                                                            errorMsg = const BLText(
                                                              'You must select at least one challenge.',
                                                              color: Colors.red,
                                                            );
                                                          });
                                                          return;
                                                        }

                                                        final error = await creatorMode.editRoom(
                                                            Room(
                                                              id: selectedRoom.id,
                                                              hostID: FirebaseAuth.instance.currentUser!.uid,
                                                              name: selectedRoom.name == roomNameController.text.trim() ? null : roomNameController.text.trim(),
                                                              maxPlayers: selectedRoom.maxPlayers == int.parse(maxPlayersController.text.trim()) ? null : int.parse(maxPlayersController.text.trim()),
                                                              challengeIDs: selectedRoom.challengeIDs == selectedChallenges.map((i) => i.id!).toList() ? null : selectedChallenges.map((i) => i.id!).toList(),
                                                              password: selectedRoom.password.toString() == passwordController.text.trim()
                                                                  ? null
                                                                  : includesPassword == false
                                                                      ? null
                                                                      : passwordController.text.trim(),
                                                            ),
                                                            includesPassword ? false : true);
                                                        if (error != null) {
                                                          setState(() {
                                                            errorMsg = BLText(error);
                                                          });
                                                        } else {
                                                          if (!context.mounted) return;
                                                          nav.pop(context);
                                                        }
                                                        processing = false;
                                                      }
                                                    },
                                                    type: BtnType.green,
                                                    paddingX: 100,
                                                    child: const Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        BLText(
                                                          'Save',
                                                          size: 16,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      error: genericError,
                                      loading: genericLoading);
                                },
                                error: genericError,
                                loading: genericLoading),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: processing,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const BLLoading(
                    message: 'Processing ...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    textValidator = ref.read(textValidatorProvider.notifier);
    creatorMode = ref.read(creatorModeManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    encryption = ref.read(encryptionProvider.notifier);
    super.initState();
  }
}
