import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController extends GetxController {
  late RxString status = "".obs;
  bool isinitialized = false;
  NaverMapViewOptions options = const NaverMapViewOptions();

  NaverMapController? prevMapController;
  NaverMapController? mapController;

  Position? currentLatLng;

  late Stream<CompassEvent>? compassStream;
  late Stream<Position> geolocatorStream;

  @override
  void onInit() async {
    super.onInit();

    var locStatus = await Permission.location.status;
    var activeStatus = await Permission.activityRecognition.status;

    compassStream = FlutterCompass.events;
    // 위치권한 허용되어있으면
    if (!locStatus.isDenied) {
      await initNaverMapElement();
      geolocatorStream = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ));
      geolocatorStream.listen(listenGeolocator);
    }
    // 위치 가져오는 함수
    // await fetchUserWalkLocation();
    print("isinitialized @!@!@!@!@!@");
    isinitialized = true;
  }

  @override
  void dispose() {
    super.dispose();
    mapController?.dispose();
    // mapController.
  }

  // 계속해서 현재 위치 리스너
  void listenGeolocator(Position position) async {
    currentLatLng = position;
    update();
  }

  // 네이버 맵 요소 기본 값 설정
  Future<void> initNaverMapElement() async {
    // 현재 위치값 가져오기
    currentLatLng = await Geolocator.getCurrentPosition();

    // naver mapp 카메라 기본 설정
    options = options.copyWith(
      indoorLevelPickerEnable: false,
      logoAlign: NLogoAlign.leftTop,
      minZoom: 15,
      extent: const NLatLngBounds(
        southWest: NLatLng(31.43, 122.37),
        northEast: NLatLng(44.35, 132.0),
      ),
      symbolPerspectiveRatio: 0,
      initialCameraPosition: NCameraPosition(
        target: NLatLng(currentLatLng!.latitude, currentLatLng!.longitude),
        zoom: 15,
      ),
    );
  }

//지도 오픈 시 컨트롤러 저장
  void setMapController(mapController) {
    this.mapController = mapController;
    update();
  }

  // 내위치 버튼
  void zoomMyLocation() async {
    await mapController?.updateCamera(NCameraUpdate.withParams(
      target: NLatLng(currentLatLng!.latitude, currentLatLng!.longitude),
      zoom: 15,
    ));
  }

  void setPrevMapController(mapController) {
    prevMapController = mapController;
    update();
  }

  refetchWalkLocation() async {
    // await fetchUserWalkLocation();
    // String visitMissionStatus = await getVisitMissionStatus(4);
    // status.value = visitMissionStatus;
    // changedStatus(visitMissionStatus);
    // update();
  }

  // 위치 가져오는 함수
  // fetchUserWalkLocation() async {
  //   try {
  //     var res = await VisitMissionProvider().getUserWalkLocation();
  //     var isSuccess = res["success"];
  //     if (isSuccess == true) {
  //       var responseData = res["data"];
  //       if (responseData != null && responseData != "") {
  //         List<dynamic> list = responseData["locations"];
  //         locations.assignAll(list
  //             .map<UserWalkLocation>((item) => UserWalkLocation.fromJson(item))
  //             .toList());
  //       }
  //     } else {
  //       return res["msg"];
  //     }
  //   } catch (e) {
  //     // throw Error();
  //   }
  // }
}
