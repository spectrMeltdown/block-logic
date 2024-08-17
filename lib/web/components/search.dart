import 'package:block_logic/components/textbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminSearchBar extends ConsumerStatefulWidget {
  final TextEditingController searchController;
  const AdminSearchBar({required this.searchController, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminSearchBarState();
}

class _AdminSearchBarState extends ConsumerState<AdminSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: BLTextBox(
        controller: widget.searchController,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Colors.white,
        ),
        labelText: 'Search ...',
        suffixIcon: const Icon(
          FontAwesomeIcons.arrowRightLong,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
