import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' as GET;
import 'package:haedal/routes/app_pages.dart';
import 'package:haedal/screens/add_image_screen.dart';
import 'package:haedal/screens/select_photo_options_screen.dart';
import 'package:haedal/screens/tab_menu_screen/album_screen.dart';
import 'package:haedal/screens/tab_menu_screen/calender_screen.dart';
import 'package:haedal/screens/tab_menu_screen/map_screen.dart';
import 'package:haedal/screens/tab_menu_screen/more_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:page_transition/page_transition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 3;
  final autoSizeGroup = AutoSizeGroup();

  final iconList = [
    Icons.map,
    Icons.photo,
    Icons.calendar_month_outlined,
    Icons.more_horiz,
  ];

  final iconName = ['지도', '앨범', '캘린더', '더보기'];

  // 이미지 등록시 ( 이미지 or 글만 등록 선택 모달 )
  showAddPhoto() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 180,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '등록방법 선택',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context))
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A7FB),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              ),
                              Text(
                                '미정',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: const AddimageScreen(),
                              isIos: true,
                              duration: routingDuration,
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A7FB),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo,
                                size: 40,
                                color: Colors.white,
                              ),
                              Text(
                                '앨범에서\n추가',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSelectPhotoOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.28,
          minChildSize: 0.20,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: const SelectPhotoOptionsScreen(),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GET.GetBuilder<AuthController>(
        init: AuthController(),
        builder: (AuthCon) {
          return GET.GetBuilder<MapController>(
              init: MapController(),
              builder: (MapCon) {
                return Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: const [
                            MapScreen(),
                            AlbumScreen(),
                            CalenderScreen(),
                            MoreScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterDocked,
                  floatingActionButton: SizedBox(
                    height: 49,
                    width: 49,
                    child: FloatingActionButton(
                      backgroundColor: const Color(0xFFD4A7FB),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        _showSelectPhotoOptions();
                      },
                      child: const Icon(
                        Icons.add,
                        size: 25,
                      ),
                    ),
                  ),
                  bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                    itemCount: 4,
                    height: 65,
                    blurEffect: false,
                    splashSpeedInMilliseconds: 0,
                    tabBuilder: (int index, bool isActive) {
                      final color =
                          isActive ? const Color(0xFFD4A7FB) : Colors.black;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            iconList[index],
                            size: 18,
                            color: color,
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: AutoSizeText(
                              iconName[index],
                              maxLines: 1,
                              style: TextStyle(color: color, fontSize: 10),
                              group: autoSizeGroup,
                            ),
                          )
                        ],
                      );
                    },
                    activeIndex: _selectedIndex,
                    gapLocation: GapLocation.center,
                    onTap: (index) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              });
        });
  }
}
