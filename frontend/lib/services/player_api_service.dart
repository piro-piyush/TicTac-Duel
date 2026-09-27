import 'package:tictac_duel/lib.dart';

class PlayerApiService {
  PlayerApiService({required this._httpService});

  final HttpService _httpService;

  // ===========================================================================
  // INITIALIZE PLAYER
  // ===========================================================================

  Future<bool> initialize(String id) async {
    await _httpService.post<Map<String, dynamic>>(
      '/players/initialize',
      data: {'id': id},
    );

    return true;
  }
}
