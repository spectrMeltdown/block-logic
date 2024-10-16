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
  final Map<ReportDate, List<Report>> reports;

  const Graph({required this.period, required this.reports, super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  late int selectedYear;
  late int selectedMonth;
  List<int> years = [];
  List<int> months = List.generate(13, (i) => i)..remove(0);
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();
    selectedMonth = months.first;
  }

  List<FlSpot> createSpots() {
    // debugPrint('Creating spots for selectedMonth $selectedMonth, selectedYear $selectedYear');
    final List<FlSpot> result = [];

    for (final entry in widget.reports.entries) {
      // skip if the value is empty
      final count = entry.value.length;
      if (count.isNaN || count.isInfinite || count <= 0) {
        continue;
      }

      double time = 0;
      final key = entry.key;
      switch (widget.period) {
        case TimePeriod.yearly:
          time = key.year!.toDouble();
        case TimePeriod.weekly:
          if (selectedYear == key.year) {
            time = key.week!.toDouble();
          }
        case TimePeriod.monthly:
          if (selectedYear == key.year) {
            time = key.month!.toDouble();
          }
        case TimePeriod.daily:
          if (key.month == selectedMonth && key.year == selectedYear) {
            time = key.day!.toDouble();
          }
      }
      if (time != 0) {
        result.add(FlSpot(time.toDouble(), count.toDouble()));
      }
    }

    if (result.isNotEmpty) {
      switch (widget.period) {
        case TimePeriod.yearly:
          if (years.length == 1) {
            // debugPrint('length was 1');
            for (int i = selectedYear - 3; i < selectedYear + 4; i++) {
              if (result.any((j) => j.x == i)) {
                // debugPrint(i.toString());
                continue;
              } else {
                // debugPrint('adding $i');
                result.add(FlSpot(i.toDouble(), 0));
              }
            }
          } else {
            for (int i = selectedYear - 1; i < selectedYear + 2; i++) {
              if (result.any((j) => j.x == i)) {
                // debugPrint(i.toString());
                continue;
              } else {
                // debugPrint('adding $i');
                result.add(FlSpot(i.toDouble(), 0));
              }
            }
          }
          break;
        case TimePeriod.monthly:
          final months = 12;
          for (int i = 1; i < months + 1; i++) {
            if (result.any((j) => j.x == i)) {
              continue;
            } else {
              result.add(FlSpot(i.toDouble(), 0));
            }
          }
          break;
        case TimePeriod.weekly:
          final weeks = getMaxDate(selectedYear, selectedMonth);
          for (int i = 1; i < weeks + 1; i++) {
            if (result.any((j) => j.x == i)) {
              continue;
            } else {
              result.add(FlSpot(i.toDouble(), 0));
            }
          }
          break;
        case TimePeriod.daily:
          final days = getMaxDate(selectedYear, selectedMonth);
          for (int i = 1; i < days + 1; i++) {
            if (result.any((j) => j.x == i)) {
              continue;
            } else {
              result.add(FlSpot(i.toDouble(), 0));
            }
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
    // debugPrint(years.toString());
    result.sort((a, b) => a.x.compareTo(b.x));
    // debugPrint(result.toString());
    return result;
  }

  @override
  Widget build(BuildContext context) {
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
                                items: months.map((selectedMonth) => DropdownMenuItem<int>(value: selectedMonth, child: BLText(DateFormat('MMMM').format(DateTime(selectedMonth, selectedMonth))))).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    // debugPrint('Updated selectedMonth');
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
                    Transform.rotate(
                      angle: -3.14159 / 2,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: BLText('Count'),
                      ),
                    ),
                    SizedBox(
                      height: 400,
                      width: 1100,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          minX: years.length == 1 && widget.period == TimePeriod.yearly ? spots.first.x : getMinDate(widget.period).toDouble(),
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
                            horizontalInterval: 1, // Spacing for horizontal grid lines
                            verticalInterval: 1, // Spacing for vertical grid lines
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
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
                                  minIncluded: false,
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    return BLText(value.toInt().toString()); // Display report count as an integer
                                  }),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: BLText('${widget.period.formalName} (in numbers)'),
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
        return 12;
      case TimePeriod.weekly:
        return numberOfWeeksInYear(selectedYear);
      case TimePeriod.daily:
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
}
