import 'package:tictac_duel/lib.dart';

class RoomNotifier extends Notifier<RoomState> {
  @override
  RoomState build() {
    return const RoomState();
  }

  // ===========================================================================
  // ROOM
  // ===========================================================================

  void setRoom(RoomModel room) {
    state = RoomState(
      room: room,
      board: List<PlayerSymbol?>.filled(room.boardSize, null),
    );
  }

  void updateRoom(RoomModel room) {
    state = state.copyWith(room: room);
  }

  void clearRoom() {
    state = const RoomState();
  }

  // ===========================================================================
  // BOARD
  // ===========================================================================

  void setBoardValue(int index, PlayerSymbol symbol) {
    if (index < 0 || index >= state.board.length) {
      return;
    }

    if (state.board[index] != null) {
      return;
    }

    final board = List<PlayerSymbol?>.from(state.board);
    board[index] = symbol;

    state = state.copyWith(board: board);
  }

  PlayerSymbol? getBoardValue(int index) {
    if (index < 0 || index >= state.board.length) {
      return null;
    }

    return state.board[index];
  }

  void clearBoard() {
    final boardSize = state.room?.boardSize ?? 0;

    state = state.copyWith(
      board: List<PlayerSymbol?>.filled(boardSize, null),
      winningIndexes: {},
    );
  }

  // ===========================================================================
  // WINNING INDEXES
  // ===========================================================================

  void setWinningIndexes(Set<int> indexes) {
    state = state.copyWith(winningIndexes: Set<int>.from(indexes));
  }
}

// 👇 Put the provider HERE, outside the class.
final roomProvider = NotifierProvider<RoomNotifier, RoomState>(
  RoomNotifier.new,
);
