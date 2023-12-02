import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/widgets/main_appbar.dart';

import '../../service/endpoints.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
// 게시글 카드
  Widget postCard(title, path) {
    print("${Endpoints.hostUrl}/$path");
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            "${Endpoints.hostUrl}/$path",
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
                        var data = controller.data[index];
                        return postCard(
                            data["title"], data["files"][0]["filename"]);
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
