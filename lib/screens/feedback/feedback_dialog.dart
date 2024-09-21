import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/textbox.dart';
import 'package:block_logic/components/util/blank_widget.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/feedback_manager.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool processing = false;
  Widget msg = const BlankWidget();
  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
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
                      child: const BLText(
                        'Cancel',
                        color: Colors.deepOrange,
                      )),
                  BLTextButton(
                      onPressed: () async {
                        if (processing) return;
                        setState(() {
                          processing = true;
                        });
                        if (formKey.currentState!.validate()) {
                          final result = await feedbackManager.send(FeedbackData(
                              title: titleController.text.trim(),
                              message: messageController.text.trim(),
                              createdAt: DateTime.now(),
                              userID: auth.getUID()));
                          if (result == null) {
                            if (!context.mounted) return;
                            nav.pop(context);
                            toast.showToast('Feedback sent. Thank you!', type: NotifType.success);
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
                      child: const BLText(
                        'Submit',
                        color: Colors.green,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  @override
  void initState() {
    auth = ref.read(authServiceProvider.notifier);
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    feedbackManager = ref.read(feedbackManagerProvider.notifier);
    super.initState();
  }
}
