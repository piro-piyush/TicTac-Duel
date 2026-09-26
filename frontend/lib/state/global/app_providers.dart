import 'package:tictac_duel/lib.dart';

final appThemeProvider = Provider<ThemeMode>((ref) {
  return ThemeMode.dark;
});

final appVersionProvider = Provider<String>((ref) {
  return GameConstants.appVersion;
});
