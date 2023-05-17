import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../helper_function.dart';
import '../providers/weather_provider.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings';
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isChecked = false;

  @override
  void initState() {
    getTempStatus().then((value) {
      setState((){
        _isChecked = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF5130a7),
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
        backgroundColor: Color(0XFF5130a7),
      ),
      body: ListView(
        children: [
          Consumer<WeatherProvider>(
            builder: (context, provider, _) => SwitchListTile(
                activeColor: Colors.amber,
                title: const Text('Show temperature in Fahrenheit'),
                subtitle: const Text('Default is Celsius'),
                value: _isChecked,
                onChanged: (value) async {
                  setState(() {
                    _isChecked = value;
                  });
                  await setTempStatus(value);
                  provider.reload();
                }
            ),
          )
        ],
      ),
    );
  }
}
