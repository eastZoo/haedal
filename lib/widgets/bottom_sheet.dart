import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/category_story_screen.dart';
import 'package:haedal/screens/photo_view_screen.dart';
import 'package:haedal/screens/story_detail_screen.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/app_button.dart';
import 'package:haedal/widgets/popover.dart';

import '../../service/endpoints.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottonSheet extends StatelessWidget {
  const BottonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryCon = Get.put(CategoryBoardController());

    return GetBuilder<MapController>(builder: (mapCon) {
      void closedBottonSheet() {
        if (mapCon.selectedMarker != null) {
          var marker = mapCon.getCafeLocationMarker(mapCon.selectedMarker!);
          if (mapCon.selectedMarker?.category == "음식점") {
            marker = mapCon.getRestaurantLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "숙소") {
            marker = mapCon.getLodgingLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "카페") {
            marker = mapCon.getCafeLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "플레이") {
            marker = mapCon.getPlayLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "장소") {
            marker = mapCon.getPlaceLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "스토어") {
            marker = mapCon.getStoreLocationMarker(mapCon.selectedMarker!);
          }

          mapCon.mapController?.addOverlay(marker);
          mapCon.updateSelectedMarker(null);
        }
      }

      void openBottonSheet() {}

      return SlidingUpPanel(
        minHeight: 10,
        renderPanelSheet: false,
        panel: Container(
          alignment: Alignment.bottomCenter,
          child: Popover(
            child: Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 핀클릭 시 올라오는 슬라이드 패널 이미지 클릭시 이미지 자세히보기 페이지로 이동
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return PhotoViewScreen(
                                    albumBoard: mapCon.selectedMarker,
                                    currentIndex: 0);
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: mapCon.selectedMarker?.files != null
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      "${Endpoints.hostUrl}/${mapCon.selectedMarker?.files?.first.filename}",
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) {
                                    return StoryDetailScreen(
                                        albumBoard: mapCon.selectedMarker);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${mapCon.selectedMarker?.title}",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Text(
                                    "${mapCon.selectedMarker?.address}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors().darkGreyText),
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () async {
                              var result = await categoryCon.setCategory(
                                  "${mapCon.selectedMarker?.category}");

                              print("@@@@@@@@@ $result");
                              if (result) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return const CategoryStoryScreen();
                                    },
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 65,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: AppColors().mainColor,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${mapCon.selectedMarker?.category}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        controller: mapCon.panelController,
        onPanelClosed: closedBottonSheet,
        onPanelOpened: openBottonSheet,
      );
    });
  }
}
