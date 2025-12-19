import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  final String _apiKey = 'd505c45f07689ab94a712d54da2f686f';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('City not found');
    }
  }

  Future<Weather> fetchWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Unable to fetch location weather');
    }
  }

  Future<List<Forecast>> fetch5DayForecast(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data['list'];
      final daily = list.where((item) => item['dt_txt'].contains('12:00:00')).toList();
      return daily.map((e) => Forecast.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
