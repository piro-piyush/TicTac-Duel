// import 'package:tictac_duel/lib.dart';
//
// class RoomConnectedResponse {
//   const RoomConnectedResponse({
//     required this.room,
//     required this.playerOnePoints,
//     required this.playerTwoPoints,
//     required this.playerOneReady,
//     required this.playerTwoReady,
//     required this.turnPlayerId,
//     required this.turnIndex,
//   });
//
//   final RoomModel room;
//
//   final int playerOnePoints;
//   final int playerTwoPoints;
//
//   final bool playerOneReady;
//   final bool playerTwoReady;
//
//   final String? turnPlayerId;
//   final int turnIndex;
//
//   factory RoomConnectedResponse.fromJson(dynamic json) {
//     if (json is! Map) {
//       throw const FormatException('Invalid room connected response');
//     }
//
//     final playersData = json['players'];
//
//     if (playersData is! List) {
//       throw const FormatException('Invalid players data');
//     }
//
//     if (playersData.any((player) => player is! Map)) {
//       throw const FormatException('Invalid player data');
//     }
//
//     final playerOne = playersData.isNotEmpty
//         ? Map<String, dynamic>.from(playersData[0] as Map)
//         : null;
//
//     final playerTwo = playersData.length > 1
//         ? Map<String, dynamic>.from(playersData[1] as Map)
//         : null;
//
//     final playerOnePoints = playerOne?['points'] ?? 0;
//     final playerTwoPoints = playerTwo?['points'] ?? 0;
//
//     final playerOneReady = playerOne?['isReady'] ?? false;
//     final playerTwoReady = playerTwo?['isReady'] ?? false;
//
//     final turnPlayerId = json['turnPlayerId'];
//     final turnIndex = json['turnIndex'];
//
//     if (playerOnePoints is! int || playerTwoPoints is! int) {
//       throw const FormatException('Invalid player points');
//     }
//
//     if (playerOneReady is! bool || playerTwoReady is! bool) {
//       throw const FormatException('Invalid player ready status');
//     }
//
//     if (turnPlayerId != null && turnPlayerId is! String) {
//       throw const FormatException('Invalid turn player ID');
//     }
//
//     if (turnIndex is! int || turnIndex < 0) {
//       throw const FormatException('Invalid turn index');
//     }
//
//     return RoomConnectedResponse(
//       room: RoomModel.fromJson(
//         Map<String, dynamic>.from(json),
//       ),
//       playerOnePoints: playerOnePoints,
//       playerTwoPoints: playerTwoPoints,
//       playerOneReady: playerOneReady,
//       playerTwoReady: playerTwoReady,
//       turnPlayerId: turnPlayerId as String?,
//       turnIndex: turnIndex,
//     );
//   }
// }

// import 'package:tictac_duel/lib.dart';
//
// class RoomConnectedResponse {
//   const RoomConnectedResponse({required this.room});
//
//   final Room room;
//
//   factory RoomConnectedResponse.fromJson(dynamic json) {
//     try {
//       if (json is! Map) {
//         throw const FormatException('Invalid room created response');
//       }
//
//       final data = Map<String, dynamic>.from(json);
//
//       return RoomConnectedResponse(room: Room.fromJson(data));
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
