import 'package:tictac_duel/lib.dart';

class PlayerModel {
  const PlayerModel({
    required this.name,
    required this.symbol,
    required this.socketId,
    required this.points,
    required this.isReady,
  });

  final String name;
  final PlayerSymbol symbol;
  final String socketId;
  final int points;
  final bool isReady;

  /// Creates a PlayerModel from JSON received from the backend.
  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    try {
      return PlayerModel(
        name: json['name'] as String? ?? '',
        symbol: PlayerSymbol.fromValue(json['symbol'] as String? ?? ''),
        socketId: json['socketId'] as String? ?? '',
        points: (json['points'] as num?)?.toInt() ?? 0,
        isReady: json['isReady'] as bool? ?? false,
      );
    } catch (e) {
      rethrow;
    }
  }

  String get imageUrl =>
      'https://api.dicebear.com/10.x/pixelbot/svg?seed=$socketId';
}
