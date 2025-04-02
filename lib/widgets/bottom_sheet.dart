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

import '../../service/endpoints.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class BottonSheet extends StatelessWidget {
  const BottonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryCon = Get.put(CategoryBoardController());

    return GetBuilder<MapController>(builder: (mapCon) {
      // 마커 클릭 시 현재 클릭한 패널 제외 모든 버튼 패널 닫기
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
        minHeight: 0,
        maxHeight: 180, // 최대 높이 지정
        borderRadius: const BorderRadius.only(
          // 상단 모서리 둥글게
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        color: Colors.white,
        panel: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // 드래그 핸들 추가
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 컨테이너
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PhotoViewScreen(
                            albumBoard: mapCon.selectedMarker,
                            currentIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 110,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
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

                  // 정보 컨테이너
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StoryDetailScreen(
                                    albumBoard: mapCon.selectedMarker,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${mapCon.selectedMarker?.title}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${mapCon.selectedMarker?.address}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors().darkGreyText,
                                    height: 1.4,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 카테고리 버튼
                          InkWell(
                            onTap: () async {
                              var result = await categoryCon.setCategory(
                                "${mapCon.selectedMarker?.category}",
                              );
                              if (result) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CategoryStoryScreen(),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors().mainColor,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors().mainColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                "${mapCon.selectedMarker?.category}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        controller: mapCon.panelController,
        onPanelClosed: closedBottonSheet,
        onPanelOpened: openBottonSheet,
      );
    });
  }
}
