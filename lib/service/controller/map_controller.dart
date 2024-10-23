import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:haedal/models/album.dart';
import 'package:haedal/models/user_location.dart';
import 'package:haedal/service/provider/map_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapController extends GetxController {
  late RxString status = "basic".obs;
  bool isinitialized = false;
  NaverMapViewOptions options = const NaverMapViewOptions();

  NaverMapController? prevMapController;
  NaverMapController? mapController;

  Position? currentLatLng;
  AlbumBoard? selectedMarker;

  // 마커 아이콘 클릭헀을때 마커 정보 패널 컨트롤러
  final PanelController panelController = PanelController();

  late Stream<CompassEvent>? compassStream;
  late Stream<Position> geolocatorStream;

  var locations = <AlbumBoard>[].obs;

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
    await fetchLocationMark();

    isinitialized = true;

    // 지도에 마커 뿌리기
    await setupMapOnReady();
    ever(status, (value) {
      changedStatus(value);
    });
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
      minZoom: 7,
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

  // 음식점 marker
  NMarker getRestaurantLocationMarker(AlbumBoard location) {
    final marker = NMarker(
      size: const Size(43, 45),
      id: "maker_${location.id}",
      icon: const NOverlayImage.fromAssetImage(
          'assets/icons/marker/restaurant.png'),
      position: NLatLng(
          double.parse(location.lat!) ?? 0, double.parse(location.lng!) ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

  //숙소 marker
  NMarker getLodgingLocationMarker(AlbumBoard location) {
    final marker = NMarker(
      size: const Size(43, 45),
      id: "maker_${location.id}",
      icon:
          const NOverlayImage.fromAssetImage('assets/icons/marker/lodging.png'),
      position: NLatLng(
          double.parse(location.lat!) ?? 0, double.parse(location.lng!) ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

  //카페 marker
  NMarker getCafeLocationMarker(AlbumBoard location) {
    final marker = NMarker(
      size: const Size(43, 45),
      id: "maker_${location.id}",
      icon: const NOverlayImage.fromAssetImage('assets/icons/marker/cafe.png'),
      position: NLatLng(
          double.parse(location.lat!) ?? 0, double.parse(location.lng!) ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

//플레이 marker
  NMarker getPlayLocationMarker(AlbumBoard location) {
    final marker = NMarker(
      size: const Size(43, 45),
      id: "maker_${location.id}",
      icon:
          const NOverlayImage.fromAssetImage('assets/icons/marker/arcade.png'),
      position: NLatLng(
          double.parse(location.lat!) ?? 0, double.parse(location.lng!) ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

  //장소 marker
  NMarker getPlaceLocationMarker(AlbumBoard location) {
    final marker = NMarker(
      size: const Size(43, 45),
      id: "maker_${location.id}",
      icon: const NOverlayImage.fromAssetImage('assets/icons/marker/trip.png'),
      position: NLatLng(
          double.parse(location.lat!) ?? 0, double.parse(location.lng!) ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

  //스토어 marker
  NMarker getStoreLocationMarker(AlbumBoard location) {
    final marker = NMarker(
      size: const Size(43, 45),
      id: "maker_${location.id}",
      icon: const NOverlayImage.fromAssetImage('assets/icons/marker/shop.png'),
      position: NLatLng(
          double.parse(location.lat!) ?? 0, double.parse(location.lng!) ?? 0),
    );
    marker.setOnTapListener((overlay) {
      onSelectedMarker(location);
    });
    return marker;
  }

// UserLocaion marker를 클릭 했을때
  void onSelectedMarker(AlbumBoard location) {
    panelController.close().then((value) async {
      var marker = getRestaurantLocationMarker(location);
      marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/icons/marker/selected_marker.png'));

      if (location.category == "음식점") {
        marker = getRestaurantLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/marker/restaurant-active.png'));
      }
      if (location.category == "숙소") {
        marker = getLodgingLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/marker/lodging-active.png'));
      }
      if (location.category == "카페") {
        marker = getCafeLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/marker/cafe-active.png'));
      }
      if (location.category == "플레이") {
        marker = getCafeLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/marker/arcade-active.png'));
      }
      if (location.category == "장소") {
        marker = getCafeLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/marker/trip-active.png'));
      }
      if (location.category == "스토어") {
        marker = getCafeLocationMarker(location);
        marker.setIcon(const NOverlayImage.fromAssetImage(
            'assets/icons/marker/shop-active.png'));
      }
      mapController?.addOverlay(marker);
      selectedMarker = location;
      print(location);
      update();
      panelController.open();
    });
  }

//지도 오픈 시 컨트롤러 저장
  setMapController(mapController) {
    this.mapController = mapController;
    update();
  }

  // 내위치 버튼
  void zoomMyLocation() async {
    if (currentLatLng != null) {
      await mapController?.updateCamera(NCameraUpdate.withParams(
        target: NLatLng(currentLatLng!.latitude, currentLatLng!.longitude),
        zoom: 15,
      ));
    }
  }

  void setPrevMapController(mapController) {
    prevMapController = mapController;
    update();
  }

  changedStatus(value) {
    if (value == "basic") {
      setupMapOnReady();
    }
    if (value == "select") {}
  }

  refetchLocation() async {
    await fetchLocationMark();

    changedStatus("basic");
    update();
  }

  // 위치 가져오는 함수
  fetchLocationMark() async {
    try {
      var res = await MapProvider().getLocation();
      var isSuccess = res["success"];
      if (isSuccess == true) {
        var responseData = res["data"];
        if (responseData != null && responseData != "") {
          List<dynamic> list = responseData;

          locations.assignAll(list
              .map<AlbumBoard>((item) => AlbumBoard.fromJson(item))
              .toList());

          print("location@@ : $locations");
        }
      } else {
        return res["msg"];
      }
    } catch (e) {
      print(e);
      // throw Error();
    }
  }

  setupMapOnReady() async {
    try {
      print("setupMapOnReady");
      mapController?.clearOverlays();
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
          print("${location.category} dsdasd");
          var marker = getCafeLocationMarker(location);
          if (location.category == "음식점") {
            print("object");
            marker = getRestaurantLocationMarker(location);
          }
          if (location.category == "숙소") {
            marker = getLodgingLocationMarker(location);
          }
          if (location.category == "카페") {
            marker = getCafeLocationMarker(location);
          }
          if (location.category == "플레이") {
            marker = getPlayLocationMarker(location);
          }
          if (location.category == "장소") {
            marker = getPlaceLocationMarker(location);
          }
          if (location.category == "스토어") {
            marker = getStoreLocationMarker(location);
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

  updateSelectedMarker(marker) {
    print(marker);
    selectedMarker = marker;
    update();
  }
}
