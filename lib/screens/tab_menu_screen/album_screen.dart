import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:haedal/widgets/main_appbar.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

// 게시글 카드
  Widget postCard(title) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
      height: 170,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/images/haeon.jpg",
          ),
          fit: BoxFit.cover,
        ),
        color: Colors.grey,
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.2),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black, // Choose the color of the shadow
                    blurRadius:
                        5.0, // Adjust the blur radius for the shadow effect
                    offset: Offset(1.0,
                        1.0), // Set the horizontal and vertical offset for the shadow
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          const MainAppbar(title: '스토리 / 위치리스트'),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [for (num i = 1; i < 6; i++) postCard("CHOCOLATE")],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
