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
import 'package:block_logic/logic/firebase_providers/selected_room_names.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/creator_mode.dart';
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

class AddRoomBottomSheet extends ConsumerStatefulWidget {
  const AddRoomBottomSheet({super.key});

  @override
  ConsumerState<AddRoomBottomSheet> createState() => _AddRoomBottomSheetState();
}

class _AddRoomBottomSheetState extends ConsumerState<AddRoomBottomSheet> {
  late final roomNameController = TextEditingController();
  late final maxPlayersController = TextEditingController();
  late final passwordController = TextEditingController();
  final List<Challenge> availableChallenges = [];
  final List<String> selectedChallengeIDs = [];
  final List<ChallengeSelector> challengeSelectors = [];
  bool includesPassword = false;
  bool processing = false;
  bool issetChallenges = false;
  int maxChallenges = 0;
  Widget errorMsg = const BlankWidget();
  final newRoomFormKey = GlobalKey<FormState>();
  late final TextValidator textValidator;
  late final Toast toast;
  late final CreatorModeManager creatorMode;
  late final CustomNavigation nav;

  void addChallengeSelector() {
    if (maxChallenges != challengeSelectors.length) {
      if (challengeSelectors.length < 5) {
        final challengeSelector = ChallengeSelector(
          removeChallengeID: removeChallengeID,
          availableChallenges: availableChallenges,
          addChallengeID: addChallengeID,
          removeChallengeSelector: removeChallengeSelector,
          addChallengeSelector: addChallengeSelector,
          index: challengeSelectors.length,
        );
        setState(() {
          challengeSelectors.add(challengeSelector);
        });
        return;
      } else {
        toast.showToast('Maximum of 5 only.', type: NotifType.error);
      }
    }
    toast.showToast('Cannot exceed number of available challenges.', type: NotifType.error);
  }

  void removeChallengeSelector(int index) {
    setState(() {
      challengeSelectors.removeAt(index);
    });
  }

  void addChallengeID(String challengeID) {
    setState(() {
      selectedChallengeIDs.add(challengeID);
    });
  }

  void removeChallengeID(String challengeID) {
    setState(() {
      selectedChallengeIDs.remove(challengeID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ownRooms = ref.watch(SelectedRoomsProvider(FirebaseAuth.instance.currentUser!.uid));
    final challenges = ref.watch(challengesProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: BLBorderedPanel(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                    child: ownRooms.when(
                        data: (rooms) {
                          final roomNames = ref.read(SelectedRoomNamesProvider(rooms));
                          return Form(
                            key: newRoomFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  children: [
                                    BLBackButton(paddingY: 0),
                                    BLSmallTitle(
                                      'Create new room',
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
                                const BLText('Challenges (maximum of 5)'),
                                challenges.when(
                                    data: (challenges) {
                                      if (challenges.isEmpty) {
                                        return const BLText('Sorry, there are no challenges available');
                                      }
                                      if (!issetChallenges) {
                                        maxChallenges = challenges.length;
                                        issetChallenges = true;
                                        availableChallenges.addAll(challenges);
                                      }
                                      return Column(
                                        children: [
                                          const SizedBox(height: 15),
                                          if (challengeSelectors.isNotEmpty)
                                            ...List.generate(challengeSelectors.length, (i) {
                                              return challengeSelectors[i];
                                            }),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              BLTextButton(
                                                  onPressed: () {
                                                    addChallengeSelector();
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.add,
                                                        color: Colors.green,
                                                      ),
                                                      BLText(
                                                        'Add Challenge',
                                                        color: Colors.green,
                                                      )
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

                                          // check if the input room name has a duplicate
                                          if (roomNames.contains(roomNameController.text.trim())) {
                                            processing = false;
                                            setState(() {
                                              errorMsg =
                                                  const BLText('A room with this name already exists. Try another.');
                                            });
                                            return;
                                          }

                                          // check if no challenge ids are selected
                                          if (selectedChallengeIDs.isEmpty) {
                                            processing = false;
                                            setState(() {
                                              errorMsg = const BLText(
                                                'You must select at least one challenge.',
                                                color: Colors.red,
                                              );
                                            });
                                            return;
                                          }

                                          // add the room
                                          final error = await creatorMode.addRoom(Room(
                                            adminLocked: false,
                                            hostID: FirebaseAuth.instance.currentUser!.uid,
                                            players: [],
                                            status: RoomStatus.available,
                                            name: roomNameController.text.trim(),
                                            maxPlayers: int.parse(maxPlayersController.text.trim()),
                                            challengeIDs: selectedChallengeIDs,
                                            password: includesPassword == false ? null : passwordController.text.trim(),
                                          ));
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
                                            'Create',
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
                        loading: genericLoading),
                  ),
                ),
              ),
            ),
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
    nav = ref.read(customNavigationProvider);
    super.initState();
  }
}
