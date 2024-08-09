import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSettings {
  final bool? loginAlerts;
  final bool? notifications;
  final bool? soundEffects;
  final bool? backgroundMusic;
  AccountSettings({
    this.loginAlerts,
    this.notifications,
    this.soundEffects,
    this.backgroundMusic,
  });

  factory AccountSettings.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = {};
    if (doc.data() != null) {
      data = doc.data() as Map<String, dynamic>;
    }
    return AccountSettings(
      loginAlerts: data['loginAlerts'],
      notifications: data['notifications'],
      soundEffects: data['soundEffects'],
      backgroundMusic: data['backgroundMusic'],
    );
  }

  Map<String, dynamic> toFirestore(AccountSettings settings) {
    Map<String, dynamic> userSettings = {};
    if (settings.backgroundMusic != null) {
      userSettings.addAll({'backgroundMusic': settings.backgroundMusic});
    }
    if (settings.loginAlerts != null) {
      userSettings.addAll({'loginAlerts': settings.loginAlerts});
    }
    if (settings.soundEffects != null) {
      userSettings.addAll({'soundEffects': settings.soundEffects});
    }
    if (settings.notifications != null) {
      userSettings.addAll({'notifications': settings.notifications});
    }
    Map<String, dynamic> toFirestoreMap = {'settings': userSettings};
    return toFirestoreMap;
  }
}
