class Room {
  final String? id;
  final String? hostID;
  final List<String> challengeIDs;
  final String? icon;
  final String? name;
  final String? password;
  final int? capacity;
  Room(
      {required this.id,
      required this.icon,
      required this.hostID,
      required this.challengeIDs,
      required this.name,
      required this.password,
      required this.capacity});

  factory Room.fromFirestore(dynamic doc) {
    // Map<String, dynamic> data = {};
    // if (doc.data() != null) {
    //   data = doc.data() as Map<String, dynamic>;
    // }

    // return Room(
    //   id: doc.id,
    //   icon: data['icon'] ?? '',
    //   hostID: data['hostID'] ?? '',
    //   challengeIDs: data['challengeIDs'] ?? [],
    //   name: data['name'] ?? '',
    //   password: data['password'] ?? '',
    //   capacity: data['capacity'] ?? -1,
    // );
    return Room(
      id: doc.id,
      icon: doc.get('icon') ?? '',
      hostID: doc.get('hostID') ?? '',
      challengeIDs: (doc.get('challengeIDs') as List)
          .map((item) => item as String)
          .toList(), // Transform the List<dynamic> from Firestore to a List<String>
      name: doc.get('name') ?? '',
      password: doc.get('password') ?? '',
      capacity: doc.get('capacity') ?? -1,
    );
  }
}
