
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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
/*
* if we need to live location we have to use getCurrentPositin Stream Method ta
* k use korte hobe*/