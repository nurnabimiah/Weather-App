
import 'package:flutter/material.dart';

class WeatherProvider with ChangeNotifier{

  double latitude = 0.0;
  double longitude = 0.0;

  void setNewLatLng( double lat, double lng){
    latitude = lat;
    longitude = lng;
    _getData();
  }

  void _getData() {

  }


}