import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/app_button.dart';
import 'package:haedal/widgets/popover.dart';

import '../../service/endpoints.dart';

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
      print("****** ${Endpoints.hostUrl}/${mapCon.selectedMarker?.title}");
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: mapCon.selectedMarker?.files != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    "${Endpoints.hostUrl}/${mapCon.selectedMarker?.files?.first.filename}",
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${mapCon.selectedMarker?.title}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              "${mapCon.selectedMarker?.address}",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors().textGrey),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 60,
                            height: 18,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: AppColors().mainColor,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${mapCon.selectedMarker?.category}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
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
