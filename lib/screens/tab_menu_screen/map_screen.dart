import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/bottom_sheet.dart';
import 'package:haedal/widgets/naver_map.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool success = false;
  final mapCon = Get.put(MapController());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    permissionHandler();
  }

  @override
  void dispose() {
    super.dispose();
    // Get.delete<VisitMissionController>();
  }

  void initPlatformState() {
    if (!mounted) return;
  }

  void permissionHandler() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      return;
    }
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.activityRecognition,
      Permission.notification,
    ].request();

    var isit = statuses[Permission.location];

    print("$isit isit");
    if (isit == PermissionStatus.granted) {
      setState(() {
        success = true;
      });
    } else {
      permissionHandler();
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return success
        ? GetBuilder<MapController>(
            init: MapController(),
            builder: (mapCon) {
              return const LoadingOverlay(
                child: SafeArea(
                  maintainBottomViewPadding: true,
                  child: Stack(
                    children: [
                      CustomNaverMap(),
                      Positioned(
                        bottom: 90, // Adjust the value to move it up
                        left: 0,
                        right: 0,
                        child: BottonSheet(),
                      ),
                    ],
                  ),
                ),
              );
            })
        : Container();
  }
}
