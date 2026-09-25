import 'package:tictac_duel/lib.dart';

late final MusicService musicService;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _initCore();

  runApp(const MyApp());
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<RoomDataProvider>(
              create: (_) => RoomDataProvider(),
            ),
            ChangeNotifierProvider<MusicProvider>(
              create: (_) => MusicProvider(musicService),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Tic Tac Duel',
            theme: Themes.darkTheme,
            routerConfig: Routes.router,
            builder: (context, child) {
              return Listener(
                onPointerDown: (_) {
                  context.read<MusicProvider>().playTouch();
                },
                child: child!,
              );
            },
          ),
        );
      },
    );
  }
}
