import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/screens/auth/verify_phone_num.dart';
import 'package:block_logic/web/screens/accounts/accounts.dart';
import 'package:block_logic/web/screens/accounts/create_admin.dart';
import 'package:block_logic/web/screens/challenges/challenges.dart';
import 'package:block_logic/web/screens/challenges/create_challenge.dart';
import 'package:block_logic/web/screens/dashboard/dashboard.dart';
import 'package:block_logic/web/screens/feedback/feedback.dart';
import 'package:block_logic/web/screens/feedback/view_feedback.dart';
import 'package:block_logic/web/screens/other/not_found.dart';
import 'package:block_logic/web/screens/other/unauthorized.dart';
import 'package:block_logic/web/screens/reports/generate.dart';
import 'package:block_logic/web/screens/reports/reports.dart';
import 'package:block_logic/web/screens/rooms/rooms.dart';
import 'package:block_logic/web/screens/settings/settings.dart';
import 'package:block_logic/web/screens/web_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router(Future<String?> redirect) {
  final parentKey = GlobalKey<NavigatorState>();
  final shellKey = GlobalKey<NavigatorState>();
  Map<String, List<dynamic>> shellRoutes = {
    'dashboard': ['/dashboard', const Dashboard()],
    'reports': ['/reports', const Reports()],
    'feedback': ['/feedback', const FeedbackManager()],
    'challenges': ['/challenges', const Challenges()],
    'settings': ['/settings', const AdminSettings()],
    'accounts': ['/accounts', const Accounts()],
    'rooms': ['/rooms', const RoomsManager()]
  };
  List<List<dynamic>> routes = [
    ['/not-found', const NotFound()],
    ['/unauthorized', const Unauthorized()],
    [
      '/login',
      const Login(accountType: FirestoreCollections.admins),
    ],
    ['/verify-email', const VerifyEmail()],
    ['/verify-phone-num', const VerifyPhoneNum()],
  ];
  return GoRouter(
    navigatorKey: parentKey,
    //debugLogDiagnostics: true,
    initialLocation: '/dashboard',
    routes: [
      ...List.generate(routes.length, (i) {
        return GoRoute(parentNavigatorKey: parentKey, path: routes[i][0], builder: (context, state) => routes[i][1]);
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
          routes: [
            GoRoute(
              path: shellRoutes['dashboard']![0],
              builder: (context, state) => shellRoutes['dashboard']![1],
            ),
            GoRoute(path: shellRoutes['reports']![0], builder: (context, state) => shellRoutes['reports']![1], routes: [
              GoRoute(
                path: 'generate',
                builder: (context, state) => const GenerateReport(),
              )
            ]),
            GoRoute(
                path: shellRoutes['feedback']![0],
                builder: (context, state) => shellRoutes['feedback']![1],
                routes: [
                  GoRoute(
                    path: 'view/:id',
                    builder: (context, state) => ViewFeedback(state.pathParameters['id']!),
                  )
                ]),
            GoRoute(
                path: shellRoutes['challenges']![0],
                builder: (context, state) => shellRoutes['challenges']![1],
                routes: [
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateChallenge(),
                  )
                ]),
            GoRoute(
              path: shellRoutes['settings']![0],
              builder: (context, state) => shellRoutes['settings']![1],
            ),
            GoRoute(
                path: shellRoutes['accounts']![0],
                builder: (context, state) => shellRoutes['accounts']![1],
                routes: [
                  GoRoute(
                    path: 'create-admin',
                    builder: (context, state) => const CreateAdmin(),
                  )
                ]),
            GoRoute(
              path: shellRoutes['rooms']![0],
              builder: (context, state) => shellRoutes['rooms']![1],
            ),
          ]),
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
