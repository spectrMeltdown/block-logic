import 'package:block_logic/components/text/title.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/services/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerStatefulWidget {
  final String title;
  const Header({required this.title, super.key});

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final assets = ref.read(assetsProvider);
    return Stack(
      children: [
        Row(
          children: [
            Flexible(
              child: ClipRRect(
                child: SizedBox(
                  height: height * .2,
                  width: width * .9,
                  child: Image.asset(
                    assets.headerWeb,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Flexible(
              child: ClipRRect(
                child: SizedBox(
                  height: height * .2,
                  width: width * .6,
                  child: Image.asset(
                    assets.headerWeb,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: width <= mobileMax
              ? const EdgeInsets.only(left: 50)
              : EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: BLTitle(widget.title, allCaps: false))
              ],
            ),
          ),
        )
      ],
    );
  }
}
