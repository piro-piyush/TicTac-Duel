
import 'package:tictac_duel/lib.dart';

class ResultModel {
const ResultModel._({
required this.host,
required this.guest,
required this.hostPoints,
required this.guestPoints,
required this.currentRound,
required this.maxRounds,
required this.isOnline,
required this.theme,
this.gameWinner,
this.hasWon = false,
this.isDraw = false,
this.showConfetti = false,
this.dismissReason,
});

const ResultModel.completed({
required PlayerModel host,
required PlayerModel guest,
required int hostPoints,
required int guestPoints,
required int currentRound,
required int maxRounds,
required bool isOnline,
required RoomTheme theme,
PlayerModel? gameWinner,
bool hasWon = false,
bool isDraw = false,
bool showConfetti = false,
}) : this._(
host: host,
guest: guest,
hostPoints: hostPoints,
guestPoints: guestPoints,
currentRound: currentRound,
maxRounds: maxRounds,
isOnline: isOnline,
gameWinner: gameWinner,
hasWon: hasWon,
isDraw: isDraw,
showConfetti: showConfetti,
theme: theme,
);

const ResultModel.dismissed({
required PlayerModel host,
required PlayerModel guest,
required int hostPoints,
required int guestPoints,
required int currentRound,
required int maxRounds,
required bool isOnline,
required RoomTheme theme,
required PlayerModel gameWinner,
required GameDismissReason dismissReason,
}) : this._(
host: host,
guest: guest,
hostPoints: hostPoints,
guestPoints: guestPoints,
currentRound: currentRound,
maxRounds: maxRounds,
isOnline: isOnline,
gameWinner: gameWinner,
hasWon: true,
dismissReason: dismissReason,
theme: theme,
);

final PlayerModel host;
final PlayerModel guest;

final int hostPoints;
final int guestPoints;

final int currentRound;
final int maxRounds;

final PlayerModel? gameWinner;
final RoomTheme theme;

final bool hasWon;
final bool isDraw;
final bool showConfetti;

final bool isOnline;

final GameDismissReason? dismissReason;

bool get isLocal => !isOnline;

bool get isDismissed => dismissReason != null;

bool get isCompleted => dismissReason == null;

ResultModel copyWith({
PlayerModel? host,
PlayerModel? guest,
int? hostPoints,
int? guestPoints,
int? currentRound,
int? maxRounds,
PlayerModel? gameWinner,
bool? hasWon,
bool? isDraw,
bool? showConfetti,
bool? isOnline,
GameDismissReason? dismissReason,
RoomTheme? theme,
}) {
return ResultModel._(
host: host ?? this.host,
guest: guest ?? this.guest,
hostPoints: hostPoints ?? this.hostPoints,
guestPoints: guestPoints ?? this.guestPoints,
currentRound: currentRound ?? this.currentRound,
maxRounds: maxRounds ?? this.maxRounds,
isOnline: isOnline ?? this.isOnline,
gameWinner: gameWinner ?? this.gameWinner,
hasWon: hasWon ?? this.hasWon,
isDraw: isDraw ?? this.isDraw,
showConfetti: showConfetti ?? this.showConfetti,
dismissReason: dismissReason ?? this.dismissReason,
theme: theme ?? this.theme,
);
}

@override
String toString() {
return 'ResultModel('
'host: ${host.id} (${host.name}), '
'guest: ${guest.id} (${guest.name}), '
'hostPoints: $hostPoints, '
'guestPoints: $guestPoints, '
'currentRound: $currentRound, '
'maxRounds: $maxRounds, '
'gameWinner: ${gameWinner?.id} (${gameWinner?.name}), '
'hasWon: $hasWon, '
'isDraw: $isDraw, '
'showConfetti: $showConfetti, '
'isOnline: $isOnline, '
'dismissReason: $dismissReason, '
'theme: $theme'
')';
}
}
