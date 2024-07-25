import 'package:flutter/material.dart';

class BlockWrapper extends StatelessWidget {
  const BlockWrapper(this.widgetList, {this.topLevel = false, super.key});
  final List<Widget> widgetList;
  final bool topLevel;

  @override
  Widget build(BuildContext context) {
    if (topLevel == false) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widgetList.length, (i) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: widgetList[i],
                )
              ],
            );
          }),
        ),
      );
    }
    return SingleChildScrollView(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(widgetList.length, (i) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: widgetList[i],
                    )
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
