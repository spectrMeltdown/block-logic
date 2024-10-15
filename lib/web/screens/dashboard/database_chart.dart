import 'dart:math';

import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a Riverpod provider to fetch the Firebase data and calculate folder sizes
final firebaseDataProvider = FutureProvider<Map<String, double>>((ref) async {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref(); // Reference to the root
  DatabaseEvent event = await databaseRef.once();

  // Safely cast the data to Map<String, dynamic> if possible
  final data = event.snapshot.value;
  if (data is! Map) {
    throw TypeError(); // If data is not a map, throw an error
  }

  Map<String, dynamic> parsedData = Map<String, dynamic>.from(data);

  // Calculate size of each folder
  Map<String, int> folderSizes = {};
  parsedData.forEach((key, value) {
    if (value is Map) {
      folderSizes[key] = value.length; // Assuming each folder is a map
    }
  });

  // Calculate percentages
  int totalSize = folderSizes.values.fold(0, (a, b) => a + b);
  if (totalSize == 0) {
    return {}; // Return an empty map if there's no data
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
        padding: const EdgeInsets.all(20),
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

                  // Create PieChart sections from the percentages with random colors
                  List<PieChartSectionData> pieChartSections = percentages.entries.map((entry) {
                    return PieChartSectionData(
                      title: entry.key,
                      value: entry.value,
                      radius: 180,
                      color: getNextColor(), // Assign a random color
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
