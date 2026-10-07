import 'package:tictac_duel/lib.dart';

class PlayerModel {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  final String id;
  final String name;
  final PlayerSymbol symbol;

  String get imageUrl => 'https://api.dicebear.com/10.x/pixelbot/svg?seed=$id';

  PlayerModel copyWith({String? id, String? name, PlayerSymbol? symbol}) =>
      PlayerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
      );

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    try {
      return PlayerModel(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        symbol: PlayerSymbol.values.byName(json['symbol']),
      );
    } catch (e) {
      rethrow;
    }
  }

  factory PlayerModel.fromSocket(dynamic data) {
    final json = Map<String, dynamic>.from(data as Map);
    try {
      return PlayerModel(
        id: json['id'],
        name: json['name'],
        symbol: PlayerSymbol.values.byName(json['symbol']),
      );
    } catch (e) {
      rethrow;
    }
  }
}
