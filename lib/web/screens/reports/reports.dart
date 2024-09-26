import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_providers/reports.dart';
import 'package:block_logic/logic/services/reports_manager.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:block_logic/web/components/header.dart';
import 'package:block_logic/web/components/search.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Reports extends ConsumerStatefulWidget {
  const Reports({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsState();
}

class _ReportsState extends ConsumerState<Reports> {
  final pageScrollController = ScrollController();
  Map<String, ReportType> reportOptions = {
    'Basic Users': ReportType.users,
    'Premium Users': ReportType.premiumUsers,
    // 'Challenges' : ReportType.challe,
    'Rooms': ReportType.rooms,
    'Leaderboards': ReportType.leaderboards,
    'Challenges Played': ReportType.challengesPlayed,
    'Rooms Played': ReportType.roomsPlayed,
  };
  late ReportType selectedType;
  late final ReportsManager reportsManager;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final reports = ref.watch(ReportsProvider(selectedType));
    return ListView(
      controller: pageScrollController,
      children: [
        const Header(title: 'Reports'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        BLCardSimple(
                          child: DropdownButton<ReportType>(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            underline: const SizedBox.shrink(),
                            value: selectedType,
                            items: reportOptions.entries.map((entry) {
                              return DropdownMenuItem<ReportType>(
                                value: entry.value,
                                child: Text(entry.key),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedType = newValue;
                                });
                              }
                            },
                            hint: const BLText('Select a category'),
                          ),
                        ),
                        Flexible(
                          child: AdminSearchBar((newQuery) {
                            setState(() {
                              searchQuery = newQuery;
                            });
                          }),
                        )
                      ],
                    ),
                    Expanded(
                      child: BLCardSimple(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Wrap(
                                spacing: width * 0.01,
                                children: [
                                  const BLSmallTitle('Generated Reports'),
                                  BLAdminButton(
                                      type: AdminBtnType.teal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.file,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: width / 180,
                                          ),
                                          const BLText(
                                            'Generate',
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                      onPressed: () {})
                                ],
                              ),
                              Expanded(
                                child: reports.when(
                                    data: (reports) {
                                      if (reports.isEmpty) {
                                        return const BLText('No reports of this type found.');
                                      }
                                      return const Column(
                                        children: [],
                                      );
                                    },
                                    error: genericError,
                                    loading: genericLoading),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    reportsManager = ref.read(reportsManagerProvider.notifier);
  }

  Widget leftTitleWidgets(
    double value,
    // TitleMeta meta,
  ) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
