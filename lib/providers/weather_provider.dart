import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../utils/location_service.dart';

// Weather Service Provider
final weatherServiceProvider = Provider((ref) => WeatherService());
final locationServiceProvider = Provider((ref) => LocationService());

// Current weather by city
final weatherProvider = FutureProvider.family<Weather, String>((ref, city) {
  return ref.read(weatherServiceProvider).fetchWeather(city);
});

// Current weather by location
final locationWeatherProvider = FutureProvider<Weather>((ref) async {
  final loc = await ref.read(locationServiceProvider).getCurrentLocation();
  return ref.read(weatherServiceProvider).fetchWeatherByLocation(loc.latitude, loc.longitude);
});

// 5-Day Forecast by city
final forecastProvider = FutureProvider.family<List<Forecast>, String>((ref, city) {
  return ref.read(weatherServiceProvider).fetch5DayForecast(city);
});

// Last searched city persistence
final lastCityProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('last_city');
});

Future<void> saveLastCity(String city) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('last_city', city);
}
