import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:haedal/models/album.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../service/endpoints.dart';

class PhotoViewScreen extends StatefulWidget {
  final AlbumBoard? albumBoard;
  int currentIndex;
  PhotoViewScreen(
      {super.key, required this.albumBoard, required this.currentIndex});

  @override
  State<PhotoViewScreen> createState() =>
      _PhotoViewScreenState(albumBoard, currentIndex);
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  _PhotoViewScreenState(this.albumBoard, this.currentIndex);
  int currentIndex = 0;
  AlbumBoard? albumBoard;
  bool _isDownloading = false;

  late PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void downloadImage(imageUrl) async {
    setState(() {
      _isDownloading = true;
    });

    // var response = await Dio()
    //     .get(imageUrl, options: Options(responseType: ResponseType.bytes));

    // final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));

    // if (result["isSuccess"]) {
    //   print("다운로드가 완료되었습니다.");
    // } else {
    //   print("다운로드에 오류가 발생했습니다.");
    // }

    setState(() {
      _isDownloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          PhotoViewGallery.builder(
            pageController: _controller,
            itemCount: albumBoard?.files?.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                maxScale: PhotoViewComputedScale.covered * 3,
                minScale: PhotoViewComputedScale.contained,
                imageProvider: CachedNetworkImageProvider(
                  "${Endpoints.hostUrl}/${albumBoard?.files?[index].filename}",
                ),
              );
            },
            loadingBuilder: (context, event) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                ),
              );
            },
          ),
          Positioned(
            bottom: 20, // Set the distance from the top
            child: Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              height: 40,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.transparent,
              ),
              // color: Colors.white.withOpacity(0.7),
              child: TextButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const InkWell(
                      child: Icon(
                        Icons.near_me,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const InkWell(
                      child: Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const InkWell(
                      child: Icon(
                        Icons.ios_share_sharp,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        downloadImage(
                            albumBoard?.files?[currentIndex].filename);
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
