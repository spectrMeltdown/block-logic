import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class DB {
  /// Firestore instance
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static String userName = FirebaseAuth.instance.currentUser?.displayName ?? 'User';
  static String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Email';

  /// Important IDs required for accessing user data. Empty if instructor not logged in.
  static int? instructorID;
  static String? userUID;
  static String? cachedProfilePic;

  /// The user data reference for easier accessing. Null if not logged in.
  static DocumentReference<Map<String, dynamic>>? userDataRef;

  /// Gets [userDataRef], [instructorID], and [userUID] after login for easier accessing. Is removed before logout.
  static Future<bool> getSessionData() async {
    userUID = FirebaseAuth.instance.currentUser?.uid;
    // if (PreferenceUtils.getBool('isInstructor') == true) {
    //   userDataRef = db.doc('instructors/$userUID');
    //   try {
    //     final userData = await userDataRef?.get();
    //     if (userData?.exists == null) return false;
    //     if (userData!.exists == false) return false;
    //     instructorID = userData.get('school_id');
    //     classRecords = db.collection('class_records').where('instructor', isEqualTo: instructorID);
    //     debugPrint('instructor school id reloaded');
    //   } catch (e) {
    //     debugPrint('error getting school id');
    //   }
    // } else {
    //   userDataRef = db.doc('students/$userUID');
    //   try {
    //     final userData = await userDataRef?.get();
    //     if (userData?.exists == null) return false;
    //     if (userData!.exists == false) return false;
    //     studentID = userData.get('school_id');
    //     debugPrint('student school id reloaded');
    //   } catch (e) {
    //     debugPrint('error getting school id');
    //   }
    // }
    return true;
  }

  /// Some reusable variables & references from Firebase
  static FieldValue timeStamp = FieldValue.serverTimestamp();
  static CollectionReference instructorsRef = db.collection('instructors');

  /// returns class records of current instructor
  /// - includes all subjects
  /// - includes all sections under each subject
  static Query<Map<String, dynamic>>? classRecords;

  /// returns all sections under a subject
  /// - includes one subject
  /// - includes all sections under that subject
  static Query<Map<String, dynamic>> sectionsUnderSubject(String? subjectCode) {
    return classRecords!.where('subject_code', isEqualTo: subjectCode);
  }

  /// returns a section under a subject
  /// - includes one subject
  /// - includes one section under that subject
  static Query<Map<String, dynamic>> sectionUnderSubject(String? subjectCode, String? section) {
    /// added limit 1 at last because we are only getting one section
    return classRecords!.where('subject_code', isEqualTo: subjectCode).where('section', isEqualTo: section).limit(1);
  }

  static Query<Map<String, dynamic>>? studentsInSubjectOrdered;

  /// students per instructor subject, order by last name
  static CollectionReference<Map<String, dynamic>>? studentsInSubject;

  /// Get students under subject section
  static Future<bool> loadStudents(String? subjectCode, String? section) async {
    /// get the subject section
    final sectionDocs = await sectionUnderSubject(subjectCode, section).get();
    final selectedSection = sectionDocs.docs.first;

    /// return the students
    studentsInSubject = selectedSection.reference.collection('students');
    studentsInSubjectOrdered = selectedSection.reference.collection('students').orderBy('last_name');
    return true;
  }

  static int? studentID;
  static CollectionReference<Map<String, dynamic>> studentRef = db.collection('students');
  static Reference? storageRef = FirebaseStorage.instance.ref('instructors/$userUID');
  static Reference? studentStorageRef = FirebaseStorage.instance.ref('students/$userUID');
}

class PreferenceUtils {}
