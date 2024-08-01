enum AccountType { admin, user }

enum LoadingType { full, normal }

enum BtnType {
  normal,
  green,
  red,
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

enum CodeBlockState { selected, unselected, faded }

enum NotifType { success, error, warning, info }
