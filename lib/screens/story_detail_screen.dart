import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:haedal/models/album.dart';
import 'package:haedal/screens/photo_view_screen.dart';
import 'package:haedal/service/controller/board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/styles/colors.dart';
import '../../service/endpoints.dart';
import 'package:haedal/styles/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  BoardController boardCon = Get.put(BoardController());
  InfiniteScrollController infiniteCon = Get.put(InfiniteScrollController());
  double position = 0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _thumbPhoto(),
                  ),
                  actions: [_deleteBtn(position), _addBtn(position)],
                  leading: BackButton(
                    color:
                        position < 150 ? Colors.white : AppColors().mainColor,
                  ),
                  title: position < 150
                      ? null
                      : AnimatedBuilder(
                          animation: _scrollController,
                          builder: (BuildContext context, Widget? child) {
                            // 앱바 날짜 타이틀
                            DateTime dateTime =
                                DateTime.parse(albumBoard.storyDate.toString());
                            String formattedDate = DateFormat.yMMMMd("ko_KR")
                                .add_E()
                                .format(dateTime);

                            double offset = _scrollController.hasClients
                                ? _scrollController.offset
                                : _scrollController.initialScrollOffset;

                            // Calculate the title position based on the scroll offset
                            double titlePosition = 100.0 - (offset - 160);

                            return Container(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Transform.translate(
                                offset: Offset(0, titlePosition),
                                child: Text(
                                  formattedDate,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: AppColors().mainColor),
                                ),
                              ),
                            );
                          },
                        ),
                  centerTitle: true,
                  pinned: true,
                ),
              ],
          body: _getDrawerItemWidget()),
    );
  }

  Widget _getDrawerItemWidget() {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          color: const Color.fromARGB(255, 234, 234, 234),
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 5),
            itemCount: albumBoard.files?.length,
            itemBuilder: (BuildContext context, int index) {
              // content 내용이 0이 아니고 index가 처음일때
              if (albumBoard.content.length != 0 && index == 0) {
                return Column(
                  children: [
                    postCard(0, index, type: "text"),
                    postCard(albumBoard.files?[index], index),
                  ],
                );
              } else {
                return postCard(albumBoard.files?[index], index);
              }
            },
          ),
        ));
  }

  // 카드 리스트
  Widget postCard(data, index, {String type = "image"}) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.all(5),
        color: Colors.white,
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 8.0, top: 3),
                //       child:
                //           SizedBox(height: 55, width: 55, child: CircleStory()),
                //     ),
                //     const SizedBox(
                //       width: 3,
                //     ),
                //     const Text(
                //       'username123',
                //       style: TextStyle(color: Colors.white, fontSize: 15),
                //     )
                //   ],
                // ),
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            ///////////////////////////////////////////////////////////////////////////
            type == "image"
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return PhotoViewScreen(
                                  albumBoard: albumBoard, currentIndex: index);
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              "${Endpoints.hostUrl}/${data?.filename}",
                            ),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text('${albumBoard.content}'),
                      ),
                    ),
                  ),
            //////////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Icon(
                          Icons.favorite_outline_rounded,
                          color: AppColors().mainDisabledColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: AppColors().mainDisabledColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Icon(
                          Icons.near_me_outlined,
                          color: AppColors().mainDisabledColor,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                  Icon(
                    Icons.bookmark_border,
                    color: AppColors().mainColor,
                    size: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CircleStory() {
    return const Padding(
      padding: EdgeInsets.all(6.0),
      child: ClipOval(
        child: Image(
          height: 68,
          width: 68,
          image: NetworkImage(
              'https://cdn.pixabay.com/photo/2018/07/29/23/05/woman-3571298_960_720.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // appbar 리드
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

//삭제버튼
  Widget _deleteBtn(double position) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: GestureDetector(
        child: Icon(
          Icons.delete_outline_outlined,
          size: 25,
          color: position < 150 ? Colors.white : AppColors().mainColor,
        ),
        onTap: () async {
          print("@!@!@");
          var res = await boardCon.deleteBoard(albumBoard.id);
          print("DELETE BOARD :!!!!! $res");
          if (res) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () => infiniteCon.reload(),
            );

            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // 썸네일 이미지
  Widget _thumbPhoto() {
    double width = MediaQuery.of(context).size.width;
    DateTime dateTime = DateTime.parse(albumBoard.storyDate.toString());

    // Format the date
    String formattedDate = DateFormat.yMMMMd("ko_KR").add_E().format(dateTime);

    return Container(
      child: Container(
        height: width / 1.6,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(214, 255, 255, 255),
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
                  Text(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
