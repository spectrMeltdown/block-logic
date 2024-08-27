import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/feedback.dart';
import 'package:block_logic/logic/firebase_providers/all_feedback.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/screens/feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class FeedbackTable extends ConsumerStatefulWidget {
  final String searchQuery;
  const FeedbackTable(this.searchQuery, {super.key});

  @override
  ConsumerState<FeedbackTable> createState() => _FeedbackTableState();
}

class _FeedbackTableState extends ConsumerState<FeedbackTable> {
  bool processing = false;
  late List<FeedbackData> feedbacksList;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final feedbacks = ref.watch(AllFeedbackProvider(widget.searchQuery));
    return BLCardSimple(
        child: feedbacks.when(
            data: (feedbacks) {
              if (widget.searchQuery.isNotEmpty && feedbacks.isEmpty) {
                return ConstrainedBox(
                  constraints:
                      BoxConstraints(maxHeight: height * 0.2, maxWidth: width >= mobileMax ? width * 0.4 : width * 0.3),
                  child: const Center(
                    child: BLText('No results.'),
                  ),
                );
              }
              if (feedbacks.isEmpty) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width >= mobileMax ? width * 0.4 : width * 0.3),
                  child: const Center(
                    child: BLText('There are no messages at the moment ...'),
                  ),
                );
              }
              feedbacksList = feedbacks;
              return BLTable(
                  columns: List.generate(FeedbackProps.values.length, (i) {
                    return DataColumn(label: BLText(FeedbackProps.values[i].name));
                  }),
                  rows: List.generate(feedbacksList.length, (i) {
                    return DataRow(
                        onSelectChanged: (value) {
                          context.go(
                            '/feedback/${feedbacksList[i].id}',
                          );
                        },
                        cells: [
                          DataCell(BLText(feedbacksList[i].title ?? '--')),
                          DataCell(ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width >= mobileMax ? width * 0.4 : width * 0.3),
                            child: BLText(feedbacksList[i].message ?? '--'),
                          )),
                          DataCell(BLDisplayName(feedbacksList[i].userID ?? '', AccountType.user)),
                          DataCell(BLText(feedbacksList[i].createdAt != null
                              ? DateFormat('dd / mm / yyyy').format(feedbacksList[i].createdAt!)
                              : '--')),
                        ]);
                  }));
            },
            error: genericError,
            loading: genericLoading));
  }
}
