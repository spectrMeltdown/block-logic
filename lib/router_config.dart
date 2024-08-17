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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

GoRouter router(AsyncValue<String> redirect) {
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
    routes: [
      ...List.generate(routes.length, (i) {
        return GoRoute(
            path: routes[i][0], builder: (context, state) => routes[i][1]);
      }),
      ShellRoute(
          navigatorKey: shellKey,
          routes: List.generate(shellRoutes.length, (i) {
            return GoRoute(
                parentNavigatorKey: shellKey,
                path: shellRoutes[i][0],
                builder: (context, state) => shellRoutes[i][1]);
          })),
    ],
    observers: [routeObserver],
    redirect: (context, state) async {
      return redirect.when(
          data: (link) {
            return link;
          },
          error: (error, stackTrace) => '/notfound',
          loading: () => '/loading');
    },
    errorBuilder: (context, state) {
      return const NotFound();
    },
  );
}
