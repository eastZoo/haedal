import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/tab_menu_screen/album_screen.dart';
import 'package:haedal/screens/tab_menu_screen/calender_screen.dart';
import 'package:haedal/screens/tab_menu_screen/home_screen.dart';
import 'package:haedal/screens/tab_menu_screen/map_screen.dart';
import 'package:haedal/screens/tab_menu_screen/more_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 4;
  final autoSizeGroup = AutoSizeGroup();

  final iconList = [
    Icons.map,
    Icons.photo,
    Icons.calendar_month_outlined,
    Icons.more_horiz,
  ];

  final iconName = ['지도', '앨범', '캘린더', '더보기'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (context) {
          return GetBuilder<MapController>(
              init: MapController(),
              builder: (context) {
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
                            HomeScreen(),
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
                        setState(() => _selectedIndex = 4);
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
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
