import 'package:tictac_duel/lib.dart';

class RoomState extends Equatable {
  const RoomState({
    this.room,
    this.board = const [],
    this.winningIndexes = const {},
  });

  final RoomModel? room;
  final List<PlayerSymbol?> board;
  final Set<int> winningIndexes;

  bool get hasRoom => room != null;

  RoomState copyWith({
    RoomModel? room,
    List<PlayerSymbol?>? board,
    Set<int>? winningIndexes,
    bool clearRoom = false,
  }) {
    return RoomState(
      room: clearRoom ? null : room ?? this.room,
      board: board ?? this.board,
      winningIndexes: winningIndexes ?? this.winningIndexes,
    );
  }

  @override
  List<Object?> get props => [room, board, winningIndexes];
}
