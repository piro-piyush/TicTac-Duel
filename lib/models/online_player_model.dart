import 'package:tictac_duel/lib.dart';

class OnlinePlayerModel extends PlayerModel {
  const OnlinePlayerModel({
    required super.id,
    required super.name,
    required super.symbol,
    this.points = 0,
    this.isReady = true,
  });

  final int points;
  final bool isReady;

  factory OnlinePlayerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return OnlinePlayerModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      symbol: PlayerSymbol.values.byName(
        json['symbol'],
      ),
      points: (json['points'] as num?)?.toInt() ?? 0,
      isReady: json['isReady'] as bool? ?? false,
    );
  }

  @override
  OnlinePlayerModel copyWith({
    String? id,
    String? name,
    PlayerSymbol? symbol,
    int? points,
    bool? isReady,
  }) {
    return OnlinePlayerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      points: points ?? this.points,
      isReady: isReady ?? this.isReady,
    );
  }
}