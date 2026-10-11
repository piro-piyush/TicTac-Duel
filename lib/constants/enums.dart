enum GameMode { classic, blitz }

enum GameResult { xWins, oWins, draw, inProgress }

enum LocalGameType { friend, computer }

enum CpuDifficulty { easy, medium, hard }

enum PlayerSymbol { x, o }

enum RoomTheme { classic, inferno, cyber }

enum RoomStatus { waiting, playing, result, finished }

enum GameDismissReason { opponentDisconnected, opponentQuit }

enum GameReaction {
  // Emotions
  laugh,
  angry,
  cool,
  cry,
  mindBlown,
  sick,
  sleepy,

  // Celebration
  fire,
  clap,
  confetti,

  // Competitive
  ez,
  oops,
  clown,

  // Friendly
  wave,

  // Gaming
  lightning,
  bomb,

  // Fun
  wink,
  tongue,
  poop,
  monkey,

  // Hearts
  heart,
  brokenHeart,
  kiss,
  rose,
  eyes,
}
