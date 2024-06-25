import 'package:cloud_firestore/cloud_firestore.dart';
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
  final DateTime createdAt;
  final DateTime modifiedAt;
  TimestampModel({required this.createdAt, required this.modifiedAt});
}

class UserModel extends TimestampModel {
  final String id;
  final String profilePic;
  UserModel({
    required this.id,
    required this.profilePic,
    required super.createdAt,
    required super.modifiedAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      profilePic: data['profilePic'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }
}

class Admin extends TimestampModel {
  final String id;
  final String profilePic;
  final bool isApproved;
  Admin({
    required this.id,
    required this.isApproved,
    required this.profilePic,
    required super.createdAt,
    required super.modifiedAt,
  });

  factory Admin.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Admin(
      id: doc.id,
      isApproved: data['isApproved'] ?? false,
      profilePic: data['profilePic'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      modifiedAt: (data['modifiedAt'] as Timestamp).toDate(),
    );
  }
}

class Report extends TimestampModel {
  final String id;
  final bool reportType;
  final String data;
  final DateTime startDate;
  final DateTime endDate;
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

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'reportType': reportType,
      'data': data,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
    };
  }
}

class Settings {
  final String id;
  final bool loginAlerts;
  final bool notifications;
  final bool soundEffects;
  final bool backgroundMusic;
  Settings(
      {required this.id,
      required this.loginAlerts,
      required this.notifications,
      required this.soundEffects,
      required this.backgroundMusic});

  factory Settings.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Settings(
      id: doc.id,
      loginAlerts: data['loginAlerts'] ?? false,
      notifications: data['notifications'] ?? false,
      soundEffects: data['soundEffects'] ?? false,
      backgroundMusic: data['backgroundMusic'] ?? false,
    );
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

class Feedback {
  final String id;
  final String title;
  final String message;
  final DateTime createdAt;
  Feedback({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory Feedback.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Feedback(
      id: doc.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
