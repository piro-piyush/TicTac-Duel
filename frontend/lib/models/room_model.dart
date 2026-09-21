import 'package:tictac_duel/lib.dart';

class RoomModel {
  const RoomModel({
    required this.id,
    required this.code,
    required this.theme,
    required this.mode,
    // required this.isPrivate,
    required this.host,
    this.guest,
  });

  final String id;
  final String code;
  final RoomTheme theme;
  final GameMode mode;
  // final bool isPrivate;
  final PlayerModel host;
  final PlayerModel? guest;
}

class PlayerModel {
  const PlayerModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  final String id;
  final String name;
  final PlayerSymbol symbol;
}