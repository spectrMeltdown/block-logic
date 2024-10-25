import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/feedback_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/shared_pref.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackDialog extends ConsumerStatefulWidget {
  final String? title;
  const FeedbackDialog({this.title, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends ConsumerState<FeedbackDialog> {
  late final AuthService auth;
  late final FeedbackManager feedbackManager;
  late final CustomNavigation nav;
  late final Toast toast;
  late final SharedPreferences sharedPref;
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool processing = false;
  Widget msg = const BlankWidget();
  final scrollController = ScrollController();
  late DateTime cooldownExpire = DateTime(0);
  int feedbackSentCount = 0;

  @override
  void initState() {
    super.initState();
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    feedbackManager = ref.read(feedbackManagerProvider.notifier);
    sharedPref = ref.read(sharedPrefProvider);
    final int? seconds = sharedPref.getInt('cooldownExpire');
    if (seconds != null) {
      cooldownExpire = DateTime.fromMillisecondsSinceEpoch(seconds);
    }

    // if cooldown is done, remove saved variables
    if (cooldownExpire.year != 0 && DateTime.now().isAfter(cooldownExpire)) {
      sharedPref.remove('feedbackSentCount');
      sharedPref.remove('cooldownExpire');
    }
    feedbackSentCount = sharedPref.getInt('feedbackSentCount') ?? 0;
    dPrint('Cooldown expiry: $cooldownExpire');
    dPrint('feedbackSentCount');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !processing,
      child: BLDialog(
          child: cooldownExpire.year != 0 && DateTime.now().isBefore(cooldownExpire)
              ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(FontAwesomeIcons.paperPlane),
                          const SizedBox(width: 10),
                          BLSmallTitle(
                            widget.title ?? 'Send Feedback',
                            bottomPadding: 2,
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      BLText(
                        'Feedback on cooldown\n(try again another time!)',
                        softWrap: true,
                        alignCenter: true,
                      ),
                      const SizedBox(height: 10),
                      BLTextButton(
                          onPressed: () {
                            nav.pop(context);
                          },
                          child: BLText(
                            'Back',
                            color: processing ? Colors.grey : Colors.deepOrange,
                          )),
                    ],
                  ))
              : Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Scrollbar(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Icon(FontAwesomeIcons.paperPlane),
                                const SizedBox(width: 10),
                                BLSmallTitle(
                                  widget.title ?? 'Send Feedback',
                                  bottomPadding: 2,
                                )
                              ],
                            ),
                            const SizedBox(height: 20),
                            const BLText('Title:'),
                            const SizedBox(height: 5),
                            BLTextBox(
                              controller: titleController,
                              labelText: 'Your title ...',
                              maxLength: 100,
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Cannot be empty.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            const BLText('Message:'),
                            const SizedBox(height: 5),
                            BLTextBox(
                              controller: messageController,
                              labelText: 'Your message ...',
                              keyboardType: TextInputType.multiline,
                              maxLength: 300,
                              maxLines: null,
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Cannot be empty.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            msg,
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BLTextButton(
                                    onPressed: () {
                                      nav.pop(context);
                                    },
                                    child: BLText(
                                      'Cancel',
                                      color: processing ? Colors.grey : Colors.deepOrange,
                                    )),
                                BLTextButton(
                                    onPressed: () async {
                                      if (processing) return;
                                      setState(() {
                                        processing = true;
                                      });
                                      if (formKey.currentState!.validate()) {
                                        final result = await feedbackManager.send(
                                          FeedbackData(
                                            title: titleController.text.trim(),
                                            message: messageController.text.trim(),
                                            createdAt: DateTime.now(),
                                            userID: auth.getUID(),
                                          ),
                                        );
                                        if (result == null) {
                                          feedbackSentCount++;
                                          debugPrint('Updated feedback count: $feedbackSentCount');
                                          await sharedPref.setInt('feedbackSentCount', feedbackSentCount);
                                          if (feedbackSentCount > 5) {
                                            await sharedPref.setInt('cooldownExpire', DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch);
                                          }
                                          if (!context.mounted) return;
                                          nav.pop(context);
                                          if (!context.mounted) return;
                                          toast.showToast(context, 'Feedback sent. Thank you!', type: NotifType.success);
                                        } else {
                                          setState(() {
                                            msg = BLText(
                                              result,
                                              color: Colors.deepOrange,
                                            );
                                          });
                                        }
                                      }
                                      setState(() {
                                        processing = false;
                                      });
                                    },
                                    child: BLText(
                                      'Submit',
                                      color: processing ? Colors.grey : Colors.green,
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }
}
