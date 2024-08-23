import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BLTable extends ConsumerStatefulWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final double bottomPadding;
  const BLTable({
    required this.columns,
    required this.rows,
    this.bottomPadding = 10,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BLTableState();
}

class _BLTableState extends ConsumerState<BLTable> {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: EdgeInsets.only(bottom: widget.bottomPadding),
          decoration: const BoxDecoration(
              //border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: DataTable(
              showCheckboxColumn: false,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              headingRowColor: WidgetStatePropertyAll(Colors.blueGrey.shade700),
              columns: widget.columns,
              rows: widget.rows),
        ),
      ),
    );
  }
}
