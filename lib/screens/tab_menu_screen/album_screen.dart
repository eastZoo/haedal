import 'dart:ui';

import 'package:flutter/material.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            bottom: 20, // Set the distance from the top
            right: 16,
            child: InkWell(
              onTap: () {
                print("addPOST@@");
              },
              borderRadius: BorderRadius.circular(100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.white.withOpacity(0.8),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
