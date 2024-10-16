import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseDataProvider = FutureProvider<Map<String, double>>((ref) async {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  DatabaseEvent event = await databaseRef.once();

  final data = event.snapshot.value;
  if (data is! Map) {
    throw TypeError();
  }

  Map<String, dynamic> parsedData = Map<String, dynamic>.from(data);
  Map<String, int> folderSizes = {};
  parsedData.forEach((key, value) {
    if (value is Map) {
      folderSizes[key] = value.length;
    }
  });

  int totalSize = folderSizes.values.fold(0, (a, b) => a + b);
  if (totalSize == 0) {
    return {};
  }

  Map<String, double> percentages = folderSizes.map((key, value) {
    return MapEntry(key, (value / totalSize) * 100);
  });

  return percentages;
});

class DatabaseChart extends ConsumerWidget {
  const DatabaseChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final analyticsAsyncValue = ref.watch(firebaseDataProvider);
    final List<Color> brightColors = [
      Colors.red,
      Colors.blue,
      Colors.green.shade800,
      Colors.orange,
      Colors.pink,
      Colors.purple,
      Colors.cyan.shade800,
    ];

    int colorIndex = 0;
    Color getNextColor() {
      Color color = brightColors[colorIndex];
      colorIndex = (colorIndex + 1) % brightColors.length;

      return color;
    }

    return BLCardSimple(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BLSmallTitle('Database'),
              ],
            ),
            SizedBox(
              height: 400,
              width: 500,
              child: analyticsAsyncValue.when(
                data: (percentages) {
                  if (percentages.isEmpty) {
                    return const Center(child: Text('No data found.'));
                  }

                  List<PieChartSectionData> pieChartSections = percentages.entries.map((entry) {
                    return PieChartSectionData(
                      titlePositionPercentageOffset: 1.2,
                      title: entry.key,
                      value: entry.value,
                      radius: (width < height ? width : height) * 0.25,
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      color: getNextColor(),
                    );
                  }).toList();

                  return Column(
                    children: [
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: PieChart(
                          PieChartData(
                            sections: pieChartSections,
                            centerSpaceRadius: 0,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
