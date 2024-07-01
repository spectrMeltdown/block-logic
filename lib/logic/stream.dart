import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamService {
  final user = StreamProvider.autoDispose((ref) => FirebaseAuth.instance.authStateChanges());
}
