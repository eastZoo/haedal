import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/routes/app_pages.dart';
import 'package:haedal/screens/add_image_screen.dart';
import 'package:haedal/service/controller/category_board_controller.dart';
import 'package:haedal/service/controller/infinite_scroll_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import '/widgets/re_usable_select_photo_button.dart';

class SelectPhotoOptionsScreen extends StatelessWidget {
  const SelectPhotoOptionsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InfiniteScrollController infiniteCon = Get.put(InfiniteScrollController());
    CategoryBoardController categoryBoardCon =
        Get.put(CategoryBoardController());
    return GetBuilder<MapController>(builder: (mapCon) {
      return Container(
        // color: Colors.grey.shade300,
        padding: const EdgeInsets.all(20),
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          clipBehavior: Clip.none,
          children: [
            // 스크롤 손잡이
            Positioned(
              top: -10,
              child: Container(
                width: 50,
                height: 6,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            // 버튼 시작
            Column(children: [
              const SizedBox(
                height: 20,
              ),
              SelectPhoto(
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: const AddimageScreen(),
                      isIos: true,
                      duration: routingDuration,
                    ),
                  );

                  print("ADD RESULT : : $result");
                  // add_naver_map dispose 시 클리어된 전역변수 컨트롤러에 다시 저장해놓은 현재 컨트롤러 부착
                  mapCon.setMapController(mapCon.prevMapController);
                  // 위치 리패칭을 통한 마커 새로고침
                  await infiniteCon.reload();
                  print(" await infiniteCon.reload();");
                  await mapCon.refetchLocation();
                  print("await mapCon.refetchLocation();");
                  // 메인 앨범 메뉴 리프래쉬(refetch)
                  // Future.delayed(
                  //   const Duration(milliseconds: 100),
                  //   () => {
                  //     infiniteCon.reload(),
                  //     mapCon.refetchLocation(),
                  //   },
                  // );
                  // 카테고리별 메뉴 리프래쉬
                  await categoryBoardCon.reload();
                },
                icon: Icons.image,
                textLabel: '앨범에서 추가',
              ),
              const SizedBox(
                height: 8,
              ),
              const Center(
                child: Text(
                  'OR',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SelectPhoto(
                onTap: () {},
                icon: Icons.camera_alt_outlined,
                textLabel: '준비중...',
              ),
            ])
          ],
        ),
      );
    });
  }
}
