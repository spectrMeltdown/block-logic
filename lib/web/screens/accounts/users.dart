import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/all_user.dart';
import 'package:block_logic/logic/services/accounts_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool processing = false;
  late final AccountsManager accountsManager;
  late final Toast toast;
  @override
  Widget build(BuildContext context) {
    final users = ref.watch(allUsersProvider);
    return users.when(
        data: (users) {
          /// admin cannot delete their user account from here. They must use Settings > Delete account instead.
          users.removeWhere((user) => user.id == FirebaseAuth.instance.currentUser!.uid);
          if (users.isEmpty) {
            return FadeIn(
              child: SizedBox(width: 400, height: 200, child: Center(child: BLText('There are no users at the moment...'))),
            );
          }
          return FadeIn(
            child: BLTable(
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
                    DataCell(BLText(users[i].createdAt != null ? DateFormat('dd / MM / yyyy').format(users[i].createdAt!) : '--')),
                    DataCell(Wrap(
                      children: [
                        BLAdminButton(
                            type: processing ? AdminBtnType.grey : AdminBtnType.red,
                            child: const BLText('Delete'),
                            onPressed: () async {
                              if (processing) return;
                              setState(() {
                                processing = true;
                              });
                              final result = await accountsManager.deleteAccount(users[i].id!, AccountType.user);
                              if (result == null) {
                                if (!context.mounted) return;
                                toast.showToast(context, 'Delete success.', type: NotifType.success);
                              } else {
                                if (!context.mounted) return;
                                toast.showToast(context, result, type: NotifType.error);
                              }
                              setState(() {
                                processing = false;
                              });
                            })
                      ],
                    )),
                  ]);
                })),
          );
        },
        error: genericError,
        loading: genericLoading);
  }

  @override
  void initState() {
    accountsManager = ref.read(accountsManagerProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    super.initState();
  }
}
