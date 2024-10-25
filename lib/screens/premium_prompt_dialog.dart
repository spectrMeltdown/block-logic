import 'package:block_logic/components/button/button.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/user_account.dart';
import 'package:block_logic/logic/services/account.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PremiumPromptDialog extends ConsumerStatefulWidget {
  const PremiumPromptDialog({super.key});

  @override
  ConsumerState<PremiumPromptDialog> createState() => _PremiumPromptDialogState();
}

class _PremiumPromptDialogState extends ConsumerState<PremiumPromptDialog> {
  late final CustomNavigation nav;
  late final ReportsManager reportsManager;
  late final AccountService accountS;
  late final AuthService auth;
  bool processing = false;

  @override
  void initState() {
    super.initState();
    nav = ref.read(customNavigationProvider.notifier);
    auth = ref.read(authServiceProvider.notifier);
    accountS = ref.read(accountServiceProvider.notifier);
    reportsManager = ref.read(reportsManagerProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BLSmallTitle(
              'Upgrade to Premium',
              color: Colors.amber,
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.doorOpen,
                  color: Colors.green,
                ),
                SizedBox(width: 15),
                Flexible(
                    child: BLText(
                  'Larger room limit! (20 rooms!)',
                  softWrap: true,
                ))
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.flask,
                  color: Colors.blue.shade300,
                ),
                SizedBox(width: 15),
                Flexible(
                    child: BLText(
                  'More code testing! (100 tests per day!)',
                  softWrap: true,
                ))
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.heart,
                  color: Colors.deepOrange,
                ),
                SizedBox(width: 15),
                Flexible(
                  child: BLText(
                    'Support the developers! (More game updates!)',
                    softWrap: true,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            BLText(
              'Only P200 per month!',
              size: 20,
              bold: true,
            ),
            const SizedBox(height: 5),
            BLButton(
                paddingX: 15,
                type: BtnType.amber,
                onPressed: () async {
                  if (processing) return;
                  setState(() {
                    processing = true;
                  });
                  // TODO: add removal of basic user, update user to premium
                  await accountS.update(user: UserAccount(id: auth.getUID(), premiumUser: true));
                  await reportsManager.add(ReportType.premiumUsers);
                  if (!context.mounted) return;
                  await showDialog(context: context, builder: (context) => ThankYouDialog());
                  if (!context.mounted) return;
                  nav.pop(context);
                  if (context.mounted) {
                    setState(() {
                      processing = true;
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(FontAwesomeIcons.crown),
                    const SizedBox(width: 15),
                    BLText(
                      'Upgrade now',
                      size: 20,
                      bold: true,
                    )
                  ],
                )),
            const SizedBox(height: 10),
            BLTextButton(
              onPressed: () => nav.pop(context),
              child: const BLText(
                'Maybe later',
                color: Colors.blue,
                bold: true,
                alignCenter: true,
                size: 18,
              ),
            ),
          ],
        ));
  }
}

class ThankYouDialog extends ConsumerWidget {
  final bool premium;
  const ThankYouDialog({this.premium = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nav = ref.read(customNavigationProvider.notifier);
    return BLDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BLSmallTitle(premium ? 'You are already a premium user.' : 'You are now a\npremium user!'),
        BLText('Thanks for supporting us!!'),
        SizedBox(height: 15),
        BLButton(
          type: BtnType.red,
          child: BLText('Back'),
          onPressed: () => nav.pop(context),
        ),
      ],
    ));
  }
}
