import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CurrentWeatherPage(),
    );
  }
}

class Weather {
  final double temp;
  final double feelsLike;
  final double low;
  final double high;
  final String description;

  Weather({
    required this.temp,
    required this.feelsLike,
    required this.low,
    required this.high,
    required this.description,
  });

  factory Weather.fromJson(
      Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'].toDouble(),
      feelsLike:
          json['main']['feels_like'].toDouble(),
      low:
          json['main']['temp_min'].toDouble(),
      high:
          json['main']['temp_max'].toDouble(),
      description:
          json['weather'][0]['description'],
    );
  }
}

class CurrentWeatherPage
    extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage>
      createState() =>
          _CurrentWeatherPageState();
}

class _CurrentWeatherPageState
    extends State<CurrentWeatherPage> {

  Future<Weather?> getCurrentWeather()
  async {

    String city = "Mumbai";

    String apiKey =
        "3c97151c47f203334e308a7860ea8826";

    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final response =
        await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(
          jsonDecode(response.body));
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Weather App'),
        centerTitle: true,
      ),

      body: Center(
        child: FutureBuilder<Weather?>(
          future: getCurrentWeather(),

          builder:
              (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const
              CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text(
                  "Error loading weather");
            }

            if (!snapshot.hasData ||
                snapshot.data == null) {
              return const Text(
                  "No weather data found");
            }

            Weather weather =
                snapshot.data!;

            return weatherBox(weather);
          },
        ),
      ),
    );
  }
}

Widget weatherBox(
    Weather weather) {

  return Card(
    elevation: 5,
    margin:
        const EdgeInsets.all(20),

    child: Padding(
      padding:
          const EdgeInsets.all(20),

      child: Column(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          Text(
            "${weather.temp}°C",
            style:
                const TextStyle(
              fontSize: 35,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
              height: 10),

          Text(
            weather.description
                .toUpperCase(),

            style:
                const TextStyle(
              fontSize: 20,
            ),
          ),

          const SizedBox(
              height: 10),

          Text(
            "Feels Like: "
            "${weather.feelsLike}°C",
          ),

          Text(
            "High: "
            "${weather.high}°C"
            "   Low: "
            "${weather.low}°C",
          ),
        ],
      ),
    ),
  );
}