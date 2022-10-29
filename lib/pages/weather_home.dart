import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/helper_function.dart';
import 'package:weather_app/providers/weather_provider.dart';

class WeatherHome extends StatefulWidget {
  static const String routeName = '/';
  const WeatherHome({Key? key}) : super(key: key);

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {

  late WeatherProvider _provider;
  bool _isInit = true;


  @override
  void didChangeDependencies() {
    if(_isInit)
    {
      _provider = Provider.of<WeatherProvider>(context);
      _getPosition();
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  _getPosition(){
    determinePosition().then((position){
     setState((){
       final latitude = position.latitude;
       final longitude = position.longitude;
       //print('$latitude $longitude');
       _provider.setNewLatLng(latitude, longitude);


     });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(title: Text('Weather App'),
      actions: [

      ],
      ) ,

      body: ListView(
        padding: const EdgeInsets.all(12),
      ),

    );
  }
}
