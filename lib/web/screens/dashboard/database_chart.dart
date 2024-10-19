import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseDataProvider = FutureProvider.autoDispose<Map<String, double>>((ref) async {
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

    String formatSize(int bytes) {
      if (bytes < 1000) {
        return '$bytes B'; // Less than 1 KB
      }
      double kb = bytes / 1000;
      if (kb < 1000) {
        return '${kb.toStringAsFixed(2)} KB'; // Less than 1 MB
      }
      double mb = kb / 1000;
      if (mb < 1000) {
        return '${mb.toStringAsFixed(2)} MB'; // Less than 1 GB
      }
      double gb = mb / 1000;
      return '${gb.toStringAsFixed(2)} GB'; // 1 GB or more
    }

    const int totalDatabaseSize = 1000 * 1000 * 1000;

    return analyticsAsyncValue.when(
        data: (percentages) {
          if (percentages.isEmpty) {
            return const Center(child: Text('No data found.'));
          }
          // Calculate the total used size in bytes
          int totalUsedSize = percentages.entries.fold(0, (sum, entry) => sum + entry.value.toInt());
          int freeSize = totalDatabaseSize - totalUsedSize; // Free size left in bytes

          // Convert percentage values (which represent folder sizes in bytes) into PieChartSectionData
          List<PieChartSectionData> pieChartSections = percentages.entries.map((entry) {
            return PieChartSectionData(
              titlePositionPercentageOffset: width > desktopMin
                  ? 1.22
                  : width > tabletMin
                      ? 1.30
                      : width > mobileMin
                          ? 1.35
                          : 1.15,
              // Display folder name and formatted size (KB/MB)
              title: '${entry.key}\n(${formatSize(entry.value.toInt())})',
              value: entry.value,
              radius: getRadius(width),
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

          return Padding(
            padding: const EdgeInsets.all(5),
            child: BLCardSimple(
              child: Padding(
                padding: const EdgeInsets.all(35),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BLSmallTitle('Database'),
                        Row(
                          children: [
                            IconButton(onPressed: () => ref.invalidate(firebaseDataProvider), icon: Icon(Icons.refresh)),
                            SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                BLText('Used Size: ${formatSize(totalUsedSize)}'),
                                BLText('Free Size: ${formatSize(freeSize)}'),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 400,
                      width: 500,
                      child: PieChart(
                        PieChartData(
                          sections: pieChartSections,
                          centerSpaceRadius: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')));
  }

  double getRadius(double width) {
    if (width >= desktopMin) {
      return 180;
    } else if (width >= tabletMin) {
      return 160;
    } else if (width >= mobileMin) {
      return 140;
    } else {
      return 130;
    }
  }
}
