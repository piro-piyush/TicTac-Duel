import 'package:tictac_duel/lib.dart';

abstract final class AppPages {
  AppPages._();

  // ===========================================================================
  // NAVIGATOR KEYS
  // ===========================================================================

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
}
