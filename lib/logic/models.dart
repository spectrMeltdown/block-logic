import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// each represents a document in Firestore

// TODO: Decide if notifications is saved in db or not
// class Notifications {
//   final String id;
//   final String title;
//   final String message;
//   final DateTime createdAt;
//   Notifications({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.createdAt,
//   });

//   factory Notifications.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     return Notifications(
//       id: doc.id,
//       title: data['title'] ?? '',
//       message: data['message'] ?? '',
//       createdAt: (data['createdAt'] as Timestamp).toDate(),
//     );
//   }
// }

class TimestampModel {
  final DateTime? createdAt;
  final DateTime? modifiedAt;
  TimestampModel({required this.createdAt, required this.modifiedAt});
}

class UserDetails extends TimestampModel {
  final String? id;
  UserDetails({
    this.id,
    super.createdAt,
    super.modifiedAt,
  });

  factory UserDetails.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserDetails(
      id: doc.id,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore(UserDetails details) {
    Map<String, dynamic> toFirestoreMap = {};
    if (details.id != null) toFirestoreMap.addAll({'id': details.id});
    if (details.createdAt != null) toFirestoreMap.addAll({'createdAt': Timestamp.fromDate(details.createdAt!)});
    if (details.modifiedAt != null) toFirestoreMap.addAll({'modifiedAt': Timestamp.fromDate(details.modifiedAt!)});
    return toFirestoreMap;
  }
}

class AdminDetails extends TimestampModel {
  final String? id;
  final bool isApproved;
  AdminDetails({
    required this.id,
    required this.isApproved,
    required super.createdAt,
    required super.modifiedAt,
  });

  factory AdminDetails.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AdminDetails(
      id: doc.id,
      isApproved: data['isApproved'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }
}

class Report extends TimestampModel {
  final String? id;
  final bool? reportType;
  final String? data;
  final DateTime? startDate;
  final DateTime? endDate;
  Report({
    required this.id,
    required this.reportType,
    required this.data,
    required this.startDate,
    required this.endDate,
    required super.createdAt,
    required super.modifiedAt,
  });

  factory Report.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Report(
      id: doc.id,
      reportType: data['reportType'] ?? '',
      data: data['data'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }
}

Stream<String?> accountPhotoURLStream() async* {
  await for (User? user in FirebaseAuth.instance.userChanges()) {
    yield user?.photoURL;
  }
}

class AccountSettings {
  final bool? loginAlerts;
  final bool? notifications;
  final bool? soundEffects;
  final bool? backgroundMusic;
  AccountSettings({this.loginAlerts, this.notifications, this.soundEffects, this.backgroundMusic});

  factory AccountSettings.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return AccountSettings(
      loginAlerts: data['loginAlerts'] ?? false,
      notifications: data['notifications'] ?? false,
      soundEffects: data['soundEffects'] ?? false,
      backgroundMusic: data['backgroundMusic'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore(AccountSettings settings) {
    Map<String, dynamic> userSettings = {};
    if (settings.backgroundMusic != null) userSettings.addAll({'backgroundMusic': settings.backgroundMusic});
    if (settings.loginAlerts != null) userSettings.addAll({'loginAlerts': settings.loginAlerts});
    if (settings.soundEffects != null) userSettings.addAll({'soundEffects': settings.soundEffects});
    if (settings.notifications != null) userSettings.addAll({'notifications': settings.notifications});
    Map<String, dynamic> toFirestoreMap = {'settings': userSettings};
    return toFirestoreMap;
  }
}

class Room {
  final String id;
  final String hostID;
  final List<String> challengeIDs;
  final String name;
  final String password;
  final int capacity;
  Room(
      {required this.id,
      required this.hostID,
      required this.challengeIDs,
      required this.name,
      required this.password,
      required this.capacity});

  factory Room.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Room(
      id: doc.id,
      hostID: data['hostID'] ?? '',
      challengeIDs: data['challengeIDs'] ?? [],
      name: data['name'] ?? '',
      password: data['password'] ?? '',
      capacity: data['capacity'] ?? -1,
    );
  }
}

class Score {
  final String id;
  final int overallScore;
  final DateTime runTime;
  final int timeElapsed;
  final int rank;
  Score(
      {required this.id,
      required this.overallScore,
      required this.rank,
      required this.runTime,
      required this.timeElapsed});

  factory Score.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Score(
      id: doc.id,
      overallScore: data['overallScore'] ?? -1,
      rank: data['rank'] ?? -1,
      runTime: (data['runTime'] as Timestamp).toDate(),
      timeElapsed: data['timeElapsed'] ?? -1,
    );
  }
}

class Leaderboard {
  final String id;
  final List<String> accountIDs;
  final DateTime dateCreated;
  Leaderboard({
    required this.id,
    required this.accountIDs,
    required this.dateCreated,
  });

  factory Leaderboard.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Leaderboard(
      id: doc.id,
      accountIDs: data['accountIDs'] ?? [],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }
}

class Challenge {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final bool isShared;
  final List<String> tags;
  final DateTime dateCreated;
  Challenge({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.isShared,
    required this.tags,
    required this.dateCreated,
  });

  factory Challenge.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Challenge(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      difficulty: data['difficulty'] ?? '',
      isShared: data['isShared'] ?? false,
      tags: data['tags'] ?? [],
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }
}

class FeedbackModel {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  FeedbackModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return FeedbackModel(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
