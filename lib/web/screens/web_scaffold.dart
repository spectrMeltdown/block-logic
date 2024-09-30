import 'package:block_logic/components/background.dart';
import 'package:block_logic/constants.dart';
import 'package:block_logic/web/components/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarToggle extends ConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const SidebarToggle({required this.scaffoldKey, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 25),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: Colors.blue.shade700,
            boxShadow: const [
              BoxShadow(blurRadius: 20),
            ],
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            onTap: () {
              scaffoldKey.currentState?.openDrawer();
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.menu),
            ),
          ),
        ),
      ),
    );
  }
}

class WebScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final String location;
  const WebScaffold({required this.child, required this.location, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WebScaffoldState();
}

class _WebScaffoldState extends ConsumerState<WebScaffold> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final sidebar = Sidebar(
      location: widget.location,
      closeDrawer: closeDrawer,
    );
    //debugPrint(FirebaseAuth.instance.currentUser?.uid);
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child: sidebar),
      body: Background(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (width >= mobileMax) sidebar,
            Expanded(
              child: Stack(
                children: [
                  widget.child,
                  if (width <= mobileMax) SidebarToggle(scaffoldKey: scaffoldKey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
