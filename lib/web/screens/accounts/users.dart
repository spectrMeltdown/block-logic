import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/all_user.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Users extends ConsumerStatefulWidget {
  final List<String> userProps;
  const Users(this.userProps, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UsersState();
}

class _UsersState extends ConsumerState<Users> {
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(allUsersProvider);
    return users.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: BLText('There are no users at the moment...'),
            );
          }
          return BLTable(
              bottomPadding: 0,
              dataRowMaxHeight: 80,
              columns: List.generate(widget.userProps.length, (i) => DataColumn(label: BLText(widget.userProps[i]))),
              rows: List.generate(users.length, (i) {
                return DataRow(cells: [
                  DataCell(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BLProfilePic(type: AccountType.user, users[i].id ?? ''),
                  )),
                  DataCell(BLDisplayName(users[i].id ?? '', AccountType.user)),
                  DataCell(BLText(
                      users[i].createdAt != null ? DateFormat('dd / mm / yyyy').format(users[i].createdAt!) : '--')),
                  DataCell(Wrap(
                    children: [
                      BLAdminButton(
                          type: AdminBtnType.red,
                          child: const BLText('Delete'),
                          onPressed: () {
                            // TODO: connect to firebase admin sdk
                          })
                    ],
                  )),
                ]);
              }));
        },
        error: genericError,
        loading: genericLoading);
  }
}
