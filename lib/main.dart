import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:tictac_duel/lib.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await dotenv.load();
  final container = ProviderContainer();
  await container.read(audioProvider.notifier).initialize();
  container.read(appRouterProvider);
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));

}

// =============================================================================
// APP
// =============================================================================

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: GameConstants.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.darkTheme,
    routerConfig: ref.watch(appRouterProvider),
    scaffoldMessengerKey: AppPages.rootScaffoldMessengerKey,
    builder: (context, child) => Listener(
      onPointerDown: (_) => ref.read(audioProvider.notifier).playTouch(),
      child: child ?? const SizedBox.shrink(),
    ),
  );
}
