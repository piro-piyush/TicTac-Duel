import 'package:tictac_duel/lib.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _initCore();
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

// =============================================================================
// CORE INITIALIZATION
// =============================================================================

Future<void> _initCore() async {
  await dotenv.load();

  GlobalBindings().dependencies();
}

// =============================================================================
// APP
// =============================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: GameConstants.appName,
      theme: AppTheme.darkTheme,
      routerConfig: AppPages.router,
      scaffoldMessengerKey: AppPages.rootScaffoldMessengerKey,

      builder: (context, child) {
        return Listener(
          onPointerDown: (_) {
            Get.find<MusicController>().playTouch();
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
