import 'package:tictac_duel/lib.dart';

class PlayerModel {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.socketId,
    required this.points,
    required this.isReady,
  });

  /// Persistent guest player ID.
  final String id;

  final String name;
  final PlayerSymbol symbol;

  /// Current Socket.IO connection ID.
  final String socketId;

  final int points;
  final bool isReady;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      symbol: PlayerSymbol.fromValue(
        json['symbol'] as String? ?? '',
      ),
      socketId: json['socketId'] as String? ?? '',
      points: (json['points'] as num?)?.toInt() ?? 0,
      isReady: json['isReady'] as bool? ?? false,
    );
  }

  /// Avatar is based on the persistent player ID so it remains
  /// the same even if the player reconnects with a new socket ID.
  String get imageUrl =>
      'https://api.dicebear.com/10.x/pixelbot/svg?seed=$id';
}