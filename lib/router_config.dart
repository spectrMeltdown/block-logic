import 'dart:async';

import 'package:block_logic/components/button/text.dart';
import 'package:block_logic/components/text/text.dart';
import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/admin_account.dart';
import 'package:block_logic/route_observer.dart';
import 'package:block_logic/screens/auth/login.dart';
import 'package:block_logic/screens/auth/verify_email.dart';
import 'package:block_logic/screens/auth/verify_phone_num.dart';
import 'package:block_logic/web/screens/accounts/accounts.dart';
import 'package:block_logic/web/screens/accounts/create_admin.dart';
import 'package:block_logic/web/screens/challenges/challenges.dart';
import 'package:block_logic/web/screens/challenges/create_challenge.dart';
import 'package:block_logic/web/screens/challenges/edit_challenge.dart';
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

GoRouter router() {
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
    ['/redirecting', const RedirectingWebPage()],
  ];
  return GoRouter(
    navigatorKey: parentKey,
    debugLogDiagnostics: true,
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
            GoRoute(path: shellRoutes['reports']![0], builder: (context, state) => shellRoutes['reports']![1]),
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
                    path: 'edit/:id',
                    builder: (context, state) => EditChallenge(state.pathParameters['id']!),
                    // onExit: onExitEdit,
                  ),
                  GoRoute(
                    path: 'create',
                    builder: (context, state) => const CreateChallenge(),
                    // onExit: onExitCreate,
                  ),
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
      final user = FirebaseAuth.instance.currentUser;
      if (user?.uid != null) {
        if (user!.emailVerified == false) {
          /// go to email verification screen (after main menu finish building)
          return '/verify-email';
        }

        final doc = await FirebaseFirestore.instance.collection('admins').doc(user.uid).get();
        // final adminFirestore = AdminAccount.fromFirestore(doc);
        if (doc.exists == false) {
          return '/unauthorized';
        }
        // if (adminFirestore.verificationID != null && adminFirestore.verificationID!.isEmpty) {
        //   return '/verify-phone-num';
        // }
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
