import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/db_instance.g.dart';

@riverpod
DB db(DbRef ref) {
  return DB();
}

class DB {
  final FirebaseFirestore i = FirebaseFirestore.instance;
  final Reference userStorageRef = FirebaseStorage.instance.ref('users/');
  final Reference adminStorageRef = FirebaseStorage.instance.ref('admins/');
}
