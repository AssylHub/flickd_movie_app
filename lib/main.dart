import 'package:flickd_app/pages/main_screen.dart';
import 'package:flickd_app/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(SplashScreen(
    onInitializationComplete: () {
      return runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
    key: UniqueKey(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flickd",
        initialRoute: "home",
        routes: {
          "home": (context) => MainScreen(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
      ),
    );
  }
}
