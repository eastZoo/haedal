import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
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
    return GetBuilder<InfiniteScrollController>(
        init: InfiniteScrollController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: Column(children: [
                const MainAppbar(title: '스토리 / 위치리스트'),
                Expanded(
                    child: Obx(
                  () => ListView.separated(
                    controller: controller.scrollController.value,
                    itemBuilder: (_, index) {
                      print(controller.hasMore.value);
                      if (index < controller.data.length) {
                        var datum = controller.data[index];
                        return postCard("title");
                      }
                      if (controller.hasMore.value ||
                          controller.isLoading.value) {
                        return const Center(child: RefreshProgressIndicator());
                      }
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('데이터의 마지막 입니다'),
                              IconButton(
                                onPressed: () {
                                  controller.reload();
                                },
                                icon: const Icon(Icons.refresh_outlined),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, index) => const Divider(),
                    itemCount: controller.data.length + 1,
                  ),
                )),
              ]),
            ),
          );
        });
  }
}
