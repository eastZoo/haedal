import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart' as GET;
import 'package:haedal/routes/app_pages.dart';
import 'package:haedal/screens/add_image_screen.dart';
import 'package:haedal/screens/select_photo_options_screen.dart';
import 'package:haedal/screens/tab_menu_screen/album_screen.dart';
import 'package:haedal/screens/tab_menu_screen/calender_screen.dart';
import 'package:haedal/screens/tab_menu_screen/map_screen.dart';
import 'package:haedal/screens/tab_menu_screen/memo_screen.dart';
import 'package:haedal/screens/tab_menu_screen/more_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:page_transition/page_transition.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // 앨범 초기 메인
  int _prevSelectedIndex = 2; // 앨범 초기 메인
  final autoSizeGroup = AutoSizeGroup();

  final iconList = [
    Icons.map,
    Icons.photo,
    Icons.add_circle_outline_sharp,
    Icons.calendar_month_outlined,
    Icons.more_horiz,
  ];

  final iconName = ['지도', '앨범', "", '캘린더', '더보기'];

  // 이미지 등록시 ( 이미지 or 글만 등록 선택 모달 )
  _showSelectPhotoOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.3,
          maxChildSize: 0.3,
          minChildSize: 0.28,
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
              builder: (mapCon) {
                return Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: _selectedIndex,
                          children: const [
                            MapScreen(),
                            MemoScreen(),
                            AlbumScreen(),
                            CalenderScreen(),
                            MoreScreen(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: SnakeNavigationBar.color(
                    ///configuration for SnakeNavigationBar.color
                    snakeViewColor: AppColors().mainColor,

                    unselectedItemColor: Colors.grey,

                    ///configuration for SnakeNavigationBar.gradient
                    //snakeViewGradient: selectedGradient,
                    //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
                    //unselectedItemGradient: unselectedGradient,

                    showUnselectedLabels: true,
                    showSelectedLabels: true,

                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _prevSelectedIndex = _selectedIndex;
                        _selectedIndex = index;
                      });

                      if (_prevSelectedIndex == 2 && _selectedIndex == 2) {
                        HapticFeedback.lightImpact();
                        mapCon.setPrevMapController(mapCon.mapController);
                        _showSelectPhotoOptions();
                      }
                    },

                    items: [
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.map_outlined, size: 22),
                          label: '지도'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.check_box_outlined, size: 22),
                          label: "메모"),
                      BottomNavigationBarItem(
                          icon: Icon(
                              _selectedIndex == 2
                                  ? Icons.add
                                  : Icons.photo_camera_back_outlined,
                              size: 22),
                          label: '앨범'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_month_outlined, size: 22),
                          label: '일정'),
                      const BottomNavigationBarItem(
                          icon: Icon(Icons.more_horiz, size: 22), label: '더보기')
                    ],
                    unselectedLabelStyle: const TextStyle(fontSize: 10),
                  ),
                );
              });
        });
  }
}
