import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/firebase_providers/selected_feedback.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SelectedFeedback extends ConsumerStatefulWidget {
  final String feedbackID;
  const SelectedFeedback(this.feedbackID, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectedFeedbackState();
}

class _SelectedFeedbackState extends ConsumerState<SelectedFeedback> {
  @override
  Widget build(BuildContext context) {
    final feedback = ref.watch(SelectedFeedbackProvider(widget.feedbackID));
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const Header(title: 'Feedback'),
        Padding(
          padding: const EdgeInsets.all(15),
          child: feedback.when(
              data: (feedback) {
                if (feedback == null) {
                  return const Center(
                    child: BLText('Error getting this feedback..'),
                  );
                }
                return BLCardSimple(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BLSmallTitle(feedback.title ?? '--'),
                        BLText(feedback.message ?? '--',
                            softWrap: true, size: 16),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const BLText('Created at: '),
                            BLText(feedback.createdAt == null
                                ? '--'
                                : DateFormat('dd/mm/yyyy')
                                    .format(feedback.createdAt!)),
                          ],
                        ),
                        Row(
                          children: [
                            const BLText('Sender: '),
                            BLDisplayName(feedback.userID ?? ''),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              error: genericError,
              loading: genericLoading),
        )
      ],
    );
  }
}
