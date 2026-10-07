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

enum RoomStatus {
  waiting,
  playing,
  result,
  finished
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