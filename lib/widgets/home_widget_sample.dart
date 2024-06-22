import 'package:flutter/material.dart';

Widget home_widget_sample(int index) {
  switch (index) {
    case 0:
      return const Text(
        'Add Item 1',
        style: TextStyle(color: Colors.white),
      );
    case 1:
      return const Text(
        'Add Item 2',
        style: TextStyle(color: Colors.white),
      );
    case 2:
      return const Text(
        'Add Item 3',
        style: TextStyle(color: Colors.white),
      );
    case 3:
      return const Text(
        'Add Item 4',
        style: TextStyle(color: Colors.white),
      );
    case 4:
      return const Text(
        'Add Item 5',
        style: TextStyle(color: Colors.white),
      );
    case 5:
      return const Text(
        'Add Item 6',
        style: TextStyle(color: Colors.white),
      );
    default:
      return Text(
        'Add Item ${index + 1}',
        style: const TextStyle(color: Colors.white),
      );
  }
}
