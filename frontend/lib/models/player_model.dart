import 'package:tictac_duel/lib.dart';

class PlayerModel {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.symbol,
     this.points = 0,
     this.isReady = true,
  });

  /// Persistent guest player ID.
  final String id;

  final String name;
  final PlayerSymbol symbol;
  final int points;
  final bool isReady;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    try {
      return PlayerModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        symbol: PlayerSymbol.fromValue(json['symbol'] as String? ?? ''),
        points: (json['points'] as num?)?.toInt() ?? 0,
        isReady: json['isReady'] as bool? ?? false,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Avatar remains the same across socket reconnections.
  String get imageUrl => 'https://api.dicebear.com/10.x/pixelbot/svg?seed=$id';
}
