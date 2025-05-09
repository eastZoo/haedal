import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/location_controller.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/add_location_bottom_sheet.dart';
import 'package:haedal/widgets/animation_marker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SelectMapPositionScreen extends StatefulWidget {
  const SelectMapPositionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectMapPositionScreen> createState() =>
      _SelectMapPositionScreenState();
}

class _SelectMapPositionScreenState extends State<SelectMapPositionScreen> {
  late NaverMapController mapController;
  final PanelController panelController = PanelController();
  TextEditingController inputController = TextEditingController();
  NaverMapViewOptions options = const NaverMapViewOptions();
  String inputText = '';

  // 도로명 주소
  String addressName = '';
  // 지번 주소
  String address = '';
  NLatLng? currentLatLng;
  bool isMoving = false;

  @override
  void initState() {
    super.initState();
    final mapCon = Get.put(MapController());
    if (mapCon.currentLatLng != null) {
      options = options.copyWith(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(
              mapCon.currentLatLng!.latitude, mapCon.currentLatLng!.longitude),
          zoom: 14,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    final mapCon = Get.put(MapController());
    // 마커 등록화면 나갈때 마커 리패치
    // mapCon.refetchWalkLocation();
    // mCtrl.userMarker = null;
    mapCon.mapController = null;
  }

  @override
  Widget build(BuildContext context) {
    final mapCon = Get.put(MapController());

    void onMapReady(NaverMapController nController) async {
      nController.setLocationTrackingMode(NLocationTrackingMode.noFollow);
      mapCon.setMapController(nController);

      // mapCon.startAddpointReady();
      mapController = nController;
    }

    void onSaveLocation() async {
      Map<String, dynamic> dataSource = {
        "address": addressName,
        "lat": currentLatLng?.latitude,
        "lng": currentLatLng?.longitude,
      };

      Navigator.pop(context, dataSource);
    }

    void onMapTapped(NPoint point, NLatLng latLng) async {
      currentLatLng = latLng;
      final marker = NMarker(
          id: 'mapPoint', position: NLatLng(latLng.latitude, latLng.longitude));
      mapController.addOverlay(marker);

      Map<String, dynamic> data = await LocationController()
          .getAddressFromCoordinates(latLng.latitude, latLng.longitude);

      setState(() {
        addressName = data["addressName"];
        address = data["address"];
      });

      panelController.open();
    }

    void onSymbolTapped(NSymbolInfo symbol) async {
      // NLatLng latLng = symbol.position;

      // currentLatLng = latLng;
      // final marker = NMarker(
      //   id: 'mapPoint',
      //   position: NLatLng(latLng.latitude, latLng.longitude),
      // );
      // mapController.addOverlay(marker);

      // Map<String, dynamic> data = await LocationController()
      //     .getAddressFromCoordinates(latLng.latitude, latLng.longitude);
      // setState(() {
      //   addressName = data["addressName"];
      //   address = data["address"];
      // });

      // panelController.open();
      // ignore: use_build_context_synchronously
    }

    void onCameraChange(NCameraUpdateReason location, bool isGesture) {
      setState(() {
        isMoving = true;
      });
    }

    void onCameraIdle() async {
      try {
        setState(() {
          isMoving = false;
        });
        // 카메라 위치를 가져옵니다.
        final cameraPosition = await mapController.getCameraPosition();
        currentLatLng = cameraPosition.target;
        Map<String, dynamic> data = await LocationController()
            .getAddressFromCoordinates(cameraPosition.target.latitude,
                cameraPosition.target.longitude);
        setState(() {
          addressName = data["addressName"];
          address = data["address"];
        });

        panelController.open();
      } catch (e) {
        print(e);
        CustomToast().alert("위치를 가져오는데 실패했습니다. 다시 시도해주세요.");
      }
    }

    void onSelectedIndoorChanged(NSelectedIndoor? selectedIndoor) {}

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "위치 저장",
          style: TextStyle(fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF676B85)),
      ),
      body: Stack(
        children: [
          NaverMap(
            options: options,
            onMapReady: onMapReady,
            onMapTapped: onMapTapped,
            onSymbolTapped: onSymbolTapped,
            onCameraChange: onCameraChange,
            onCameraIdle: onCameraIdle,
            onSelectedIndoorChanged: onSelectedIndoorChanged,
          ),
          AnimationMarker(isMoving: isMoving),
          AddLocationBottonSheet(
            panelController: panelController,
            inputController: inputController,
            addressName: addressName,
            address: address,
            onSaveLocation: onSaveLocation,
            onChangedText: (text) {
              inputText = text;
            },
            onClosedBottomSheet: () {
              mapController.deleteOverlay(
                const NOverlayInfo(type: NOverlayType.marker, id: "mapPoint"),
              );
            },
          ),
          Positioned(
            top: 25, // Set the distance from the top
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
        ],
      ),
    );
  }
}
