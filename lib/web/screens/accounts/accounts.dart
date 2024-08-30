import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:block_logic/web/screens/accounts/admins.dart';
import 'package:block_logic/web/screens/accounts/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  final pageScrollController = ScrollController();
  late String selectedAccType;
  String searchQuery = '';
  final List<String> accTypes = [
    'Users',
    'Admins',
  ];
  final List<String> userProps = [
    'Profile Pic',
    'Display Name',
    'Created At',
    'Actions',
  ];
  late final List<String> adminProps;
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: pageScrollController,
            child: SingleChildScrollView(
              controller: pageScrollController,
              child: Column(
                children: [
                  const Header(title: 'Accounts'),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BLCardSimple(
                              child: DropdownButton<String>(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                underline: const SizedBox.shrink(),
                                value: selectedAccType,
                                items: accTypes.map((acc) {
                                  return DropdownMenuItem<String>(
                                    value: acc,
                                    child: Text(acc),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedAccType = newValue ?? '';
                                  });
                                },
                                hint: const BLText('Select a option'),
                              ),
                            ),
                            AdminSearchBar((newQuery) {
                              setState(() {
                                searchQuery = newQuery;
                              });
                            }),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: BLCardSimple(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  selectedAccType == accTypes[0] ? Users(userProps) : Admins(adminProps),
                                  SizedBox(
                                    height: height * 0.1,
                                  ),
                                  BLAdminButton(
                                      type: AdminBtnType.teal,
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 5),
                                          BLText(selectedAccType == accTypes[0] ? 'Add user' : 'Add admin')
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    selectedAccType = accTypes.first;
    adminProps = [...userProps];
    super.initState();
  }
}
