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

  PlayerModel copyWith({String? id, String? name, PlayerSymbol? symbol}) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
    );
  }
}
