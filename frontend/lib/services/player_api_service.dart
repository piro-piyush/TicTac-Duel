import 'package:tictac_duel/lib.dart';

class PlayerApiService {
  PlayerApiService({required this._httpService});

  final HttpService _httpService;

  // ===========================================================================
  // CREATE PLAYER
  // ===========================================================================

  Future<LocalUserModel> create() async {
    final data = await _httpService.post<Map<String, dynamic>>('/players');

    return LocalUserModel(
      id: data['id'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }

  // ===========================================================================
  // GET PLAYER
  // ===========================================================================

  Future<LocalUserModel> get(String playerId) async {
    final data = await _httpService.get<Map<String, dynamic>>(
      '/players/$playerId',
    );

    return LocalUserModel(
      id: data['id'] as String,
      createdAt: DateTime.parse(data['createdAt'] as String),
    );
  }
}
