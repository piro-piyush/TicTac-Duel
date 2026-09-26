import 'package:tictac_duel/lib.dart';

late final MusicService musicService;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _initCore();

  runApp(const ProviderScope(child: MyApp()));
}

// =============================================================================
// CORE INITIALIZATION
// =============================================================================

Future<void> _initCore() async {
  await dotenv.load();
  await LocalStorageUtils.init();

  musicService = MusicService(LocalStorageUtils.prefs);

  await musicService.init();

  FlutterNativeSplash.remove();
}

// =============================================================================
// APP
// =============================================================================

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: GameConstants.appName,
      theme: AppTheme.darkTheme,
      routerConfig: Routes.router,
      builder: (context, child) => Listener(
        onPointerDown: (_) => ref.read(musicProvider.notifier).playTouch(),
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
