import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/map_controller.dart';

class CustomNaverMap extends StatefulWidget {
  const CustomNaverMap({super.key});

  @override
  State<CustomNaverMap> createState() => _CustomNaverMapState();
}

class _CustomNaverMapState extends State<CustomNaverMap> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapCon = Get.put(MapController());

    void onMapReady(NaverMapController nController) async {
      print("READTY@@@@@@@@@@@@@@@");
      nController.setLocationTrackingMode(NLocationTrackingMode.follow);
      mapCon.setMapController(nController);
      // mCtrl.changedStatus(mCtrl.status);
    }

    void onMapTapped(NPoint point, NLatLng latLng) {}

    void onSymbolTapped(NSymbolInfo symbolInfo) {}

    void onCameraChange(NCameraUpdateReason reason, bool isGesture) {}

    void onCameraIdle() {}

    void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {}
    return GetBuilder<MapController>(
        init: MapController(),
        builder: (mapCon) {
          return Stack(children: [
            NaverMap(
              options: mapCon.options,
              onMapReady: onMapReady,
              onMapTapped: onMapTapped,
              onSymbolTapped: onSymbolTapped,
              onCameraChange: onCameraChange,
              onCameraIdle: onCameraIdle,
              onSelectedIndoorChanged: onSelectedIndoorChanged,
            ),
            Positioned(
              top: 40, // Set the distance from the top
              left: 20,
              child: Container(
                width: 100,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                // color: Colors.white.withOpacity(0.7),
                child: TextButton(
                  onPressed: () {
                    mapCon.zoomMyLocation();
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.near_me,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '내 위치',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2B2E45)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // test
            Positioned(
              top: 40, // Set the distance from the top
              right: 40,
              child: Container(
                width: 100,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white,
                ),
                // color: Colors.white.withOpacity(0.7),
                child: TextButton(
                  onPressed: () {
                    print("mapCon.locations");
                    print(mapCon.locations);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.near_me,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '마커테스트',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2B2E45)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        });
  }
}
