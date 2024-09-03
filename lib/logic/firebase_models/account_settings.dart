// import 'package:cloud_firestore/cloud_firestore.dart';

// class AccountSettings {
//   final bool? loginAlerts;
//   final bool? notifications;
//   final bool? soundEffects;
//   final bool? backgroundMusic;
//   AccountSettings({
//     this.loginAlerts,
//     this.notifications,
//     this.soundEffects,
//     this.backgroundMusic,
//   });

//   factory AccountSettings.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = {};
//     if (doc.data() != null) {
//       data = doc.data() as Map<String, dynamic>;
//     }
//     final settings = data['settings'];
//     return AccountSettings(
//       loginAlerts: settings['loginAlerts'],
//       notifications: settings['notifications'],
//       soundEffects: settings['soundEffects'],
//       backgroundMusic: settings['backgroundMusic'],
//     );
//   }

//   Map<String, dynamic> toFirestore() {
//     Map<String, dynamic> userSettings = {};
//     if (backgroundMusic != null) {
//       userSettings.addAll({'backgroundMusic': backgroundMusic});
//     }
//     if (loginAlerts != null) {
//       userSettings.addAll({'loginAlerts': loginAlerts});
//     }
//     if (soundEffects != null) {
//       userSettings.addAll({'soundEffects': soundEffects});
//     }
//     if (notifications != null) {
//       userSettings.addAll({'notifications': notifications});
//     }
//     Map<String, dynamic> toFirestoreMap = {'settings': userSettings};
//     return toFirestoreMap;
//   }
// }
