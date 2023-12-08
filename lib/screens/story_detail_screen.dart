import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haedal/models/album.dart';
import 'package:haedal/styles/colors.dart';
import '../../service/endpoints.dart';

class StoryDetailScreen extends StatefulWidget {
  const StoryDetailScreen({super.key, this.albumBoard});
  final AlbumBoard? albumBoard;

  @override
  State<StoryDetailScreen> createState() =>
      _StoryDetailScreenState(albumBoard ?? AlbumBoard());
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  _StoryDetailScreenState(this.albumBoard);
  AlbumBoard albumBoard;

  @override
  Widget build(BuildContext context) {
    print("albunm!!!! : $albumBoard");
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(
          color: Colors.white,
        ),
        actions: [_addBtn()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _thumbPhoto(),
            _thumbPhoto(),
            _thumbPhoto(),
          ],
        ),
      ),
    );
  }

  Widget _addBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: GestureDetector(
        child: const Icon(
          Icons.add,
          size: 50,
          color: Colors.white,
        ),
        onTap: () async {},
      ),
    );
  }

  // 썸네일 이미지
  Widget _thumbPhoto() {
    double width = MediaQuery.of(context).size.width;
    return Container(
        child: Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
      height: width / 1.5,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            "${Endpoints.hostUrl}/${albumBoard.files?.first.filename}",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        // make sure we apply clip it properly
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            alignment: Alignment.center,
            color: Colors.grey.withOpacity(0.2),
            child: const Text(
              "title",
              style: TextStyle(
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
    ));
  }
}
