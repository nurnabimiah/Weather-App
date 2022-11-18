
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/models/current_response.dart';
import 'package:weather_app/models/forecast_response.dart';

class WeatherProvider with ChangeNotifier{

  double latitude = 0.0;
  double longitude = 0.0;



  CurrentResponse? currentResponse;
  ForecastResponse? forecastResponse;

  void setNewLatLng( double lat, double lng){
    latitude = lat;
    longitude = lng;
    _getData();
  }

  bool get hasDataLoaded => currentResponse!=null && forecastResponse !=null;

  void _getData() {
    _getCurrentData();
    _getForecastData();
  }

  void _getCurrentData() async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=23.7531839&lon=90.3853621&units=metric&appid=77368b8de2277ccb2be3b5d98c30d82b';
    try{
      final respone = await get(Uri.parse(url));
      if(respone.statusCode ==200){
        final map = json.decode(respone.body);
        currentResponse = CurrentResponse.fromJson(map);
        print("current response : ${currentResponse!.main!.temp}");
        notifyListeners();
      }

    }catch(error){
      print(error.toString());
      throw error;
    }

  }

  void _getForecastData() async {

    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$weatherApikey';
      try{
       final respone = await get(Uri.parse(url));
       if(respone.statusCode ==200){
         final map = json.decode(respone.body);
         forecastResponse = ForecastResponse.fromJson(map);
         print("forecast:  ${forecastResponse!.list!.length}");
         notifyListeners();
       }

      }catch(error){
        print(error.toString());
        throw error;
      }
    }



}