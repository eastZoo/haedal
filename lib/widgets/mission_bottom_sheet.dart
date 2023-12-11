import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/app_button.dart';
import 'package:haedal/widgets/popover.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class MissionBottonSheet extends StatelessWidget {
  const MissionBottonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapController>(builder: (mapCon) {
      void closedBottonSheet() {
        if (mapCon.selectedMarker != null) {
          var marker = mapCon.getCafeLocationMarker(mapCon.selectedMarker!);
          if (mapCon.selectedMarker?.category == "음식점") {
            marker = mapCon.getRestaurantLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "숙소") {
            marker =
                mapCon.getAccommodationLocationMarker(mapCon.selectedMarker!);
          }
          if (mapCon.selectedMarker?.category == "카페") {
            marker = mapCon.getCafeLocationMarker(mapCon.selectedMarker!);
          }

          mapCon.mapController?.addOverlay(marker);
          mapCon.updateSelectedMarker(null);
        }
      }

      void openBottonSheet() {}
      return SlidingUpPanel(
        minHeight: 0,
        renderPanelSheet: false,
        panel: Container(
          alignment: Alignment.bottomCenter,
          child: Popover(
            child: Container(
              padding: const EdgeInsets.all(18),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${mapCon.selectedMarker?.title}',
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'NotoSansKR',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: AppButton(
                          icon: const Icon(
                            Icons.directions_walk,
                            color: Colors.white,
                          ),
                          text: "걷기미션 시작",
                          color: AppColors().buttonPrimary,
                          // onPressed: onStart,

                          width: 150,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        controller: mapCon.panelController,
        onPanelClosed: closedBottonSheet,
        onPanelOpened: openBottonSheet,
      );
    });
  }
}
