import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/error.dart';
import 'package:block_logic/components/panel.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/room_in_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Game extends ConsumerStatefulWidget {
  const Game({required this.roomID, super.key});
  final String roomID;

  @override
  ConsumerState<Game> createState() => _GameState();
}

class _GameState extends ConsumerState<Game> {
  @override
  Widget build(BuildContext context) {
    //TODO: have a gamehost controller that will react to host actions, like when game start
    //final gameHost = ref.watch(gameHostProvider);
    final room = ref.watch(GameRoomProvider(widget.roomID));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Background(
          child: room.when(
        data: (room) {
          if (room == null) return const BLError();
          return const Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  BLBorderedPanel(Icon(FontAwesomeIcons.pause)),
                ],
              ),
            ],
          );
        },
        error: genericError,
        loading: () {
          return const BLLoading();
        },
      )),
    );
  }
}
