




import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/pages/weather_home.dart';

class SplashScreen extends StatefulWidget {
  static final String routeName = "/splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {


  bool selected = false;

  startTimer() {
    Timer(const Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WeatherHome())
        // context, MaterialPageRoute(builder: (context) => UserHomeScreen())
      );
    });
  }


  Future startAnimation() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      selected = true;

    });
  }


  @override
  void initState() {
    super.initState();
    startAnimation().then((value) => startTimer());

  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   startTimer();
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Stack(
          children: [
            AnimatedPositioned(
              curve: Curves.linear,

              top: selected?200:400,
              left: selected?71:18,
              width: selected ? 217 : 323,
              height: selected ? 217 : 323,

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Ink(child: Center(child: Lottie.asset('images/weather.json',height: 150))),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text('Weather App',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blue),),
                    ),

                  ],
                ),
              ),
              duration: const Duration(seconds: 1),
            )
          ],
        )
    );

  }
}
