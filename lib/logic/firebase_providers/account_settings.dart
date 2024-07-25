import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/firebase_models/account_settings.dart';
import 'package:block_logic/logic/services/auth.dart';
import 'package:block_logic/logic/services/db_instance.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/account_settings.g.dart';

@riverpod
Stream<AccountSettings?> settings(
    SettingsRef ref, FirestoreCollections accountCollection) async* {
  final db = ref.watch(dbProvider);
  final id = ref.read(authServiceStateProvider.notifier).getUID();
  if (id.isEmpty) yield null;
  final stream = db.i.collection(accountCollection.name).doc(id).snapshots();
  await for (final doc in stream) {
    yield AccountSettings.fromFirestore(doc);
  }
}
