import 'package:block_logic/components/dialog/dialog.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/navigation.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:block_logic/web/components/back_btn.dart';
import 'package:block_logic/web/components/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportTypeSelector extends ConsumerStatefulWidget {
  final ReportType? initial;
  const ReportTypeSelector({required this.initial, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportTypeSelectorState();
}

class _ReportTypeSelectorState extends ConsumerState<ReportTypeSelector> {
  late final Toast toast;
  late final CustomNavigation nav;
  late final Map<ReportType, bool> selectedReports;
  bool hasSelection = false;

  @override
  void initState() {
    super.initState();
    nav = ref.read(customNavigationProvider.notifier);
    toast = ref.read(toastProvider.notifier);
    selectedReports = {for (final report in ReportType.values) report: false};
    if (widget.initial != null) {
      selectedReports[widget.initial!] = true;
      hasSelection = true;
    }
    dPrint(selectedReports.toString());
  }

  void updateReportType(ReportType type, bool add) {
    if (add) {
      selectedReports[type] = true;
    } else {
      selectedReports[type] = false;
    }
    for (final entry in selectedReports.entries) {
      dPrint(entry.toString());
    }
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
        shrinkWrap: true,
        children: [
          const BLSmallTitle('Select reports to generate:'),
          const SizedBox(height: 15),
          ...List.generate(selectedReports.length, (i) {
            final reportType = selectedReports.keys.toList()[i];
            return ReportTypeSelectorItem(
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
                type: hasSelection ? AdminBtnType.green : AdminBtnType.grey,
                child: const BLText('Generate'),
                onPressed: () {
                  if (!hasSelection) {
                    toast.showToast(context, 'Select a report type.', type: NotifType.error);
                  } else {
                    nav.pop(context, selectedReports);
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

class ReportTypeSelectorItem extends ConsumerStatefulWidget {
  final ReportType type;
  final bool initial;
  final void Function(ReportType, bool) updateReportType;
  const ReportTypeSelectorItem({
    required this.type,
    required this.updateReportType,
    required this.initial,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportTypeSelectorItemState();
}

class _ReportTypeSelectorItemState extends ConsumerState<ReportTypeSelectorItem> {
  late bool selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CheckboxListTile(
        value: selected,
        onChanged: (value) {
          widget.updateReportType(widget.type, value!);
          setState(() {
            selected = value;
          });
        },
        title: BLText(widget.type.capName()),
      ),
    );
  }
}
