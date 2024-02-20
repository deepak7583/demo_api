import 'dart:async';
import 'package:demo_api/ui/weather_block.dart';
import 'package:demo_api/ui/weather_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  late WeatherBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WeatherBloc();
    _getLocationAndWeather();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Future<void> _getLocationAndWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint('Location:----: ${position.latitude}, ${position.longitude}');
      await _bloc.fetchWeather(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('ERROR:----: Failed to get location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StreamBuilder<WeatherData>(
      stream: _bloc.weatherData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          final weatherData = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${weatherData.temperature}°C',
                  style: const TextStyle(fontSize: 50, color: Colors.white,fontWeight: FontWeight.bold),
                ),
                Text('Current temprature', style: const TextStyle(fontSize: 15, color: Colors.white),),
                const SizedBox(height: 10),
                Text(
                  weatherData.description.toUpperCase(),
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white10,
      title: const Text(
        'Weather',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
