import 'package:tictac_duel/lib.dart';

class PlayerApiService {
  PlayerApiService({required this._httpService});

  final HttpService _httpService;

  // ===========================================================================
  // INITIALIZE PLAYER
  // ===========================================================================

  Future<bool> initialize(String playerId) async {
    await _httpService.post<Map<String, dynamic>>(
      '/players/initialize',
      data: {'playerId': playerId},
    );

    return true;
  }
}
