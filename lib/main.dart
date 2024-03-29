

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/pages/splash_screen.dart';
import 'package:weather_app/pages/weather_home.dart';
import 'package:weather_app/providers/weather_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => WeatherProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Merriweathersans',
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        WeatherHome.routeName:(context) => WeatherHome(),
        SettingsPage.routeName:(context) => SettingsPage(),
        SplashScreen.routeName:(context) => SplashScreen(),
      },
    );
  }
}



