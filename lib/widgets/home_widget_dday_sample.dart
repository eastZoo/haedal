import 'package:flutter/material.dart';

Widget home_widget_dday_sample(int index) {
  switch (index) {
    case 0:
      return const Text(
        '준비중',
        style: TextStyle(color: Colors.white),
      );
    case 1:
      return const Text(
        'D- day 1',
        style: TextStyle(color: Colors.white),
      );
    case 2:
      return const Text(
        'D- day 2',
        style: TextStyle(color: Colors.white),
      );
    case 3:
      return const Text(
        'D- day 3',
        style: TextStyle(color: Colors.white),
      );
    case 4:
      return const Text(
        'D- day 4',
        style: TextStyle(color: Colors.white),
      );
    case 5:
      return const Text(
        'D- day 5',
        style: TextStyle(color: Colors.white),
      );
    default:
      return Text(
        'D- day ${index + 1}',
        style: const TextStyle(color: Colors.white),
      );
  }
}
