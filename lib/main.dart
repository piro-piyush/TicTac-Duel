import 'package:tictac_duel/lib.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final container = ProviderContainer();

  await container.read(audioProvider.notifier).initialize();

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
      title: GameConstants.appName,
      debugShowCheckedModeBanner: false,
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
