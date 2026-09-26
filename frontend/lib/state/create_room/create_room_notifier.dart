// import 'package:tictac_duel/lib.dart';
//
// class CreateRoomNotifier extends Notifier<CreateRoomState> {
//   RoomSocketService get _roomSocket => ref.watch(roomSocketServiceProvider);
//
//   @override
//   CreateRoomState build() {
//     _roomSocket.onRoomCreated(_handleRoomCreated);
//     _roomSocket.onRoomError(_handleRoomError);
//     return const CreateRoomState();
//   }
//
//   void createRoom({
//     required String playerName,
//     required PlayerSymbol symbol,
//     required RoomTheme theme,
//     required int maxRounds,
//   }) {
//     state = state.copyWith(isCreating: true, clearError: true);
//
//     try {
//       _roomSocket.createRoom(
//         playerName: playerName,
//         symbol: symbol,
//         theme: theme,
//         maxRounds: maxRounds,
//       );
//     } catch (error) {
//       _handleRoomError(error.toString());
//     }
//   }
//
//   void _handleRoomCreated(RoomModel room) {
//     state = state.copyWith(isCreating: false);
//
//     ref.read(musicProvider.notifier).lightVibration();
//     ref.read(roomProvider.notifier).setRoom(room);
//
//     Routes.replaceToGame();
//   }
//
//   void _handleRoomError(String message) {
//     state = state.copyWith(isCreating: false, errorMessage: message);
//
//     ref.read(musicProvider.notifier).mediumVibration();
//   }
//
//   void clearError() {
//     state = state.copyWith(clearError: true);
//   }
// }
//
// final createRoomProvider =
//     NotifierProvider<CreateRoomNotifier, CreateRoomState>(
//       CreateRoomNotifier.new,
//     );
