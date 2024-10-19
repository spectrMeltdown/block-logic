import 'package:block_logic/components/async/loading.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/components/util/provider_default.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageAnalyticsProvider = FutureProvider.autoDispose<int>((ref) async {
  dPrint('updating storage analytics...');
  final storageRef = FirebaseStorage.instance.ref();
  int totalSizeUsed = 0;

  Future<void> listFilesInFolder(Reference folderRef) async {
    final ListResult result = await folderRef.listAll();

    for (var item in result.items) {
      final size = await item.getMetadata().then((metadata) => metadata.size);
      if (size != null) {
        totalSizeUsed += size;
      }
    }

    for (var prefix in result.prefixes) {
      await listFilesInFolder(prefix);
    }
  }

  await listFilesInFolder(storageRef);
  return totalSizeUsed;
});

class StorageChart extends ConsumerWidget {
  const StorageChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsyncValue = ref.watch(storageAnalyticsProvider);
    final totalSizeColor = Colors.blue;
    final freeSpaceColor = Colors.green;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: BLCardSimple(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: Column(
            children: [
              // Labels for storage information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BLSmallTitle('Cloud Storage'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: () => ref.invalidate(storageAnalyticsProvider), icon: Icon(Icons.refresh)),
                      SizedBox(width: 5),
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
                ],
              ),
              SizedBox(
                height: 400,
                width: 500,
                child: analyticsAsyncValue.when(
                  data: (totalSizeUsed) {
                    final totalSizeMB = totalSizeUsed / (1024 * 1024);
                    final freeSpaceMB = 5000 - totalSizeMB;

                    return PieChart(
                      PieChartData(
                        centerSpaceRadius: 0,
                        sections: [
                          PieChartSectionData(
                            showTitle: false,
                            value: totalSizeMB,
                            color: totalSizeColor,
                            radius: 180,
                          ),
                          PieChartSectionData(
                            showTitle: false,
                            value: freeSpaceMB,
                            color: freeSpaceColor,
                            radius: 180,
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
      ),
    );
  }
}
