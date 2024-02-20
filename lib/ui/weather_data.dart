class WeatherData {
  final String description;
  final double temperature;

  WeatherData({required this.description, required this.temperature});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}