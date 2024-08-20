import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/firebase_providers/all_admin.dart';
import 'package:block_logic/logic/firebase_providers/all_user.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Accounts extends ConsumerStatefulWidget {
  const Accounts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountsState();
}

class _AccountsState extends ConsumerState<Accounts> {
  final pageScrollController = ScrollController();
  final searchController = TextEditingController();
  late String selectedAccType;
  final List<String> accTypes = [
    'Users',
    'Admins',
  ];
  final List<String> userProps = [
    'Pic',
    'Display Name',
    'Created At',
  ];
  late final List<String> adminProps;
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(allUsersProvider);
    final admins = ref.watch(allAdminsProvider);
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                            Flexible(
                                child: AdminSearchBar(
                                    searchController: searchController)),
                          ],
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: BLCardSimple(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  getWidget(
                                      admins: admins,
                                      users: users,
                                      selection: selectedAccType),
                                  SizedBox(
                                    height: height / 70,
                                  ),
                                  if (selectedAccType == 'Admins')
                                    BLAdminButton(
                                        type: AdminBtnType.teal,
                                        onPressed: () {},
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.add,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 5),
                                            BLText('Add admin')
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

  Widget getWidget({
    required AsyncValue<List<AdminAccount>> admins,
    required AsyncValue<List<UserAccount>> users,
    required String selection,
  }) {
    switch (selection) {
      case 'Users':
        return users.when(
            data: (users) {
              if (users.isEmpty) {
                return const Center(
                  child: BLText('There are no users at the moment...'),
                );
              }
              users.removeWhere((users) =>
                  users.id == FirebaseAuth.instance.currentUser!.uid);
              if (users.isEmpty) {
                return const Center(
                  child: BLText('There are no users at the moment...'),
                );
              }
              return BLTable(
                  columns: List.generate(userProps.length,
                      (i) => DataColumn(label: BLText(userProps[i]))),
                  rows: List.generate(users.length, (i) {
                    return DataRow(cells: [
                      DataCell(BLProfilePic(users[i].id ?? '')),
                      DataCell(BLDisplayName(users[i].displayName ?? '')),
                      DataCell(BLText(DateFormat('dd / mm / yyyy')
                          .format(users[i].createdAt!))),
                    ]);
                  }));
            },
            error: genericError,
            loading: genericLoading);
      default:
        return admins.when(
            data: (admins) {
              if (admins.isEmpty) {
                return const Center(
                  child: BLText('There are no other admins at the moment...'),
                );
              }
              admins.removeWhere((admin) =>
                  admin.id == FirebaseAuth.instance.currentUser!.uid);
              if (admins.isEmpty) {
                return const Center(
                  child: BLText('There are no other admins at the moment...'),
                );
              }
              return BLTable(
                  columns: List.generate(adminProps.length,
                      (i) => DataColumn(label: BLText(adminProps[i]))),
                  rows: List.generate(admins.length, (i) {
                    return DataRow(cells: [
                      DataCell(BLProfilePic(admins[i].id ?? '')),
                      DataCell(BLDisplayName(admins[i].displayName ?? '')),
                      DataCell(BLText(DateFormat('dd / mm / yyyy')
                          .format(admins[i].createdAt!))),
                      DataCell(BLText(admins[i].isApproved == null
                          ? '--'
                          : admins[i].isApproved == true
                              ? 'Yes'
                              : 'No')),
                    ]);
                  }));
            },
            error: genericError,
            loading: genericLoading);
    }
  }

  @override
  void initState() {
    selectedAccType = accTypes.first;
    adminProps = [...userProps, 'Is Approved'];
    super.initState();
  }
}
