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

enum BtnType {
  normal,
  green,
  red,
}

enum CodeBlockState { selected, unselected, faded }

/// Used to define a block type in [Game] widget.
enum CodeBlockType {
  literals,
  conditionals,
  loops,
  functions,
  functionDefinition,
  classes,
  objects,
  keyword,
  variables,
  operators
}

enum FirestoreCollections {
  admins,
  users,
  rooms,
  reports,
  leaderboards,
  scores,
  settings,
  notifications,
  challenges,
  feedback
}

/// Similar to [ScoreStatus]
enum LeaderboardStatus { pending, incomplete, complete }

enum LoadingType { full, normal }

enum NotifType { info, warning, error, success }

/// - ongoing, self explanatory
/// - incomplete, when one of the following occurs:
///   - all players left the room
///   - admin or host user terminated the room
/// - complete, the game finished with no errors
enum RoomStatus { available, inGame, finalizing }

/// Refers to the player score.
/// - pending, the player is still in game
/// - incomplete, the player left the game early
/// - complete, the player finished the game
enum ScoreStatus { pending, incomplete, complete }

/// Used in [Tutorials] widget
enum TutorialType {
  dataTypesAndliterals,
  functions,
  conditionalsAndLoops,
  classesAndObjects,
  variables,
  operators,
  keywords
}
