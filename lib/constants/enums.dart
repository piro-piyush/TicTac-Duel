enum GameMode {
  classic,
  blitz,
}

enum GameResult {
  xWins,
  oWins,
  draw,
  inProgress,
}

enum LocalGameType {
  friend,
  computer,
}
enum RoomScreenType {
  create,
  join,
}
enum CpuDifficulty {
  easy,
  medium,
  hard,
}

enum PlayerSymbol {
  x,
  o,
}

enum RoomTheme {
  classic,
  inferno,
  cyber,
}

enum RoundStatus {
  waiting,
  playing,
  result,
}

enum GameDismissReason {
  opponentDisconnected,
  opponentQuit,
}enum GameReaction {
  laugh,
  love,
  angry,
  wow,
  fire,
  clap,
  party,
  cool,
}