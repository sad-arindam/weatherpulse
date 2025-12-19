import 'package:flutter/material.dart';
import '../models/forecast.dart';

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;
  const ForecastList({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final f = forecasts[index];
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${f.date.day}/${f.date.month}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Image.network(
                    'https://openweathermap.org/img/wn/${f.icon}@2x.png',
                    width: 50,
                  ),
                  Text('${f.temperature}°C'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
