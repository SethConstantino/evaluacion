import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testambient/screens/model.dart';
import 'package:testambient/screens/service.dart';
import 'package:wear/wear.dart';

class WeatherWidget extends StatefulWidget {
  final WeatherService weatherService;
  final WearMode mode;

  const WeatherWidget(this.mode, {required this.weatherService});

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  late WeatherData _weatherData;
  late String _hourString;
  late String _minuteString;

  @override
  void initState() {
    super.initState();
    _weatherData = WeatherData(
      cityName: '',
      temperature: 0,
      description: '',
      iconUrl: '',
    );
    _getTime();
    _getWeather();
  }

  void _getTime() {
    final now = DateTime.now();
    final hourFormatter =
        DateFormat('HH'); // Utilizar 'HH' para el formato de 24 horas
    final minuteFormatter = DateFormat('mm');
    _hourString = hourFormatter.format(now);
    _minuteString = minuteFormatter.format(now);
    Timer.periodic(Duration(minutes: 1), (timer) {
      final now = DateTime.now();
      final hourFormatter = DateFormat('HH');
      final minuteFormatter = DateFormat('mm');
      setState(() {
        _hourString = hourFormatter.format(now);
        _minuteString = minuteFormatter.format(now);
      });
    });
  }

  Future<void> _getWeather() async {
    try {
      final weatherData =
          await widget.weatherService.getWeather('San Juan del Rio');
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active
          ? Color.fromARGB(220, 9, 203, 221)
          : Color.fromARGB(255, 71, 71, 71),
      body: widget.mode == WearMode.active
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM').format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _hourString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: ':',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: _minuteString,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 3),
                      Text(
                        '${_weatherData.temperature} °C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          : Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM').format(DateTime.now()),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _hourString,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 60,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: ':',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 55,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: _minuteString,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
