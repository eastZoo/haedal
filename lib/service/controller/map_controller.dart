import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:haedal/models/user_location.dart';
import 'package:haedal/service/provider/map_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapController extends GetxController {
  late RxString status = "".obs;
  bool isinitialized = false;
  NaverMapViewOptions options = const NaverMapViewOptions();

  NaverMapController? prevMapController;
  NaverMapController? mapController;

  Position? currentLatLng;

  UserLocation? selectedMarker;

  // 마커 아이콘 클릭헀을때 마커 정보 패널 컨트롤러
  final PanelController panelController = PanelController();

  late Stream<CompassEvent>? compassStream;
  late Stream<Position> geolocatorStream;

  var locations = <UserLocation>[].obs;

  @override
  void onInit() async {
    super.onInit();

    var locStatus = await Permission.location.status;
    var activeStatus = await Permission.activityRecognition.status;

    await fetchLocationMark();

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
    // 마커 로케이션 맵 레디
    await setupMapOnReady();
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
      minZoom: 10,
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

  // UserWalkLocaion 기본 설정 값
  NMarker getDefaultLocationMarker(UserLocation location) {
    final marker = NMarker(
      size: const Size(45, 55),
      id: "maker_${location.id}",
      icon: const NOverlayImage.fromAssetImage('assets/icons/marker.png'),
      position: NLatLng(location.lat ?? 0, location.lng ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

  //event marker
  NMarker getEventLocationMarker(UserLocation location) {
    final marker = NMarker(
      size: const Size(45, 55),
      id: "maker_${location.id}",
      icon: const NOverlayImage.fromAssetImage('assets/icons/event_marker.png'),
      position: NLatLng(location.lat ?? 0, location.lng ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

// UserLocaion marker를 클릭 했을때
  void onSelectedMarker(UserLocation location) {
    panelController.close().then((value) async {
      var marker = getDefaultLocationMarker(location);
      marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/icons/selected_marker.png'));

      if (location.type == "event") {
        marker = getEventLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/selected_event_marker.png'));
      }

      mapController?.addOverlay(marker);
      selectedMarker = location;
      update();
      panelController.open();
    });
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
  fetchLocationMark() async {
    try {
      var res = await MapProvider().getLocation();
      print("res !!!!!!!!!!!!!");
      print(res);
      var isSuccess = res["success"];
      if (isSuccess == true) {
        var responseData = res["data"];
        if (responseData != null && responseData != "") {
          List<dynamic> list = responseData["locations"];
          locations.assignAll(list
              .map<UserLocation>((item) => UserLocation.fromJson(item))
              .toList());
        }
      } else {
        return res["msg"];
      }
    } catch (e) {
      // throw Error();
    }
  }

  setupMapOnReady() async {
    try {
      mapController?.clearOverlays();
      // mapController?.addOverlay(userMarker!);
      setLocationMarkers();
    } catch (error) {
      print(error);
    }
  }

// 로케이션 마커 화면에 패칭
  void setLocationMarkers() {
    try {
      Set<NMarker> markers = {};
      if (mapController != null) {
        for (var location in locations) {
          var marker = getDefaultLocationMarker(location);
          if (location.type == "event") {
            marker = getEventLocationMarker(location);
          }

          markers.add(marker);
        }
        // mapController?.addOverlay(userMarker!);
        if (markers.isNotEmpty) {
          mapController?.addOverlayAll(markers);
        }
      }
      update();
    } catch (e) {
      print(e);
    }
  }
}
