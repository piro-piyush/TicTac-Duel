import 'package:tictac_duel/lib.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await _initCore();

  final preferences = await SharedPreferences.getInstance();

  Get.put<SharedPreferences>(preferences, permanent: true);

  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

// =============================================================================
// CORE INITIALIZATION
// =============================================================================

Future<void> _initCore() async {
  await dotenv.load();
  await LocalStorageUtils.init();
}

// =============================================================================
// APP
// =============================================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: GameConstants.appName,
      theme: AppTheme.darkTheme,
      initialBinding: GlobalBindings(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
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
