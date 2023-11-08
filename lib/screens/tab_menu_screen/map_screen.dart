import 'package:flutter/material.dart';
import 'package:haedal/widgets/main_appbar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          MainAppbar(title: '지도'),
        ],
      ),
    );
  }
}
