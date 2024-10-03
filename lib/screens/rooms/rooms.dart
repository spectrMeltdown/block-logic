import 'package:block_logic/components/background.dart';
import 'package:block_logic/components/button/back.dart';
import 'package:block_logic/components/dialog/help.dart';
import 'package:block_logic/components/panel/bordered.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/logic/services/ui.dart';
import 'package:block_logic/screens/rooms/public_rooms.dart';
import 'package:block_logic/screens/rooms/user_rooms.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoomSelector extends ConsumerStatefulWidget {
  const RoomSelector({super.key});

  @override
  ConsumerState<RoomSelector> createState() => _RoomSelectorState();
}

class _RoomSelectorState extends ConsumerState<RoomSelector> with TickerProviderStateMixin {
  late final TabController tabController;
  final searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Background(
            child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const BLBackButton(),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const BLHelpDialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      BLText(
                                        'Can\'t find your room?',
                                        bold: true,
                                      ),
                                      BLText(
                                        '- It is possible that your room has been locked by the admin.\n\nPlease message the admin through feedback in the main menu screen if you think this is a mistake.',
                                        softWrap: true,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ));
                      },
                      icon: const Icon(FontAwesomeIcons.circleQuestion))
                ]),
              ),
              const BLTitle('Rooms'),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: BLTextBox(
                        controller: searchController,
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        ),
                        labelText: 'Search ...',
                        // suffixIcon: const Icon(
                        //   FontAwesomeIcons.arrowRightLong,
                        //   color: Colors.white,
                        //   size: 20,
                        // ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: BLBorderedPanel(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TabBar(indicatorColor: BLUI().getAppColor(''), labelColor: BLUI().getAppColor(''), dividerColor: BLUI().getAppColor(''), controller: tabController, tabs: const [Tab(text: 'Public rooms'), Tab(text: 'Your rooms')]),
                              SizedBox(
                                width: double.maxFinite,
                                height: mediaQuery.size.height / 1.6,
                                child: TabBarView(
                                  clipBehavior: Clip.antiAlias,
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: tabController,
                                  children: [
                                    PublicRooms(searchQuery: searchQuery),
                                    UserRooms(searchQuery: searchQuery),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  @override
  void initState() {
    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: '"Python is Awesome!"',
    //       shortDescription: 'Like printing "Hello, World".',
    //       additionalInfo: 'Involves printing, variables, and string concatenation.',
    //       blocks: AllBlocks().pythonIsAwesome(),
    //       difficulty: Difficulty.beginner,
    //       solutionMatch: ['Python is Awesome!'],
    //     ).toJSON());
    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Count characters',
    //       shortDescription: 'Write a program that assigns a string and counts how many characters it contains.',
    //       additionalInfo: 'Involves loops and string manipulation.',
    //       blocks: AllBlocks().countChars(),
    //       difficulty: Difficulty.beginner,
    //       solutionMatch: ['The string has 6 characters.'],
    //     ).toJSON());
    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Sum of two numbers',
    //       shortDescription: 'Write a program that assigns two numbers and outputs their sum.',
    //       additionalInfo: 'Involves simple arithmetic operations in Python.',
    //       blocks: AllBlocks().sumOfTwoNumbers(),
    //       difficulty: Difficulty.beginner,
    //       solutionMatch: ['The sum is: 15'],
    //     ).toJSON());
    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Odd or Even?',
    //       shortDescription: 'Write a program that assigns a number and checks if the number is odd or even.',
    //       additionalInfo: 'If the number is divisible by 2 with no remainder, it\'s even; otherwise, it\'s odd.',
    //       blocks: AllBlocks().oddOrEven(),
    //       difficulty: Difficulty.beginner,
    //       solutionMatch: ['The number is odd.', 'The number is even.'],
    //     ).toJSON());
    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: '"Hello, World!"',
    //       shortDescription: 'Write a program that prints the string "Hello, World!" to the console.',
    //       additionalInfo: 'Simple printing in Python.',
    //       blocks: AllBlocks().helloWorld(),
    //       difficulty: Difficulty.beginner,
    //       solutionMatch: ['Hello, World!'],
    //     ).toJSON());

    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Prime Number Check',
    //       shortDescription: 'Write a program that checks if a given positive integer n is a prime number. A prime number is a number greater than 1 that is divisible only by 1 and itself.',
    //       additionalInfo: 'For example, 7 is a prime number, but 10 is not because it is divisible by 2 and 5.',
    //       blocks: AllBlocks().primeNumCheck(),
    //       difficulty: Difficulty.intermediate,
    //       solutionMatch: [true],
    //     ).toJSON());

    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Sum of first N natural Numbers',
    //       shortDescription: 'Write a program that calculates the sum of the first n natural numbers.',
    //       additionalInfo: ' The sum of the first n natural numbers is given by the formula n * (n + 1) / 2. For example, if n = 10, the sum is 1 + 2 + ... + 10 = 55.',
    //       blocks: AllBlocks().sumOfNaturalNumbers(),
    //       difficulty: Difficulty.intermediate,
    //       solutionMatch: [55],
    //     ).toJSON());

    // FirebaseDatabase.instance.ref('challenges').doc().set(
    //       Challenge(
    //         name: 'Palindrome',
    //         shortDescription: 'Write a program that checks if a given string is a palindrome.',
    //         additionalInfo: 'A palindrome is a word, phrase, or sequence that reads the same forwards as it does backwards. Ignore case. For example, the string "madam" is a palindrome, but "hello" is not.',
    //         blocks: AllBlocks().palindromeCheck(),
    //         difficulty: Difficulty.intermediate,
    //         solutionMatch: [true],
    //       ).toJSON(),
    //     );

    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Factorial',
    //       shortDescription: 'Given a positive integer n, write a program to compute the factorial of n.',
    //       additionalInfo: 'The factorial of a number is the product of all positive integers from 1 to n. For example, 5! = 5 * 4 * 3 * 2 * 1 = 120.',
    //       blocks: AllBlocks().factorial(),
    //       difficulty: Difficulty.intermediate,
    //       solutionMatch: [120],
    //     ).toJSON());

    // FirebaseDatabase.instance.ref('challenges').doc().set(Challenge(
    //       name: 'Sum of digits',
    //       shortDescription: 'Given a positive integer n, write a program to calculate the sum of its digits.',
    //       additionalInfo: ' For example, if n = 123, the sum of its digits is 1 + 2 + 3 = 6.',
    //       blocks: AllBlocks().sumOfDigits(),
    //       difficulty: Difficulty.intermediate,
    //       solutionMatch: [6],
    //     ).toJSON());
    tabController = TabController(length: 2, vsync: this);
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.trim();
      });
    });
    super.initState();
  }
}
