import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/account/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/all_admin.dart';
import 'package:block_logic/logic/services/accounts_manager.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class Admins extends ConsumerStatefulWidget {
  final List<String> adminProps;
  const Admins(this.adminProps, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminsState();
}

class _AdminsState extends ConsumerState<Admins> {
  bool processing = false;
  late final AccountsManager accountsManager;
  late final Toast toast;
  @override
  Widget build(BuildContext context) {
    final admins = ref.watch(allAdminsProvider);
    return admins.when(
        data: (admins) {
          /// admin cannot delete themself here. They must use Settings > Delete account instead.
          admins.removeWhere((admin) => admin.id == FirebaseAuth.instance.currentUser!.uid);
          if (admins.isEmpty) {
            return const Center(
              child: BLText('There are no other admins at the moment...'),
            );
          }
          return BLTable(
              columns: List.generate(widget.adminProps.length, (i) => DataColumn(label: BLText(widget.adminProps[i]))),
              rows: List.generate(admins.length, (i) {
                return DataRow(cells: [
                  DataCell(BLProfilePic(type: AccountType.admin, admins[i].id ?? '')),
                  DataCell(BLDisplayName(admins[i].id ?? '', AccountType.admin)),
                  DataCell(BLText(admins[i].createdAt != null ? DateFormat('dd / MM / yyyy').format(admins[i].createdAt!) : '--')),
                  DataCell(Wrap(
                    children: [
                      BLAdminButton(
                          type: AdminBtnType.red,
                          child: const BLText('Delete'),
                          onPressed: () async {
                            if (processing) return;
                            toggleProcessing();
                            final result = await accountsManager.deleteAccount(admins[i].id!, AccountType.admin);
                            if (result == null) {
                              if (!context.mounted) return;
                              toast.showToast(context, 'Delete success.', type: NotifType.success);
                            } else {
                              if (!context.mounted) return;
                              toast.showToast(context, result, type: NotifType.error);
                            }
                            toggleProcessing();
                          })
                    ],
                  )),
                ]);
              }));
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

  void toggleProcessing() {
    if (mounted) {
      setState(() {
        processing = !processing;
      });
    }
  }
}
