import 'dart:async';

import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/account_settings.g.dart';

@riverpod
Stream<AccountSettings?> settings(SettingsRef ref, FirestoreCollections accountCollection) async* {
  await for (final auth in FirebaseAuth.instance.authStateChanges()) {
    if (auth != null) {
      final db = FirebaseFirestore.instance;
      final id = ref.read(authServiceProvider.notifier).getUID();
      final stream = db.collection(accountCollection.name).doc(id).snapshots();
      await for (final doc in stream) {
        yield AccountSettings.fromFirestore(doc);
      }
    }
  }
}
