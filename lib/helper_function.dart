
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getFormattedDate(num date,  String pattern){
  return DateFormat(pattern).format(DateTime.fromMicrosecondsSinceEpoch(date.toInt()* 1000));
}

Future<Position> determinePosition() async {

  bool serviceEnabled;
  LocationPermission permission;


  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {

    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {

      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {

    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }



  return await Geolocator.getCurrentPosition();
}


Future<bool> isConnectedToInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi;
}


Future<bool> setTempStatus(bool status) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.setBool('status', status);
}


Future<bool> getTempStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('status') ?? false;
}



/*
* if we need to live location we have to use getCurrentPositin Stream Method ta
* k use korte hobe*/