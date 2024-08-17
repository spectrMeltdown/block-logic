import 'package:block_logic/components/account/display_name.dart';
import 'package:block_logic/components/background.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/web/screens/accounts/accounts.dart';
import 'package:block_logic/web/screens/challenges/challenges.dart';
import 'package:block_logic/web/screens/dashboard/dashboard.dart';
import 'package:block_logic/web/screens/reports/reports.dart';
import 'package:block_logic/web/screens/settings/settings.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WebScaffold extends ConsumerStatefulWidget {
  final WebScaffoldPages page;
  final Widget child;
  const WebScaffold({required this.page, required this.child, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebScaffoldState();
}

enum WebScaffoldPages {
  dashboard,
  challenges,
  accounts,
  reports,
  settings,
}

class _WebScaffoldState extends ConsumerState<WebScaffold> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  final style = SideMenuStyle(
    displayMode: SideMenuDisplayMode.auto,
    openSideMenuWidth: 250,
    compactSideMenuWidth: 40,
    hoverColor: Colors.blue[100],
    selectedColor: Colors.lightBlue,
    selectedIconColor: Colors.white,
    unselectedIconColor: Colors.grey,
    backgroundColor: Colors.blueGrey.shade900,
    selectedTitleTextStyle: const TextStyle(color: Colors.white),
    unselectedTitleTextStyle: const TextStyle(color: Colors.grey),
    iconSize: 20,
    itemBorderRadius: const BorderRadius.all(
      Radius.circular(5.0),
    ),
    showTooltip: true,
    showHamburger: true,
    itemHeight: 50.0,
    itemInnerSpacing: 8.0,
    itemOuterPadding: const EdgeInsets.symmetric(vertical: 5),
    toggleColor: Colors.black54,

    // Additional properties for expandable items
    selectedTitleTextStyleExpandable:
        const TextStyle(color: Colors.white), // Adjust the style as needed
    unselectedTitleTextStyleExpandable:
        const TextStyle(color: Colors.grey), // Adjust the style as needed
    selectedIconColorExpandable: Colors.white, // Adjust the color as needed
    unselectedIconColorExpandable: Colors.grey, // Adjust the color as needed
    arrowCollapse: Colors.blueGrey, // Adjust the color as needed
    arrowOpen: Colors.lightBlueAccent, // Adjust the color as needed
    iconSizeExpandable: 24.0, // Adjust the size as needed
  );

  @override
  Widget build(BuildContext context) {
    final auth = ref.read(authServiceProvider.notifier);
    return Scaffold(
      body: Background(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              style: style,
              controller: sideMenu,
              // Will shows on top of all items, it can be a logo or a Title text
              title: Row(
                children: [BLDisplayName(auth.getUID())],
              ),
              // Will show on bottom of SideMenu when displayMode was SideMenuDisplayMode.open
              footer: const Text('demo'),
              // Notify when display mode changed
              onDisplayModeChanged: (mode) {
                debugPrint(mode.name);
              },
              // List of SideMenuItem to show them on SideMenu
              items: items(),
            ),
            Expanded(child: widget.child),
          ],
        ),
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

  Widget getWidget(WebScaffoldPages page) {
    switch (page) {
      case WebScaffoldPages.challenges:
        return const Challenges();
      case WebScaffoldPages.settings:
        return const AdminSettings();
      case WebScaffoldPages.accounts:
        return const Accounts();
      case WebScaffoldPages.reports:
        return const Reports();
      case WebScaffoldPages.dashboard:
        return const Dashboard();
    }
  }

  @override
  void initState() {
    // Connect SideMenuController and PageController together
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  List items() {
    void onTap(int index, SideMenuController _) {
      sideMenu.changePage(index);
      updateLink(index);
    }

    return List.generate(WebScaffoldPages.values.length, (i) {
      final title = WebScaffoldPages.values[i].name;
      final capital = title.substring(0, 1).toUpperCase();
      final letters = title.substring(1, title.length);
      return SideMenuItem(
        title: '$capital$letters',
        onTap: onTap,
        icon: getIcon(WebScaffoldPages.values[i]),
      );
    });
  }

  void updateLink(int index) {
    switch (WebScaffoldPages.values[index]) {
      case WebScaffoldPages.challenges:
        debugPrint('challenges');
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
        context.go('/');
        break;
    }
  }
}
