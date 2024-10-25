import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
import 'package:block_logic/web/screens/feedback/feedback_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackManager extends ConsumerStatefulWidget {
  const FeedbackManager({super.key});

  @override
  ConsumerState<FeedbackManager> createState() => _FeedbackManagerState();
}

enum FeedbackProps { title, message, user, createdOn }

class _FeedbackManagerState extends ConsumerState<FeedbackManager> {
  final pageScrollController = ScrollController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: pageScrollController,
      padding: EdgeInsets.zero,
      children: [
        const Header(title: 'Feedback'),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              AdminSearchBar((newQuery) {
                setState(() {
                  searchQuery = newQuery;
                });
              }),
              FeedbackTable(searchQuery)
            ],
          ),
        )
      ],
    );
  }
}
