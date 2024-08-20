import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/web/screens/accounts/accounts.dart';
import 'package:block_logic/web/screens/challenges/challenges.dart';
import 'package:block_logic/web/screens/dashboard/dashboard.dart';
import 'package:block_logic/web/screens/reports/reports.dart';
import 'package:block_logic/web/screens/settings/settings.dart';
import 'package:block_logic/web/screens/status/not_found.dart';
import 'package:block_logic/web/screens/status/waiting_approval.dart';
import 'package:block_logic/web/screens/web_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router(Future<String?> redirect) {
  final parentKey = GlobalKey<NavigatorState>();
  final shellKey = GlobalKey<NavigatorState>();
  List<List<dynamic>> shellRoutes = [
    ['/dashboard', const Dashboard()],
    ['/reports', const Reports()],
    ['/challenges', const Challenges()],
    ['/settings', const AdminSettings()],
    ['/accounts', const Accounts()]
  ];
  List<List<dynamic>> routes = [
    ['/not-found', const NotFound()],
    ['/waiting-approval', const WaitingApproval()],
    [
      '/login',
      const Login(accountType: FirestoreCollections.admins),
    ],
    ['/verify-email', const VerifyEmail()],
  ];
  return GoRouter(
    navigatorKey: parentKey,
    //debugLogDiagnostics: true, // displays route tree
    initialLocation: '/settings',
    routes: [
      ...List.generate(routes.length, (i) {
        return GoRoute(
            parentNavigatorKey: parentKey,
            path: routes[i][0],
            builder: (context, state) => routes[i][1]);
      }),
      ShellRoute(
          navigatorKey: shellKey,
          pageBuilder: (context, state, child) {
            return NoTransitionPage(
                child: WebScaffold(
              location: state.fullPath!,
              child: child,
            ));
          },
          routes: List.generate(shellRoutes.length, (i) {
            return GoRoute(
                path: shellRoutes[i][0],
                builder: (context, state) => shellRoutes[i][1]);
          })),
    ],
    observers: [routeObserver],
    redirect: (context, state) async {
      return await redirect;
    },
    errorBuilder: (context, state) {
      return const NotFound();
    },
  );
}
