class WeatherData {
  final String description;
  final double temperature;
  final double humidity;
  final int timezone;
  final String city;
  final String country;

  WeatherData(
      {required this.description,
      required this.temperature,
      required this.city,
      required this.country,
      required this.humidity,
      required this.timezone,
      });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      city: json['name'],
      timezone: json['timezone'].toInt(),
      country: json['sys']['country'],
    );
  }
}
