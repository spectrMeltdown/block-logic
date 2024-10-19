import 'package:block_logic/components/dialog/confirm.dart';
import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class DeleteSelectorDialog extends ConsumerStatefulWidget {
  final ReportType initialType;
  const DeleteSelectorDialog({required this.initialType, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends ConsumerState<DeleteSelectorDialog> {
  late final Toast toast;
  late final CustomNavigation nav;
  late final Map<ReportType, bool> selectedReports;
  DateTimeRange? dateRange;
  bool hasSelection = true;

  @override
  void initState() {
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    selectedReports = {for (final report in ReportType.values) report: false};
    selectedReports[widget.initialType] = true;
    super.initState();
  }

  void updateReportType(ReportType type, bool add) {
    if (add) {
      selectedReports[type] = true;
    } else {
      selectedReports[type] = false;
    }
    // for (final entry in selectedReports.entries) {
    //   dPrint(entry.toString());
    // }
    if (selectedReports.values.any((value) => value == true)) {
      hasSelection = true;
    } else {
      hasSelection = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BLDialog(
        child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [
          const BLSmallTitle('Select reports and date range to delete:'),
          const SizedBox(height: 15),
          BLAdminButton(
            type: AdminBtnType.blue,
            onPressed: () async {
              final dateRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2024, 9, 20),
                lastDate: DateTime.now(),
                initialDateRange: this.dateRange,
                // initialEntryMode: DatePickerEntryMode.inputOnly,
                builder: (context, child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: Colors.blue, // Header background color
                        onPrimary: Colors.blueGrey.shade900, // Header text color
                        surface: Colors.blueGrey.shade900, // Background color of the picker
                        onSurface: Colors.white, // Text color
                      ),
                      datePickerTheme: DatePickerThemeData(
                        inputDecorationTheme: InputDecorationTheme(),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red, // Button text color
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (dateRange != null) {
                setState(() {
                  this.dateRange = dateRange;
                });
              }
            },
            child: Center(
                child: dateRange == null
                    ? BLText('Select date range')
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BLText(
                            DateFormat('dd MMM y').format(dateRange!.start),
                            bold: true,
                            size: 18,
                          ),
                          BLText(
                            ' - ',
                            size: 30,
                          ),
                          BLText(
                            DateFormat('dd MMM y').format(dateRange!.end),
                            bold: true,
                            size: 18,
                          ),
                        ],
                      )),
          ),
          const SizedBox(height: 15),
          ...List.generate(selectedReports.length, (i) {
            final reportType = ReportType.values.toList()[i];
            return DeleteSelectorItem(
              type: reportType,
              initial: selectedReports[reportType]!,
              updateReportType: updateReportType,
            );
          }),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AdminBackBtn(text: 'Cancel'),
              SizedBox(width: 20),
              BLAdminButton(
                type: hasSelection ? AdminBtnType.red : AdminBtnType.grey,
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.trashCan,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 5),
                    const BLText('Delete')
                  ],
                ),
                onPressed: () async {
                  if (!hasSelection) {
                    toast.showToast(context, 'Select a report type.', type: NotifType.error);
                  } else if (dateRange == null) {
                    toast.showToast(context, 'Select a date range.', type: NotifType.error);
                  } else {
                    final confirmation = await showDialog(context: context, builder: (context) => ConfirmDialog(title: 'Delete selected reports?'));
                    if (confirmation is bool && confirmation) {
                      if (!context.mounted) return;
                      final Tuple2<List<ReportType>, DateTimeRange> selected = Tuple2(selectedReports.entries.where((e) => e.value).map((e) => e.key).toList(), dateRange!);
                      nav.pop(context, selected);
                    }
                  }
                },
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class DeleteSelectorItem extends ConsumerStatefulWidget {
  final ReportType type;
  final bool initial;
  final void Function(ReportType, bool) updateReportType;
  const DeleteSelectorItem({
    required this.type,
    required this.updateReportType,
    required this.initial,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportTypeSelectorItemState();
}

class _ReportTypeSelectorItemState extends ConsumerState<DeleteSelectorItem> {
  late bool selected;

  @override
  void initState() {
    selected = widget.initial;
    super.initState();
  }

  void toggleSelected() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CheckboxListTile(
        value: selected,
        selected: selected,
        onChanged: (value) {
          if (value != null) {
            if (value) {
              widget.updateReportType(widget.type, false);
            } else {
              widget.updateReportType(widget.type, true);
            }
            toggleSelected();
          }
        },
        title: BLText(widget.type.capName()),
      ),
    );
  }
}
