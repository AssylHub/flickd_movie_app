import 'dart:convert';
// Packages
import 'package:flickd_app/services/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/http_service.dart';

// Model
import '../model/app_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.onInitializationComplete,
  });

  final Function() onInitializationComplete;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 10)).then(
        (_) => _setup(context).then((_) => widget.onInitializationComplete()));
  }

  Future<void> _setup(BuildContext _context) async {
    final getIt = GetIt.instance;
    final configFile = await rootBundle.loadString("assets/config/main.json");
    final configData = jsonDecode(configFile);

    // final String url = configData["API_KEY"];

    getIt.registerSingleton<AppConfig>(
      AppConfig(
        BASE_API_URL: configData["BASE_API_URL"],
        API_KEY: configData["API_KEY"],
        BASE_IMAGE_API_URL: configData["BASE_IMAGE_API_URL"],
      ),
    );

    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );

    getIt.registerSingleton<MovieService>(
      MovieService(),
    );

    setState(() {
      // print(url);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flickd App",
      home: Center(
        child: FlutterLogo(
          size: 100,
          textColor: Colors.red,
        ),
        // child: Container(
        //   height: 200,
        //   width: 200,
        //   decoration: BoxDecoration(
        //       color: Colors.blue,

        //       // color: Colors.amber,
        //       image: DecorationImage(
        //           fit: BoxFit.cover,
        //           image: AssetImage("assets/images/logo.png"))),
        // ),
      ),
    );
  }
}
