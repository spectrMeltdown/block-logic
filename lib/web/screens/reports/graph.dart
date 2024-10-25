import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/report.dart';
import 'package:block_logic/logic/firebase_providers/reports.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  final TimePeriod period;
  final ReportType type;
  final Map<ReportDate, List<Report>> reports;

  const Graph({required this.period, required this.reports, super.key, required this.type});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  late int selectedYear;
  late int selectedMonth;
  List<int> years = [];
  late List<int> months;
  List<FlSpot> spots = [];
  int highestCount = 1;

  @override
  void initState() {
    super.initState();
    // dPrint('Graph init called');
    // dPrint(widget.reports.toString());
    months = List.generate(13, (i) => i)..remove(0);
    selectedMonth = months.first;
  }

  List<FlSpot> createSpots() {
    // dPrint('Creating spots for selectedMonth $selectedMonth, selectedYear $selectedYear');
    final List<FlSpot> result = [];

    for (final entry in widget.reports.entries) {
      // skip if the value is empty
      int count = 0;

      if (widget.type == ReportType.challengesPlayed || widget.type == ReportType.roomsPlayed) {
        for (final report in entry.value) {
          if (report.count != null) count += report.count!;
        }
      } else {
        count = entry.value.length;
      }
      if (count.isNaN || count.isInfinite || count <= 0) {
        continue;
      }
      if (count > highestCount) {
        setState(() {
          highestCount = count;
        });
      }
      double time = 0;
      final reportDate = entry.key;
      switch (widget.period) {
        case TimePeriod.yearly:
          time = reportDate.year!.toDouble();
        case TimePeriod.weekly:
          if (selectedYear == reportDate.year) {
            time = reportDate.week!.toDouble();
          }
        case TimePeriod.monthly:
          if (selectedYear == reportDate.year) {
            time = reportDate.month!.toDouble();
          }
        case TimePeriod.daily:
          if (reportDate.month == selectedMonth && reportDate.year == selectedYear) {
            time = reportDate.day!.toDouble();
          }
      }
      if (time != 0) {
        result.add(FlSpot(time.toDouble(), count.toDouble()));
      }
    }

    // populate points between existing points, based on ReportType
    if (result.isNotEmpty) {
      switch (widget.period) {
        case TimePeriod.yearly:
          // if only one year, add some previous years for decoration
          if (years.length == 1) {
            switch (widget.type) {
              case ReportType.rooms:
              case ReportType.premiumUsers:
              case ReportType.users:
              case ReportType.basicUsers:
              case ReportType.leaderboards:
              // maintain the levels between values
              // double lastValue = 0; // TODO: initial should be from previous timeperiod
              // for (int i = selectedYear - 3; i < selectedYear; i++) {
              //   // skip existing values
              //   if (result.any((j) {
              //     final equal = j.x == i;
              //     if (equal) {
              //       lastValue = j.y;
              //     }
              //     return equal;
              //   })) {
              //     continue;
              //   }
              //   // fill with value
              //   else {
              //     result.add(FlSpot(i.toDouble(), lastValue));
              //   }
              // }
              // break;
              case ReportType.roomsPlayed:
              case ReportType.challengesPlayed:
                // fill with zeros where there are no values
                for (int i = selectedYear - 3; i < selectedYear; i++) {
                  if (result.any((j) => j.x == i)) {
                    continue;
                  } else {
                    result.add(FlSpot(i.toDouble(), 0));
                  }
                }
                break;
            }
          }
          // loop through years
          else {
            for (int i = selectedYear - 1; i < years.length; i++) {
              if (result.any((j) => j.x == i)) {
                // dPrint(i.toString());
                continue;
              } else {
                // dPrint('adding $i');
                result.add(FlSpot(i.toDouble(), 0));
              }
            }
          }
          break;
        case TimePeriod.monthly:
          final months = getMaxDate(selectedYear, selectedMonth);
          switch (widget.type) {
            case ReportType.rooms:
            case ReportType.premiumUsers:
            case ReportType.users:
            case ReportType.basicUsers:
            case ReportType.leaderboards:
            // double lastValue = 0; // TODO: initial should be from previous timeperiod
            // for (int i = 1; i < months + 1; i++) {
            //   if (result.any((j) {
            //     final equal = j.x == i;
            //     if (equal) {
            //       lastValue = j.y;
            //     }
            //     return equal;
            //   })) {
            //     continue;
            //   } else {
            //     result.add(FlSpot(i.toDouble(), lastValue));
            //   }
            // }
            // break;
            case ReportType.roomsPlayed:
            case ReportType.challengesPlayed:
              for (int i = 1; i < months + 1; i++) {
                if (result.any((j) => j.x == i)) {
                  continue;
                } else {
                  result.add(FlSpot(i.toDouble(), 0));
                }
              }
              break;
          }
          break;
        case TimePeriod.weekly:
          final weeks = getMaxDate(selectedYear, selectedMonth);
          switch (widget.type) {
            case ReportType.rooms:
            case ReportType.premiumUsers:
            case ReportType.users:
            case ReportType.basicUsers:
            case ReportType.leaderboards:
            // double lastValue = 0; // TODO: initial should be from previous timeperiod
            // for (int i = 1; i < weeks + 1; i++) {
            //   if (result.any((j) {
            //     final equal = j.x == i;
            //     if (equal) {
            //       lastValue = j.y;
            //     }
            //     return equal;
            //   })) {
            //     continue;
            //   } else {
            //     result.add(FlSpot(i.toDouble(), lastValue));
            //   }
            // }
            // break;
            case ReportType.roomsPlayed:
            case ReportType.challengesPlayed:
              for (int i = 1; i < weeks + 1; i++) {
                if (result.any((j) => j.x == i)) {
                  continue;
                } else {
                  result.add(FlSpot(i.toDouble(), 0));
                }
              }
              break;
          }
          break;
        case TimePeriod.daily:
          final days = getMaxDate(selectedYear, selectedMonth);
          switch (widget.type) {
            case ReportType.rooms:
            case ReportType.premiumUsers:
            case ReportType.users:
            case ReportType.basicUsers:
            case ReportType.leaderboards:
            // double lastValue = 0; // TODO: initial should be from previous timeperiod
            // for (int i = 1; i < days + 1; i++) {
            //   if (result.any((j) {
            //     final equal = j.x == i;
            //     if (equal) {
            //       lastValue = j.y.toDouble();
            //     }
            //     return equal;
            //   })) {
            //     continue;
            //   } else {
            //     result.add(FlSpot(i.toDouble(), lastValue));
            //   }
            // }
            // break;
            case ReportType.roomsPlayed:
            case ReportType.challengesPlayed:
              for (int i = 1; i < days + 1; i++) {
                if (result.any((j) => j.x == i)) {
                  continue;
                } else {
                  result.add(FlSpot(i.toDouble(), 0));
                }
              }
              break;
          }
          break;
      }
      // // add trailing and starting zeros if needed
      // final first = result.first;
      // final last = result.last;
      // if (first.x > 1) {
      //   result.insert(0, FlSpot(first.x - 1, 0));
      // }
      // if (last.x < getMaxDate(selectedYear, selectedMonth)) {
      //   result.add(FlSpot(last.x + 1, 0));
      // }
    }
    // dPrint(years.toString());
    result.sort((a, b) => a.x.compareTo(b.x));
    // dPrint(result.toString());
    if (selectedYear == DateTime.now().year) {
      if (months.length == 12) {
        months.removeRange(DateTime.now().month, 12);
        selectedMonth = months.first;
      }
    }
    // adjust the months if year == currentYear
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // dPrint('Graph called');
    if (years.isEmpty) {
      years = createYears();
      setState(() {
        selectedYear = years.first;
      });
    }
    if (widget.reports.values.isNotEmpty) {
      setState(() {
        spots = createSpots();
      });
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BLCardSimple(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.only(right: 30, top: 30),
            child: Column(
              children: [
                if (widget.period != TimePeriod.yearly)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BLText('Year :'),
                      SizedBox(
                        width: 20,
                      ),
                      BLCardSimple(
                        color: Colors.blue.shade800,
                        child: DropdownButton<int>(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          underline: const SizedBox.shrink(),
                          value: selectedYear,
                          items: years.map((selectedYear) => DropdownMenuItem<int>(value: selectedYear, child: BLText(selectedYear.toString()))).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedYear = value;
                              });
                            }
                          },
                        ),
                      ),
                      if (widget.period == TimePeriod.daily)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                            ),
                            BLText('Month :'),
                            SizedBox(
                              width: 20,
                            ),
                            BLCardSimple(
                              color: Colors.blue.shade800,
                              child: DropdownButton<int>(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                underline: const SizedBox.shrink(),
                                value: selectedMonth,
                                items: months.map((selectedMonth) => DropdownMenuItem<int>(value: selectedMonth, child: BLText(DateFormat('MMMM').format(DateTime(selectedYear, selectedMonth))))).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    // dPrint('Updated selectedMonth');
                                    setState(() {
                                      selectedMonth = value;
                                    });
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: SizedBox(
                        width: 50,
                        child: BLText(
                          widget.type.capName(),
                          softWrap: true,
                        ),
                      ),
                    ),
                    // Transform.rotate(
                    //   angle: -3.14159 / 2,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 10),
                    //     child: BLText(widget.type.capName()),
                    //   ),
                    // ),
                    SizedBox(
                      height: 400,
                      width: 1100,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          minX: years.length == 1 && widget.period == TimePeriod.yearly ? spots.first.x : 1,
                          maxX: years.length == 1 && widget.period == TimePeriod.yearly ? spots.last.x : getMaxDate(selectedYear, selectedMonth).toDouble(),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              preventCurveOverShooting: true,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                          gridData: FlGridData(
                            show: true, // To display the grid
                            horizontalInterval: highestCount >= 100
                                ? 10
                                : highestCount >= 50
                                    ? 5
                                    : 1, // Spacing for horizontal grid lines
                            verticalInterval: 1, // Spacing for vertical grid lines
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  reservedSize: 40,
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    if (widget.period == TimePeriod.monthly) {
                                      return BLText(DateFormat('MMM').format(DateTime(selectedYear, value.toInt())));
                                    }
                                    return BLText(value.toInt().toString());
                                  }),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  reservedSize: highestCount >= 1000
                                      ? 40
                                      : highestCount >= 100
                                          ? 30
                                          : 20,
                                  minIncluded: false,
                                  showTitles: true,
                                  // interval: spots.any((e) => e.y > 16) ? 2 : 1, // TODO: change interval if total is too big to fit
                                  interval: highestCount >= 80
                                      ? 10
                                      : highestCount >= 40
                                          ? 5
                                          : 1,
                                  getTitlesWidget: (value, meta) {
                                    return BLText(
                                      value.toInt().toString(),
                                      overflow: true,
                                    ); // Display report count as an integer
                                  }),
                            ),
                          ),
                          borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade700)),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BLText(widget.period.formalName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getMinDate(TimePeriod period) {
    switch (period) {
      case TimePeriod.yearly:
        return years.first;
      case TimePeriod.monthly:
      case TimePeriod.weekly:
      case TimePeriod.daily:
        return 1;
    }
  }

  int getMaxDate(int selectedYear, int selectedMonth) {
    switch (widget.period) {
      case TimePeriod.yearly:
        return years.last;
      case TimePeriod.monthly:
        if (selectedYear == DateTime.now().year) {
          return DateTime.now().month;
        }
        return 12;
      case TimePeriod.weekly:
        if (selectedYear == DateTime.now().year) {
          return getWeekOfYear(DateTime.now()) + 1;
        }
        return numberOfWeeksInYear(selectedYear);
      case TimePeriod.daily:
        final now = DateTime.now();
        if (selectedYear == now.year && selectedMonth == now.month) {
          return DateTime.now().day;
        }
        return maxDayOfMonth(selectedYear, selectedMonth);
    }
  }

  int maxDayOfMonth(int selectedYear, int selectedMonth) {
    if (selectedMonth < 1 || selectedMonth > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }
    DateTime firstDayNextMonth = DateTime(selectedYear, selectedMonth + 1, 1);
    DateTime lastDayOfCurrentMonth = firstDayNextMonth.subtract(Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  int numberOfWeeksInYear(int selectedYear) {
    bool isLeapYear = (selectedYear % 4 == 0 && selectedYear % 100 != 0) || (selectedYear % 400 == 0);
    int totalDays = isLeapYear ? 366 : 365;
    return (totalDays / 7).ceil(); // round to whole num
  }

  List<int> createYears() {
    List<int> years = [];
    for (final key in widget.reports.keys) {
      if (key.year != null && !years.contains(key.year!)) {
        years.add(key.year!);
      }
    }
    return years;
  }
}

extension CapitalizedName on TimePeriod {
  String get capitalizedName {
    String name = this.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  String get formalName {
    switch (this) {
      case TimePeriod.yearly:
        return 'Year';
      case TimePeriod.monthly:
        return 'Month';
      case TimePeriod.weekly:
        return 'Week';
      case TimePeriod.daily:
        return 'Day';
    }
  }

  // int getCurrentWeekOfYear() {
  //   DateTime now = DateTime.now();
  //   DateTime startOfYear = DateTime(now.year, 1, 1);
  //   int daysPassed = now.difference(startOfYear).inDays + 1; // +1 to include the current day

  //   return (daysPassed / 7).ceil();
  // }
}
