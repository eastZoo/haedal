import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haedal/models/album.dart';
import 'package:haedal/styles/colors.dart';
import '../../service/endpoints.dart';
import 'package:haedal/styles/colors.dart';

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

  final ScrollController _scrollController = ScrollController();
  double position = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Add a listener to the ScrollController
    _scrollController.addListener(_scrollListener);
  }

  // Dispose of the ScrollController when the widget is disposed
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll listener callback
  void _scrollListener() {
    // Access the scroll position using _scrollController.position.pixels
    double scrollPosition = _scrollController.position.pixels;
    setState(() {
      position = scrollPosition;
    });
    print('Scroll Position: $scrollPosition');
  }

  @override
  Widget build(BuildContext context) {
    print("albunm!!!! : $albumBoard");

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: true,
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(
              background: _thumbPhoto(),
            ),
            actions: [_addBtn(position)],
            leading: BackButton(
              color: position < 150 ? Colors.white : AppColors().mainColor,
            ),
            title: position < 150
                ? null
                : AnimatedBuilder(
                    animation: _scrollController,
                    builder: (BuildContext context, Widget? child) {
                      double offset = _scrollController.hasClients
                          ? _scrollController.offset
                          : _scrollController.initialScrollOffset;

                      // Calculate the title position based on the scroll offset
                      double titlePosition = 100.0 - (offset - 200);

                      return Container(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Transform.translate(
                          offset: Offset(0, titlePosition),
                          child: Text(
                            'Scrolling Title',
                            style: TextStyle(
                                fontSize: 17, color: AppColors().mainColor),
                          ),
                        ),
                      );
                    },
                  ),
            centerTitle: true,
            pinned: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            children: [
              _thumbPhoto(),
              _thumbPhoto(),
              _thumbPhoto(),
              _thumbPhoto(),
              _thumbPhoto(),
              _thumbPhoto(),
              _thumbPhoto(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addBtn(double position) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: GestureDetector(
        child: Icon(
          Icons.add,
          size: 25,
          color: position < 150 ? Colors.white : AppColors().mainColor,
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
            child: Text(
              "${albumBoard.title}",
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
    ));
  }
}
