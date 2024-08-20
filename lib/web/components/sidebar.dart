import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/profile_pic.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Sidebar extends ConsumerStatefulWidget {
  final String location;
  const Sidebar({required this.location, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SidebarState();
}

enum WebScaffoldPages {
  dashboard,
  challenges,
  accounts,
  reports,
  settings,
}

class _SidebarState extends ConsumerState<Sidebar> {
  int? selected;
  late List<String> locations;
  double sidebarCompactWidth = 200;
  late double width;

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.blueGrey.shade800,
      constraints: BoxConstraints(maxWidth: sidebarCompactWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 20),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  BLProfilePic(auth.getUID()),
                  const SizedBox(width: 10),
                  Flexible(child: BLDisplayName(auth.getUID())),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
          ...items()
        ],
      ),
    );
  }

  Icon getIcon(WebScaffoldPages page) {
    switch (page) {
      case WebScaffoldPages.challenges:
        return const Icon(Icons.lightbulb);
      case WebScaffoldPages.settings:
        return const Icon(Icons.settings);
      case WebScaffoldPages.accounts:
        return const Icon(Icons.people);
      case WebScaffoldPages.reports:
        return const Icon(Icons.library_books);
      case WebScaffoldPages.dashboard:
        return const Icon(Icons.dashboard_rounded);
    }
  }

  void go(int index) {
    switch (WebScaffoldPages.values[index]) {
      case WebScaffoldPages.challenges:
        context.go('/challenges');
        break;
      case WebScaffoldPages.settings:
        context.go('/settings');
        break;
      case WebScaffoldPages.accounts:
        context.go('/accounts');
        break;
      case WebScaffoldPages.reports:
        context.go('/reports');
        break;
      case WebScaffoldPages.dashboard:
        context.go('/dashboard');
        break;
    }
  }

  @override
  void initState() {
    locations = List.generate(WebScaffoldPages.values.length, (i) {
      return '/${WebScaffoldPages.values[i].name}';
    });
    debugPrint(locations.first);
    for (final location in locations.indexed) {
      if (widget.location == location.$2) {
        selected = location.$1;
      }
    }
    selected ??= 0;
    super.initState();
  }

  List items([bool isCompact = false]) {
    return List.generate(WebScaffoldPages.values.length, (i) {
      final title = WebScaffoldPages.values[i].name;
      final capital = title.substring(0, 1).toUpperCase();
      final lower = title.substring(1, title.length);
      return Flexible(
        child: GestureDetector(
          onTap: () {
            go(i);
            setState(() {
              selected = i;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: selected == i ? Colors.blue : Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
            margin: EdgeInsets.symmetric(
                vertical: 2, horizontal: width <= mobileMax ? 5 : 10),
            child: Row(
              children: [
                SizedBox(width: width <= mobileMax ? 5 : 15),
                getIcon(WebScaffoldPages.values[i]),
                if (!isCompact) const SizedBox(width: 15),
                if (!isCompact) BLText('$capital$lower'),
                SizedBox(width: width <= mobileMax ? 5 : 15),
              ],
            ),
          ),
        ),
      );
    });
  }
}
