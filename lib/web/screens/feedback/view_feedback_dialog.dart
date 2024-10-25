import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/selected_feedback.dart';
import 'package:block_logic/logic/services/feedback_manager.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ViewFeedback extends ConsumerStatefulWidget {
  final String feedbackID;
  const ViewFeedback(this.feedbackID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectedFeedbackState();
}

class _SelectedFeedbackState extends ConsumerState<ViewFeedback> {
  late final FeedbackManager feedbackManager;
  bool processing = false;
  final titleKey = GlobalKey();
  double titleWidth = 0;

  @override
  Widget build(BuildContext context) {
    final feedback = ref.watch(selectedFeedbackProvider(widget.feedbackID));
    return BLDialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, minWidth: 250),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: feedback.when(
              data: (feedback) {
                if (feedback == null) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BLText('Couldn\'t get this feedback..'),
                      AdminBackBtn(),
                    ],
                  );
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // This callback is executed after the first frame is rendered
                  final RenderBox renderBox = titleKey.currentContext!.findRenderObject() as RenderBox;
                  setState(() {
                    titleWidth = renderBox.size.width;
                  });
                });
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BLSmallTitle(key: titleKey, feedback.title ?? '--'),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: BLText(feedback.message ?? '--', softWrap: true, size: 16),
                    ),
                    const SizedBox(height: 15),
                    ConstrainedBox(constraints: BoxConstraints(maxWidth: titleWidth), child: Divider(indent: 5, endIndent: 5)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BLText('Created on: '),
                        BLText(feedback.createdOn == null ? '--' : DateFormat('dd/MM/yyyy').format(feedback.createdOn!)),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BLText('Sender: '),
                        BLDisplayName(feedback.userID ?? '', AccountType.user),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BLTextButton(
                            child: const BLText(
                              'Delete',
                              color: Colors.red,
                              size: 18,
                            ),
                            onPressed: () async {
                              if (processing) return;
                              processing = true;
                              context.pop();
                              await feedbackManager.delete(feedback.id!);
                              processing = false;
                            }),
                        SizedBox(width: 20),
                        const AdminBackBtn()
                      ],
                    ),
                  ],
                );
              },
              error: genericError,
              loading: genericLoading),
        ),
      ),
    );
  }

  @override
  void initState() {
    feedbackManager = ref.read(feedbackManagerProvider.notifier);
    super.initState();
  }
}
