import 'dart:async';
import 'package:demo_api/ui/weather_data.dart';
import 'package:dio/dio.dart';

class WeatherBloc {
  final _weatherDataController = StreamController<WeatherData>();

  Stream<WeatherData> get weatherData => _weatherDataController.stream;

  void dispose() {
    _weatherDataController.close();
  }

  Future<void> fetchWeather(double latitude, double longitude) async {
    const apiKey = 'a968cecd48d346cb978c318001b46781';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    try {
      final response = await Dio().get(apiUrl);

      if (response.statusCode == 200) {
        final weatherData = WeatherData.fromJson(response.data);
        _weatherDataController.add(weatherData);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioError catch (e) {
      String errorMessage = 'Failed to load weather data';
      if (e.response != null) {
        errorMessage += ': ${e.response!.statusCode}';
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('Failed to load weather data: $e');
    }
  }
}
