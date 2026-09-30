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

  String get avatarAsset {
    final hash = id.codeUnits.fold<int>(
      0,
          (value, codeUnit) => value + codeUnit,
    );

    return AvatarConstants.all[hash % AvatarConstants.all.length];
  }

  PlayerModel copyWith({
    String? id,
    String? name,
    PlayerSymbol? symbol,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
    );
  }
}