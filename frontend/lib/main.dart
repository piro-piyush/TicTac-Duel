import 'package:flutter/material.dart';
import 'package:tictac_duel/lib.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: Themes.darkTheme,
      routerConfig: Routes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
