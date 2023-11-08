import 'package:flutter/material.dart';
import 'package:haedal/widgets/main_appbar.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          MainAppbar(title: '앨범'),
        ],
      ),
    );
  }
}
