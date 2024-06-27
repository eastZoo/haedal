import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart' as GET;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:haedal/screens/drawer_screen/custom_drawer.dart';
import 'package:haedal/screens/alarm_screen.dart';
import 'package:haedal/screens/select_photo_options_screen.dart';
import 'package:haedal/screens/tab_menu_screen/album_screen.dart';
import 'package:haedal/screens/tab_menu_screen/calender_screen.dart';
import 'package:haedal/screens/tab_menu_screen/home_screen.dart';
import 'package:haedal/screens/tab_menu_screen/map_screen.dart';
import 'package:haedal/screens/tab_menu_screen/memo_screen.dart';
import 'package:haedal/screens/tab_menu_screen/more_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/custom_app_bar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final mapCon = (MapController());

  int _selectedIndex = 0; // 앨범 초기 메인
  int _prevSelectedIndex = 1; // 앨범 초기 메인
  final autoSizeGroup = AutoSizeGroup();
  late CalendarController controller;
  bool _hideBottomNavBar = false;

  String _authStatus = 'Unknown';
  // 앨범 토글 인덱스 값
  int currentToggleIdx = 0;

  @override
  void initState() {
    // 앱 추적 권한 허용 모달 띄우기 ( 앱 최초 한번 )
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlugin());
    controller = CalendarController();
    super.initState();
  }

  // 앱 추적 권한 허용 모달
  Future<void> initPlugin() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');

      if (status == TrackingStatus.notDetermined) {
        final TrackingStatus status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        setState(() => _authStatus = '$status');
      }
    } on PlatformException {
      setState(() => _authStatus = 'Failed to get tracking status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID : $uuid");
  }

  final iconList = [
    Icons.map,
    Icons.photo,
    Icons.add_circle_outline_sharp,
    Icons.calendar_month_outlined,
    Icons.more_horiz,
  ];
  final appBarName = ["지도", '메모', '스토리', '일정', '더보기'];

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
    return GET.GetBuilder<HomeController>(
        init: HomeController(),
        builder: (homeCon) {
          return GET.GetBuilder<ScheduleController>(
              init: ScheduleController(),
              builder: (ScheduleCon) {
                return GET.GetBuilder<AuthController>(
                    init: AuthController(),
                    builder: (authCon) {
                      return GET.GetBuilder<MapController>(
                          init: MapController(),
                          builder: (mapCon) {
                            // board 표현 토글 값
                            void updateToggleIdx(int newValue) {
                              if (newValue == 1) {
                                mapCon.onInit();
                                setState(() {
                                  currentToggleIdx = newValue;
                                });
                                return;
                              }
                              setState(() {
                                currentToggleIdx = newValue;
                              });
                            }

                            return Scaffold(
                                extendBody: true,
                                appBar: CustomAppbar(
                                  title: appBarName[_selectedIndex],
                                  selectedIndex: _selectedIndex,
                                  updateToggleIdx: updateToggleIdx,
                                  currentToggleIdx: currentToggleIdx,
                                  onNotificationIconTap: () {
                                    setState(() {
                                      _hideBottomNavBar = true;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AlarmScreen()),
                                      ).then((_) {
                                        setState(() {
                                          _hideBottomNavBar = false;
                                        });
                                      });
                                    });
                                  },
                                ),
                                // drawer: const CustomDrawer(),
                                body: Column(
                                  children: [
                                    Expanded(
                                      child: IndexedStack(
                                        index: _selectedIndex,
                                        children: [
                                          const HomeScreen(),
                                          const MemoScreen(),
                                          currentToggleIdx == 0
                                              ? const AlbumScreen()
                                              : const MapScreen(),
                                          CalenderScreen(
                                              controller: controller),
                                          const MoreScreen(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                bottomNavigationBar: Obx(
                                  () => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: _hideBottomNavBar ||
                                            homeCon.isEditMode01.value
                                        ? 0
                                        : 100,
                                    child: SnakeNavigationBar.color(
                                      backgroundColor: AppColors().mainColor,
                                      snakeViewColor:
                                          AppColors().mainYellowColor,
                                      selectedItemColor: AppColors().mainColor,
                                      unselectedItemColor:
                                          AppColors().mainYellowColor,
                                      showUnselectedLabels: true,
                                      showSelectedLabels: true,
                                      currentIndex: _selectedIndex,
                                      onTap: (index) {
                                        setState(() {
                                          _prevSelectedIndex = _selectedIndex;
                                          _selectedIndex = index;
                                        });
                                        if (_prevSelectedIndex == 3 &&
                                            _selectedIndex == 3) {
                                          controller.displayDate =
                                              DateTime.now();
                                        }
                                        if (_prevSelectedIndex == 2 &&
                                            _selectedIndex == 2) {
                                          HapticFeedback.lightImpact();
                                          mapCon.setPrevMapController(
                                              mapCon.mapController);
                                          _showSelectPhotoOptions();
                                        }
                                      },
                                      items: [
                                        BottomNavigationBarItem(
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Image.asset(
                                                'assets/icons/home.png',
                                                width: 25,
                                                height: 25,
                                                color: _selectedIndex == 0
                                                    ? AppColors().mainColor
                                                    : AppColors()
                                                        .mainYellowColor),
                                          ),
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Image.asset(
                                                'assets/icons/insert_drive_file.png',
                                                width: 25,
                                                height: 25,
                                                color: _selectedIndex == 1
                                                    ? AppColors().mainColor
                                                    : AppColors()
                                                        .mainYellowColor),
                                          ),
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: _selectedIndex == 2
                                                ? const Icon(Icons.add,
                                                    size: 25)
                                                : Image.asset(
                                                    'assets/icons/insert_photo.png',
                                                    width: 25,
                                                    height: 25),
                                          ),
                                        ),
                                        const BottomNavigationBarItem(
                                          icon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Icon(
                                                Icons.calendar_month_outlined,
                                                size: 25),
                                          ),
                                        ),
                                        const BottomNavigationBarItem(
                                          icon: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: CircleAvatar(
                                              radius: 20, // 프로필 사진의 크기
                                              // foregroundImage: NetworkImage(
                                              //     "${authCon.coupleInfo?.me?.profileUrl}"), // 프로필 사진 경로
                                              backgroundImage: AssetImage(
                                                  "assets/icons/profile.png"),
                                            ),
                                          ),
                                        ),
                                      ],
                                      unselectedLabelStyle:
                                          const TextStyle(fontSize: 10),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ));
                          });
                    });
              });
        });
  }
}
