import 'package:tictac_duel/lib.dart';

class PlayerApiService {
  PlayerApiService({required this._httpService});

  final HttpService _httpService;

  // ===========================================================================
  // CREATE PLAYER
  // ===========================================================================

  Future<PlayerModel> create() async {
    final data = await _httpService.post<Map<String, dynamic>>('/players');

    return PlayerModel.fromJson(data);
  }

  // ===========================================================================
  // GET PLAYER
  // ===========================================================================

  Future<PlayerModel> get(String playerId) async {
    final data = await _httpService.get<Map<String, dynamic>>(
      '/players/$playerId',
    );

    return PlayerModel.fromJson(data);
  }
}
