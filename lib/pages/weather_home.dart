import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/settings_page.dart';

import '../constants.dart';
import '../helper_function.dart';
import '../providers/weather_provider.dart';

class WeatherHome extends StatefulWidget {
  static const String routeName = '/';

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherProvider _provider;
  bool _isInit = true;
  late StreamSubscription<ConnectivityResult> subscription;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _provider = Provider.of<WeatherProvider>(context);
      isConnectedToInternet().then((value) {
        if (value) {
          _getPosition();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('No internet available')),
          );
        }
      });
      subscription = Connectivity().onConnectivityChanged.listen(
            (ConnectivityResult result) {
          print('listening...');
          if (result == ConnectivityResult.mobile ||
              result == ConnectivityResult.wifi) {
            _getPosition();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('No internet available')),
            );
          }
        },
      );
      _isInit = false;
    }
  }

  _getPosition() {
    determinePosition().then((position) {
      setState(() {
        final latitude = position.latitude;
        final longitude = position.longitude;
        _provider.setNewLatLng(latitude, longitude);
      });
    });
  }

  Future<void> _refreshData() async {
    _getPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFF5130a7),
      appBar: AppBar(
        backgroundColor: Color(0XFF5130a7),
        elevation: 0,
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              _getPosition();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: _CitySearchDelegate(),
              );
              if (result != null) {
                _convertCityToLatLng(result);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.pushNamed(context, SettingsPage.routeName),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _provider.hasDataLoaded
            ? ListView(
          padding: const EdgeInsets.all(12),
          children: [
            _currentSection(),
            SizedBox(
              height: 30,
            ),
            _forecastSection(),
          ],
        )
            : Center(
          child: const Text(
            'Please wait..',
            style: txtDefaultStyle,
          ),
        ),
      ),
    );
  }

  Widget _currentSection() {
    return Column(
      children: [
        Text(
          getFormattedDate(
              _provider.currentResponse!.dt!, 'MMM dd, yyyy hh:mm a'),
          style: txtDateStyle,
        ),
        Text(
          '${_provider.currentResponse!.name}, ${_provider.currentResponse!.sys!.country}',
          style: txtAddressStyle,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Row(
            textBaseline: TextBaseline.ideographic,
            //crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_provider.currentResponse!.main!.temp!.round()}\u00B0',
                style: txtTempBig80Style,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${_provider.currentResponse!.main!.tempMax!.round()}/${_provider.currentResponse!.main!.tempMin!.round()}\u00B0',
                style: txtTempNormal16Style,
              ),
            ],
          ),
        ),
        Text(
          'feels like ${_provider.currentResponse!.main!.feelsLike!.round()}\u00B0',
          style: txtTempNormal16Style,
        ),
        Image.network(


          '$iconPrefix${_provider.currentResponse!.weather!.first.icon}$iconSuffix',
          color: Colors.white,
          width: 80,
          height: 80,
        ),
        Text(
          _provider.currentResponse!.weather!.first.description!,
          style: txtAddressStyle,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Text(
                'humidity ',
                style: txtDefaultStyleWhite54,
              ),
              Text(
                '${_provider.currentResponse!.main!.humidity}%',
                style: txtDefaultStyle,
              ),
              Text(
                ' pressure ',
                style: txtDefaultStyleWhite54,
              ),
              Text(
                '${_provider.currentResponse!.main!.pressure}hPa',
                style: txtDefaultStyle,
              ),
              Text(
                ' speed ',
                style: txtDefaultStyleWhite54,
              ),
              Text(
                '${_provider.currentResponse!.wind!.speed}m/s',
                style: txtDefaultStyle,
              ),
              Text(
                ' visibility ',
                style: txtDefaultStyleWhite54,
              ),
              Text(
                '${_provider.currentResponse!.visibility}km',
                style: txtDefaultStyle,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _forecastSection() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _provider.forecastResponse!.list!.length,
        itemBuilder: (context, index) {
          final item = _provider.forecastResponse!.list![index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  getFormattedDate(item.dt!, 'EEE HH:mm'),
                  style: txtDateStyle,
                ),
                Image.network(
                  '$iconPrefix${item.weather!.first.icon}$iconSuffix',
                  width: 40,
                  height: 40,
                ),
                Text(
                  item.weather!.first.description!,
                  style: txtDefaultStyle,
                ),
                Text(
                  '${item.main!.tempMax!.round()}/${item.main!.tempMin!.round()}\u00B0',
                  style: txtTempNormal16Style,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _convertCityToLatLng(String result) async {
    try {
      final locationList = await locationFromAddress(result);
      if (locationList.isNotEmpty) {
        final location = locationList.first;
        _provider.setNewLatLng(location.latitude, location.longitude);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Invalid city')),
      );
      throw error;
    }
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, query);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(query),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> filteredList = query.isEmpty
        ? cities
        : cities
        .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView(
      children: filteredList
          .map(
            (city) => ListTile(
          onTap: () {
            close(context, city);
          },
          title: Text(city),
        ),
      )
          .toList(),
    );
  }
}
