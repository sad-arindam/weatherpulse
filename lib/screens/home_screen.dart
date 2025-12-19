import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../widgets/forecast_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String city = '';

  @override
  void initState() {
    super.initState();
    // Load last searched city
    ref.read(lastCityProvider.future).then((value) {
      if (value != null) {
        setState(() {
          city = value;
          _controller.text = value;
        });
      }
    });
  }

  void searchCity() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        city = _controller.text;
      });
      saveLastCity(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = city.isEmpty
        ? ref.watch(locationWeatherProvider)
        : ref.watch(weatherProvider(city));

    final forecastAsync =
        city.isEmpty ? null : ref.watch(forecastProvider(city));

    return Scaffold(
      appBar: AppBar(title: const Text('WeatherPulse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter city',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchCity,
                ),
              ],
            ),
            const SizedBox(height: 16),
            weatherAsync.when(
              data: (weather) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(weather.city,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      Image.network(
                        'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                      ),
                      Text('${weather.temperature}°C',
                          style: const TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600)),
                      Text(weather.description, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: ${e.toString()}'),
            ),
            const SizedBox(height: 20),
            if (forecastAsync != null)
              forecastAsync.when(
                data: (forecast) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('5-Day Forecast',
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ForecastList(forecasts: forecast),
                  ],
                ),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error loading forecast'),
              ),
          ],
        ),
      ),
    );
  }
}
