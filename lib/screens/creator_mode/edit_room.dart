import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/toggle.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/room.dart';
import 'package:block_logic/logic/firebase_providers/selected_room.dart';
import 'package:block_logic/logic/firebase_providers/selected_room_names.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/creator_mode.dart';
import 'package:block_logic/logic/services/encryption.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
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
  bool includesPassword = false;
  final List<String> challengeIDs = [];
  bool processing = false;
  bool isset = false;
  Widget errorMsg = const BlankWidget();
  final newRoomFormKey = GlobalKey<FormState>();
  late final TextValidator textValidator;
  late final CreatorModeManager creatorMode;
  late final CustomNavigation nav;
  late final Encryption encryption;
  @override
  Widget build(BuildContext context) {
    final roomsProvider = ref.watch(SelectedRoomsProvider(FirebaseAuth.instance.currentUser!.uid));
    final selectedRoom = ref.watch(SelectedRoomProvider(widget.roomID));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      passwordController = TextEditingController(
                          text: encryption.decryptString(encrypted: selectedRoom.password!, key: selectedRoom.hostID!));
                      includesPassword = true;
                    }
                  });
                  isset = true;
                }

                return roomsProvider.when(
                    data: (rooms) {
                      final roomNames = ref.read(SelectedRoomNamesProvider(rooms));
                      return Form(
                        key: newRoomFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const BLSmallTitle('Edit room'),
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
                                  labelText: '10',
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
                            const BLText('Challenges (max 5)'),
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
                                      if (roomNames.contains(roomNameController.text.trim())) {
                                        processing = false;
                                        setState(() {
                                          errorMsg = const BLText('A room with this name already exists. Try another.');
                                        });
                                        return;
                                      }
                                      final success = await creatorMode.editRoom(Room(
                                        id: selectedRoom.id,
                                        hostID: FirebaseAuth.instance.currentUser!.uid,
                                        name: roomNameController.text.trim(),
                                        maxPlayers: int.parse(maxPlayersController.text.trim()),
                                        challengeIDs: challengeIDs,
                                        password:
                                            passwordController.text.isNotEmpty ? passwordController.text.trim() : null,
                                      ));
                                      if (success == null) {
                                        if (!context.mounted) return;
                                        nav.pop(context);
                                      } else {
                                        // toast.showToast(success);
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
              loading: genericLoading)),
    );
  }

  @override
  void initState() {
    textValidator = ref.read(textValidatorProvider.notifier);
    creatorMode = ref.read(creatorModeManagerProvider.notifier);
    nav = ref.read(customNavigationProvider);
    encryption = ref.read(encryptionProvider.notifier);
    super.initState();
  }
}
