import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tictac_duel/lib.dart' hide Provider;
import 'package:tictac_duel/main.dart';

final localStorageProvider = Provider<SharedPreferences>((ref) {
  return LocalStorageUtils.prefs;
});

final musicServiceProvider = Provider<MusicService>((ref) {
  return musicService;
});

final socketServiceProvider = Provider<SocketService>((ref) {
  return SocketService.instance;
});
