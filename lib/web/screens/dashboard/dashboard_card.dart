import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/components/text/text_span.dart';
import 'package:block_logic/components/text/title_small.dart';
import 'package:block_logic/web/components/card_simple.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardCard extends StatelessWidget {
  final double percent;
  final String downOrup;
  final String titleTotal;
  final int total;
  final Icon icon;
  final Color iconBgColor;
  const DashboardCard({
    super.key,
    required this.percent,
    required this.downOrup,
    required this.titleTotal,
    required this.total,
    required this.icon,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return BLCardSimple(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [Flexible(child: BLText('Total $titleTotal')), Flexible(child: BLSmallTitle(NumberFormat('#,###').format(total)))],
              ),
              SizedBox(width: width * .03),
              Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: iconBgColor,
                  ),
                  child: icon)
            ],
          ),
          SizedBox(height: height * .02),
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     downOrup == 'up'
          //         ? const Icon(
          //             Icons.trending_up_rounded,
          //             color: Colors.green,
          //           )
          //         : const Icon(
          //             Icons.trending_down_rounded,
          //             color: Colors.red,
          //           ),
          //     SizedBox(
          //       width: width / 100,
          //     ),
          //     BLRichText([
          //       TextSpan(text: '$percent% '),
          //       TextSpan(text: '$downOrup from yesterday')
          //     ])
          //   ],
          // )
        ],
      ),
    ));
  }
}
