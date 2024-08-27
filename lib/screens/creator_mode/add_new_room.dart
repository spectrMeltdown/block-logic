import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/toggle.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/challenge.dart';
import 'package:block_logic/logic/firebase_providers/selected_room_names.dart';
import 'package:block_logic/logic/firebase_providers/selected_rooms.dart';
import 'package:block_logic/logic/services/creator_mode.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/validator_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class AddRoomBottomSheet extends ConsumerStatefulWidget {
  const AddRoomBottomSheet({super.key});

  @override
  ConsumerState<AddRoomBottomSheet> createState() => _AddRoomBottomSheetState();
}

class _AddRoomBottomSheetState extends ConsumerState<AddRoomBottomSheet> {
  final roomNameController = TextEditingController();
  final roomPassController = TextEditingController();
  final maxPlayersController = TextEditingController();
  final passwordController = TextEditingController();
  final List<Challenge> challenges = [];
  bool includesPassword = false;
  bool processing = false;
  Widget errorMsg = const BlankWidget();
  final newRoomFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ownRooms = ref.watch(SelectedRoomsProvider(FirebaseAuth.instance.currentUser?.uid ?? ''));
    final textValidator = ref.read(textValidatorProvider.notifier);
    final creatorMode = ref.read(creatorModeProvider.notifier);
    final nav = ref.read(customNavigationProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ownRooms.when(
              data: (rooms) {
                final roomNamesProvider = ref.watch(SelectedRoomNamesProvider(rooms));
                return roomNamesProvider.when(
                    data: (roomNames) {
                      return Form(
                        key: newRoomFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const BLSmallTitle('Create new room'),
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
                                      labelText: '*****',
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
                                      if (processing == true) {
                                        return;
                                      }
                                      processing = true;
                                      if (roomNames.contains(roomNameController.text.trim())) {
                                        processing = false;
                                      }
                                      final success = await creatorMode.addRoom(
                                          roomName: roomNameController.text.trim(),
                                          maxPlayers: int.tryParse(maxPlayersController.text.trim()) ?? -1,
                                          challenges: challenges,
                                          password:
                                              passwordController.text.isEmpty ? passwordController.text.trim() : null);
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
                    loading: genericLoading);
              },
              error: genericError,
              loading: genericLoading)),
    );
  }
}
