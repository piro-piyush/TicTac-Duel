import 'package:tictac_duel/lib.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  await dotenv.load();

  final container = ProviderContainer();
  await Future.wait([
    container.read(audioProvider.notifier).initialize(),
    // container.read(playerProvider.notifier).initialize(),
  ]);

  FlutterNativeSplash.remove();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
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
      routerConfig: ref.watch(appRouterProvider),
      scaffoldMessengerKey: AppPages.rootScaffoldMessengerKey,
      builder: (context, child) {
        return Listener(
          onPointerDown: (_) {
            ref.read(audioProvider.notifier).playTouch();
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
