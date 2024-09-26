enum AccountType { admin, user }

enum BLColors {
  grey,
  blue,
  darkblue,
  lightblue,
  amber,
  orange,
  lightgreen,
}

enum BtnType { normal, green, red, orange, grey }

enum CodeBlockState { inSelector, inEditor }

/// Used to define a block type in [Game] widget.
enum CodeBlockType {
  variables,
  functions,
  objects,
  operators,
  keywords,
  literals,
  conditionals,
  loops,
  statement,
}

enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

enum FirestoreCollections { admins, users, rooms, reports, leaderboards, scores, settings, notifications, challenges, feedback }

/// Similar to [ScoreStatus]
/// - incomplete if the host destroyed the room, or if the admin locked it
/// - pending if game is currently ongoing
enum LeaderboardStatus { pending, incomplete, complete }

enum LoadingType { full, normal }

enum NotifType { info, warning, error, success }

enum ReportType {
  users,
  rooms,
  challengesPlayed,
  roomsPlayed,
  premiumUsers,
  freeUsers,
  leaderboards,
}

/// - ongoing, self explanatory
/// - incomplete, when one of the following occurs:
///   - all players left the room
///   - admin or host user terminated the room
/// - complete, the game finished with no errors
enum RoomStatus { available, inGame, finalizing, locked }

/// Refers to the player score.
/// - pending, the player is still in game
/// - incomplete, the player left the game early
/// - complete, the player finished the game
enum ScoreStatus { pending, incomplete, complete }

/// Used in [Tutorials] widget
enum TutorialType { dataTypesAndliterals, functions, conditionalsAndLoops, classesAndObjects, variables, operators, keywords }
