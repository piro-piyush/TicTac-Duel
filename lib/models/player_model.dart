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
        id: json['id'],
        name: json['name'],
        symbol: PlayerSymbol.values.byName(json['symbol']),
      );
    } catch (e) {
      rethrow;
    }
  }

  factory PlayerModel.fromSocket(dynamic data) {
    try {
      if (data is! Map) {
        throw const FormatException('Invalid player response');
      }

      final json = Map<String, dynamic>.from(data);

      final id = json['id'];
      final name = json['name'];
      final symbol = json['symbol'];

      if (id is! String || id.trim().isEmpty) {
        throw const FormatException('Invalid player ID');
      }

      if (name is! String || name.trim().isEmpty) {
        throw const FormatException('Invalid player name');
      }

      if (symbol is! String) {
        throw const FormatException('Invalid player symbol');
      }

      return PlayerModel(
        id: id,
        name: name,
        symbol: PlayerSymbol.values.byName(symbol),
      );
    } catch (e) {
      rethrow;
    }
  }
}
