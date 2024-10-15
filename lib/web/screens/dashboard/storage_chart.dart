import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/web/components/bl_table.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a Riverpod provider for Firebase Storage analytics (returns total size)
final storageAnalyticsProvider = FutureProvider<int>((ref) async {
  final storageRef = FirebaseStorage.instance.ref(); // Start from the root
  int totalSizeUsed = 0;

  // Recursive function to list files in a folder
  Future<void> listFilesInFolder(Reference folderRef) async {
    final ListResult result = await folderRef.listAll();

    // Process files at the current level
    for (var item in result.items) {
      final size = await item.getMetadata().then((metadata) => metadata.size);
      if (size != null) {
        totalSizeUsed += size;
      }
    }

    // Recursively list files in subfolders
    for (var prefix in result.prefixes) {
      await listFilesInFolder(prefix);
    }
  }

  // Start recursion from the root folder
  await listFilesInFolder(storageRef);

  return totalSizeUsed; // Return total size used in bytes
});

class StorageChart extends ConsumerWidget {
  const StorageChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsyncValue = ref.watch(storageAnalyticsProvider);
    final totalSizeColor = Colors.blue;
    final freeSpaceColor = Colors.green;
    return BLCardSimple(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Labels for storage information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BLSmallTitle('Cloud Storage'),
                analyticsAsyncValue.when(
                  data: (totalSizeUsed) {
                    final totalSizeMB = totalSizeUsed / (1024 * 1024); // Convert to MB
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: totalSizeColor,
                              height: 10,
                              width: 10,
                              margin: EdgeInsets.only(right: 5),
                            ),
                            BLText('Used: ${totalSizeMB.toStringAsFixed(2)} MB'),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: freeSpaceColor,
                              height: 10,
                              width: 10,
                              margin: EdgeInsets.only(right: 5),
                            ),
                            BLText('Free: ${(5000 - totalSizeMB).toStringAsFixed(2)} MB'),
                          ],
                        )
                      ],
                    );
                  },
                  loading: blankLoading,
                  error: blankError,
                ),
              ],
            ),
            SizedBox(
              height: 400,
              width: 500,
              child: analyticsAsyncValue.when(
                data: (totalSizeUsed) {
                  final totalSizeMB = totalSizeUsed / (1024 * 1024); // Convert to MB
                  final freeSpaceMB = 5000 - totalSizeMB; // 5GB total (5000 MB)

                  return PieChart(
                    PieChartData(
                      centerSpaceRadius: 0,
                      sections: [
                        PieChartSectionData(
                          showTitle: false,
                          value: totalSizeMB,
                          color: totalSizeColor,
                          radius: 180,
                          badgePositionPercentageOffset: 1.5,
                        ),
                        PieChartSectionData(
                          showTitle: false,
                          value: freeSpaceMB,
                          color: freeSpaceColor,
                          radius: 180,
                          badgePositionPercentageOffset: 1.5,
                        ),
                      ],
                    ),
                  );
                },
                loading: () => Center(child: BLLoading(message: 'Loading data...')),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
