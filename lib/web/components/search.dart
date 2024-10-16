import 'package:block_logic/logic/services/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminSearchBar extends ConsumerStatefulWidget {
  final void Function(String) searchQueryCallBack;
  final EdgeInsets? padding;
  const AdminSearchBar(this.searchQueryCallBack, {this.padding, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminSearchBarState();
}

class _AdminSearchBarState extends ConsumerState<AdminSearchBar> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: SearchBar(
          controller: searchController,
          hintText: 'Search ...',
          backgroundColor: WidgetStatePropertyAll(Colors.blueGrey.brighten(0.3)),
          leading: const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.search_rounded,
              color: Colors.white,
            ),
          ),
          trailing: [IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward))],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 30),
    //   child: BLTextBox(
    //     controller: widget.searchController,
    //     prefixIcon: const Icon(
    //       Icons.search_rounded,
    //       color: Colors.white,
    //     ),
    //     labelText: 'Search ...',
    //     suffixIcon: const Icon(
    //       FontAwesomeIcons.arrowRightLong,
    //       color: Colors.white,
    //       size: 20,
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    searchController.addListener(() {
      setState(() {
        widget.searchQueryCallBack.call(searchController.text.trim());
      });
    });
    super.initState();
  }
}
