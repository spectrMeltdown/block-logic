import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/dialog.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:block_logic/web/screens/accounts/admins.dart';
import 'package:block_logic/web/screens/accounts/create_admin.dart';
import 'package:block_logic/web/screens/accounts/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  late final DialogService dialog;
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
  void initState() {
    selectedAccType = accTypes.first;
    adminProps = [...userProps];
    dialog = ref.read(dialogServiceProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      padding: EdgeInsets.zero,
      controller: pageScrollController,
      children: [
        const Header(title: 'Accounts'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000, minWidth: 200, minHeight: 200),
          child: Padding(
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
                BLCardSimple(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        selectedAccType == accTypes[0] ? Users(userProps) : Admins(adminProps),
                        SizedBox(
                          height: height * 0.1,
                        ),
                        if (selectedAccType == accTypes[1])
                          BLAdminButton(
                              type: AdminBtnType.teal,
                              onPressed: () async {
                                if (processing) return;
                                processing = true;
                                await dialog.show(context, const CreateAdmin());
                                processing = false;
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  BLText('Add admin')
                                  // BLText(selectedAccType == accTypes[0] ? 'Add user' : 'Add admin')
                                ],
                              ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
