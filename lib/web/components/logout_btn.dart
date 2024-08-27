import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutBtn extends ConsumerStatefulWidget {
  final double paddingX;
  const LogoutBtn({this.paddingX = 30, super.key});

  @override
  ConsumerState<LogoutBtn> createState() => _LogoutBtnState();
}

class _LogoutBtnState extends ConsumerState<LogoutBtn> {
  late final AuthService auth;
  bool processing = false;
  @override
  Widget build(BuildContext context) {
    return BLAdminButton(
        type: AdminBtnType.red,
        paddingX: widget.paddingX,
        paddingY: 20,
        onPressed: () => logout(),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 10),
            BLText(
              'Logout',
              color: Colors.white,
            )
          ],
        ));
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    super.initState();
  }

  Future<void> logout() async {
    if (processing) return;
    processing = true;
    auth.logout();
    processing = false;
  }
}
