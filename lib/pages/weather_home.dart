import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/helper_function.dart';
import 'package:weather_app/providers/weather_provider.dart';

import '../constants.dart';

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
          print('$latitude $longitude');
        _provider.setNewLatLng(latitude, longitude);


     });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(title: Text('Weather App'),
      elevation: 0,
      backgroundColor: Colors.blueAccent,
      actions: [
       IconButton(
           onPressed: (){},
           icon: Icon(Icons.my_location)),
        IconButton(
            onPressed: (){},
            icon: Icon(Icons.search)) ,
        IconButton(
            onPressed: (){},
            icon: Icon(Icons.settings))


      ],
      ) ,

      body:_provider.hasDataLoaded ? ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _currentSection(),
          SizedBox(height: 35,),
          _forecastSection()
        ],

      ): Center(child: Text('Please Wait..',style:textDefaultStyle),),

    );
  }


  Widget _currentSection(){
    return Column(
      children: [
        Text(getFormattedDate(_provider.currentResponse!.dt!, 'MMM dd, yyyy hh:mm a'),style:textDateStyle ,),
        Text('${_provider.currentResponse!.name},${_provider.currentResponse!.sys!.country}',style:textAddressStyle ,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.end ,
            children: [
              Text('${_provider.currentResponse!.main!.temp!.round()}\u00B0',style:textTempBig80Style ,),
              SizedBox(width: 10,),
              Text('max: ${_provider.currentResponse!.main!.tempMax!.round()}\u00B0/ min:${_provider.currentResponse!.main!.tempMin!.round()}\u00B0',style:textTempNormal16Style ,),

            ],
          ),
        ),
        Text('feels like: ${_provider.currentResponse!.main!.feelsLike!.round()}\u00B0',style:textTempNormal16Style ,),
        Image.network('$iconPrefix${_provider.currentResponse!.weather![0].icon}$iconSuffix',width: 80,height: 80,),
        Text(_provider.currentResponse!.weather![0].description!,style:textAddressStyle ,),
        //wrap widget ta onek ta row er motho
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
           children: [
             Text('humidity ',style: textDefaultStyleWhite54,),
             Text('${_provider.currentResponse!.main!.humidity }%',style: textDefaultStyleWhite54),
             Text(' pressure ',style: textDefaultStyleWhite54,),
             Text('${_provider.currentResponse!.main!.pressure } hPa',style: textDefaultStyleWhite54),
             Text(' speed ',style: textDefaultStyleWhite54,),
             Text('${_provider.currentResponse!.wind!.speed }m/s ',style: textDefaultStyleWhite54),
             Text(' visibility ',style: textDefaultStyleWhite54,),
             Text('${_provider.currentResponse!.visibility }km ',style: textDefaultStyleWhite54),

           ],
          ),
        )

      ],
    );
  }

  Widget _forecastSection() {
    return Container(
      padding: const EdgeInsets.all(8.0) ,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
         itemCount: _provider.forecastResponse!.list!.length,
         itemBuilder: (context,index){
          final item = _provider.forecastResponse!.list![index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
            child: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
                Text(getFormattedDate(item.dt!, 'EEE HH:mm'),style: textDateStyle,),
                Image.network('$iconPrefix${item.weather!.first.icon}$iconSuffix',width: 60,height: 60,),
                Text(item.weather![0].description!,style:textDefaultStyle,),
                Text('max: ${item.main!.tempMax!.round()}\u00B0/ min:${item.main!.tempMin!.round()}\u00B0',style:textTempNormal16Style ,),

              ],
            ),
          );
         },

      ),
    );
  }

}
