import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/web/screens/accounts/accounts.dart';
import 'package:block_logic/web/screens/accounts/create_admin.dart';
import 'package:block_logic/web/screens/challenges/challenges.dart';

import 'package:block_logic/web/screens/challenges/create_edit_challenge.dart';
import 'package:block_logic/web/screens/dashboard/dashboard.dart';
import 'package:block_logic/web/screens/feedback/feedback.dart';
import 'package:block_logic/web/screens/feedback/view_feedback_dialog.dart';
import 'package:block_logic/web/screens/other/not_found.dart';
import 'package:block_logic/web/screens/other/redirecting.dart';
import 'package:block_logic/web/screens/other/unauthorized.dart';
import 'package:block_logic/web/screens/reports/reports.dart';
import 'package:block_logic/web/screens/rooms/rooms.dart';
import 'package:block_logic/web/screens/settings/settings.dart';
import 'package:block_logic/web/screens/web_scaffold.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

FutureOr<bool> onExitCreate(BuildContext context, GoRouterState state) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: const BLText('Are you sure to leave this page?\nThis will not be saved.', color: Colors.white),
        actions: <Widget>[
          BLTextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          BLTextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

FutureOr<bool> onExitEdit(BuildContext context, GoRouterState state) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        content: const BLText('Are you sure to leave this page?\nYour changes will not be saved.', color: Colors.white),
        actions: <Widget>[
          BLTextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const BLText(
              'Cancel',
              color: Colors.red,
            ),
          ),
          BLTextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const BLText(
              'Confirm',
              color: Colors.blue,
            ),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}

Page pageTransition({required Widget child}) {
  return NoTransitionPage(
    child: FadeIn(child: child),
    // transitionDuration: const Duration(milliseconds: 500),
    // reverseTransitionDuration: const Duration(milliseconds: 500),
    // transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //   return FadeTransition(
    //     opacity: animation,
    //     child: child,
    //   );
    // },
  );
}

GoRouter router() {
  final parentKey = GlobalKey<NavigatorState>();
  final shellKey = GlobalKey<NavigatorState>();
  Map<String, List<dynamic>> shellRoutes = {
    'dashboard': ['/dashboard', pageTransition(child: const Dashboard())],
    'reports': ['/reports', pageTransition(child: const Reports())],
    'feedback': ['/feedback', pageTransition(child: const FeedbackManager())],
    'challenges': ['/challenges', pageTransition(child: const Challenges())],
    'settings': ['/settings', pageTransition(child: const AdminSettings())],
    'accounts': ['/accounts', pageTransition(child: const Accounts())],
    'rooms': ['/rooms', pageTransition(child: const RoomsManager())]
  };
  List<List<dynamic>> routes = [
    ['/not-found', const NotFound()],
    ['/unauthorized', const Unauthorized()],
    [
      '/login',
      const Login(accountType: FirestoreCollections.admins),
    ],
    ['/verify-email', const VerifyEmail()],
    // ['/verify-phone-num', const VerifyPhoneNum()],
    ['/redirecting', const RedirectingWebPage()],
  ];
  return GoRouter(
    navigatorKey: parentKey,
    // debugLogDiagnostics: true,
    initialLocation: '/dashboard',
    routes: [
      ...List.generate(routes.length, (i) {
        return GoRoute(
          parentNavigatorKey: parentKey,
          path: routes[i][0],
          builder: (context, state) => routes[i][1],
        );
      }),
      ShellRoute(
        navigatorKey: shellKey,
        pageBuilder: (context, state, child) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: FadeIn(
              child: WebScaffold(
                state: state,
                child: child,
              ),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: shellRoutes['dashboard']![0],
            pageBuilder: (context, state) => shellRoutes['dashboard']![1],
          ),
          GoRoute(
            path: shellRoutes['reports']![0],
            pageBuilder: (context, state) => shellRoutes['reports']![1],
          ),
          GoRoute(
            path: shellRoutes['feedback']![0],
            pageBuilder: (context, state) => shellRoutes['feedback']![1],
            routes: [
              GoRoute(
                path: 'view/:id',
                pageBuilder: (context, state) => pageTransition(child: ViewFeedback(state.pathParameters['id']!)),
              )
            ],
          ),
          GoRoute(path: shellRoutes['challenges']![0], pageBuilder: (context, state) => shellRoutes['challenges']![1], routes: [
            GoRoute(
              path: 'edit/:id',
              pageBuilder: (context, state) => pageTransition(child: CreateEditChallenge(createMode: false, selectedChallengeID: state.pathParameters['id']!)),
              // onExit: onExitEdit,
            ),
            GoRoute(
              path: 'create',
              pageBuilder: (context, state) => pageTransition(
                  child: const CreateEditChallenge(
                createMode: true,
              )),
              // onExit: onExitCreate,
            ),
          ]),
          GoRoute(
            path: shellRoutes['settings']![0],
            pageBuilder: (context, state) => shellRoutes['settings']![1],
          ),
          GoRoute(
            path: shellRoutes['accounts']![0],
            pageBuilder: (context, state) => shellRoutes['accounts']![1],
            routes: [
              GoRoute(
                path: 'create-admin',
                pageBuilder: (context, state) => pageTransition(child: const CreateAdmin()),
              )
            ],
          ),
          GoRoute(
            path: shellRoutes['rooms']![0],
            pageBuilder: (context, state) => shellRoutes['rooms']![1],
          ),
        ],
      ),
    ],
    observers: [routeObserver],
    redirect: (context, state) async {
      // debugPrint('redirect called');
      // return '/accounts';
      final user = FirebaseAuth.instance.currentUser;
      if (user?.uid != null) {
        if (user!.emailVerified == false) {
          /// go to email verification screen (after main menu finish building)
          return '/verify-email';
        }

        final doc = await FirebaseDatabase.instance.ref('admins').child(user.uid).get();
        // final adminFirestore = AdminAccount.fromRTDB(doc);
        if (doc.exists == false) {
          return '/unauthorized';
        }
        // if (adminFirestore.verificationID != null && adminFirestore.verificationID!.isEmpty) {
        //   return '/verify-phone-num';
        // }
        // debugPrint(state.matchedLocation);

        /// prevent going back to login page when already logged in
        if (state.matchedLocation == '/login') {
          return '/dashboard';
        }
        if (state.fullPath != null && state.fullPath!.contains('challenges/create')) {
          // debugPrint('redirecting create challenge');
          return '/challenges/create';
        }
        if (state.fullPath != null && state.fullPath!.contains('challenges/edit')) {
          // debugPrint('redirecting edit challenge: ${state.fullPath}');
          // debugPrint('path parameters: ${state.pathParameters['id']}');
          return '/challenges/edit/${state.pathParameters['id']}';
        }
        return null;
      } else {
        return '/login';
      }
    },
    errorBuilder: (context, state) {
      return const NotFound();
    },
  );
}
