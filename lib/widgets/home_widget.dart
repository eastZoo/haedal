import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final homeCon = Get.put(HomeController());

  bool isClick = false;

  @override
  void initState() {
    super.initState();
    homeCon.loadElementPosition();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: AuthController(),
      builder: (authCon) {
        return GetBuilder<HomeController>(
          init: HomeController(),
          builder: (homeCon) {
            DateTime currentDate = DateTime.now();

            return Stack(
              children: [
                // 위젯 드래그
                Obx(() => homeCon.first01Visible.value
                    ? Positioned(
                        left: homeCon.elementOffset01.dx,
                        top: homeCon.elementOffset01.dy,
                        child: Obx(
                          () => homeCon.isEditMode01.value == "home"
                              ? GestureDetector(
                                  onPanStart: (details) {
                                    homeCon.startDragOffset =
                                        details.globalPosition;
                                    homeCon.elementStartOffset =
                                        homeCon.elementOffset01.offset;
                                  },
                                  onPanUpdate: (details) =>
                                      homeCon.onPanUpdate(details, context),
                                  onPanEnd: (details) {
                                    homeCon.saveElementPosition();
                                  },
                                  child: Stack(
                                    clipBehavior: Clip
                                        .none, // Stack의 overflow를 허용 (위젯 편집시 x 버튼 overflow 방지)
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              DateFormat('yyyy-MM-dd').format(
                                                authCon
                                                        .coupleInfo
                                                        .value
                                                        ?.coupleData
                                                        ?.firstDay ??
                                                    DateTime.now(),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 9.0,
                                                    color: Colors.black54,
                                                    offset: Offset(1.0, 1.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "${(currentDate.difference(authCon.coupleInfo.value?.coupleData?.firstDay ?? DateTime.now()).inDays + 1).toString()}일",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 40,
                                                shadows: [
                                                  Shadow(
                                                    blurRadius: 9.0,
                                                    color: Colors.black54,
                                                    offset: Offset(1.0, 1.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  authCon.coupleInfo.value?.me
                                                          ?.name ??
                                                      "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 9.0,
                                                        color: Colors.black54,
                                                        offset:
                                                            Offset(1.0, 1.5),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                const Icon(Icons.favorite,
                                                    color: Colors.white,
                                                    size: 18),
                                                const SizedBox(width: 4),
                                                Text(
                                                  authCon.coupleInfo.value
                                                          ?.partner?.name ??
                                                      "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    shadows: [
                                                      Shadow(
                                                        blurRadius: 9.0,
                                                        color: Colors.black54,
                                                        offset:
                                                            Offset(1.0, 1.5),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        right: -6,
                                        top: -6,
                                        child: GestureDetector(
                                          onTap: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.remove("first01Visible");
                                            homeCon.first01Visible.value =
                                                false;
                                          },
                                          child: Icon(
                                            Icons.cancel_rounded,
                                            color: AppColors().grey,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : // 편집 모드 아닐때
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('yyyy-MM-dd').format(
                                          authCon.coupleInfo.value?.coupleData
                                                  ?.firstDay ??
                                              DateTime.now(),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 9.0,
                                              color: Colors.black54,
                                              offset: Offset(1.0, 1.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "${(currentDate.difference(authCon.coupleInfo.value?.coupleData?.firstDay ?? DateTime.now()).inDays + 1).toString()}일",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 40,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 9.0,
                                              color: Colors.black54,
                                              offset: Offset(1.0, 1.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            authCon.coupleInfo.value?.me
                                                    ?.name ??
                                                "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 9.0,
                                                  color: Colors.black54,
                                                  offset: Offset(1.0, 1.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.favorite,
                                              color: Colors.white, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            authCon.coupleInfo.value?.partner
                                                    ?.name ??
                                                "",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 9.0,
                                                  color: Colors.black54,
                                                  offset: Offset(1.0, 1.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    : Container()),

                // #2 위젯
                // // 위젯 드래그
                // Obx(() => homeCon.first02Visible.value
                //     ? Positioned(
                //         left: homeCon.elementOffset02.dx,
                //         top: homeCon.elementOffset02.dy,
                //         child: Obx(
                //           () => homeCon.isEditMode01.value
                //               ? GestureDetector(
                //                   onPanStart: (details) {
                //                     homeCon.startDragOffset =
                //                         details.globalPosition;
                //                     homeCon.elementStartOffset =
                //                         homeCon.elementOffset02.offset;
                //                   },
                //                   onPanUpdate: (details) =>
                //                       homeCon.onPanUpdate(details, context),
                //                   onPanEnd: (details) {
                //                     homeCon.saveElementPosition();
                //                   },
                //                   child: Stack(
                //                     clipBehavior: Clip
                //                         .none, // Stack의 overflow를 허용 (위젯 편집시 x 버튼 overflow 방지)
                //                     children: [
                //                       Container(
                //                         decoration: BoxDecoration(
                //                           border: Border.all(
                //                             color: Colors.white,
                //                           ),
                //                         ),
                //                         child: const Column(
                //                           crossAxisAlignment:
                //                               CrossAxisAlignment.center,
                //                           mainAxisAlignment:
                //                               MainAxisAlignment.center,
                //                           children: [
                //                             Text(
                //                               "365일",
                //                               style: TextStyle(
                //                                 color: Colors.white,
                //                                 fontWeight: FontWeight.bold,
                //                                 fontSize: 28,
                //                                 shadows: [
                //                                   Shadow(
                //                                     blurRadius: 9.0,
                //                                     color: Colors.black54,
                //                                     offset: Offset(1.0, 1.5),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                             SizedBox(height: 4),
                //                             Row(
                //                               mainAxisAlignment:
                //                                   MainAxisAlignment.center,
                //                               children: [
                //                                 Text(
                //                                   "해달",
                //                                   style: TextStyle(
                //                                     color: Colors.white,
                //                                     fontWeight: FontWeight.w500,
                //                                     fontSize: 18,
                //                                     shadows: [
                //                                       Shadow(
                //                                         blurRadius: 9.0,
                //                                         color: Colors.black54,
                //                                         offset:
                //                                             Offset(1.0, 1.5),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ),
                //                                 SizedBox(width: 2),
                //                                 Icon(Icons.favorite,
                //                                     color: Colors.white,
                //                                     size: 18),
                //                                 SizedBox(width: 2),
                //                                 Text(
                //                                   "수달",
                //                                   style: TextStyle(
                //                                     color: Colors.white,
                //                                     fontWeight: FontWeight.w500,
                //                                     fontSize: 18,
                //                                     shadows: [
                //                                       Shadow(
                //                                         blurRadius: 9.0,
                //                                         color: Colors.black54,
                //                                         offset:
                //                                             Offset(1.0, 1.5),
                //                                       ),
                //                                     ],
                //                                   ),
                //                                 ),
                //                               ],
                //                             ),
                //                             SizedBox(height: 4),
                //                             Text(
                //                               "2024.06.23",
                //                               style: TextStyle(
                //                                 color: Colors.white,
                //                                 fontWeight: FontWeight.w500,
                //                                 fontSize: 12,
                //                                 shadows: [
                //                                   Shadow(
                //                                     blurRadius: 9.0,
                //                                     color: Colors.black54,
                //                                     offset: Offset(1.0, 1.5),
                //                                   ),
                //                                 ],
                //                               ),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                       Positioned(
                //                         right: -6,
                //                         top: -6,
                //                         child: GestureDetector(
                //                           onTap: () async {
                //                             SharedPreferences prefs =
                //                                 await SharedPreferences
                //                                     .getInstance();
                //                             prefs.remove("first01Visible");
                //                             homeCon.first01Visible.value =
                //                                 false;
                //                           },
                //                           child: Icon(
                //                             Icons.cancel_rounded,
                //                             color: AppColors().grey,
                //                             size: 30,
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 )
                //               : // 편집 모드 아닐때
                //               Container(
                //                   decoration: BoxDecoration(
                //                     border: Border.all(
                //                       color: Colors.transparent,
                //                     ),
                //                   ),
                //                   child: const Column(
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.center,
                //                     mainAxisAlignment: MainAxisAlignment.center,
                //                     children: [
                //                       Text(
                //                         "365일",
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.bold,
                //                           fontSize: 28,
                //                           shadows: [
                //                             Shadow(
                //                               blurRadius: 9.0,
                //                               color: Colors.black54,
                //                               offset: Offset(1.0, 1.5),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                       SizedBox(height: 4),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.center,
                //                         children: [
                //                           Text(
                //                             "해달",
                //                             style: TextStyle(
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w500,
                //                               fontSize: 18,
                //                               shadows: [
                //                                 Shadow(
                //                                   blurRadius: 9.0,
                //                                   color: Colors.black54,
                //                                   offset: Offset(1.0, 1.5),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                           SizedBox(width: 2),
                //                           Icon(Icons.favorite,
                //                               color: Colors.white, size: 18),
                //                           SizedBox(width: 2),
                //                           Text(
                //                             "수달",
                //                             style: TextStyle(
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w500,
                //                               fontSize: 18,
                //                               shadows: [
                //                                 Shadow(
                //                                   blurRadius: 9.0,
                //                                   color: Colors.black54,
                //                                   offset: Offset(1.0, 1.5),
                //                                 ),
                //                               ],
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                       SizedBox(height: 4),
                //                       Text(
                //                         "2024.06.23",
                //                         style: TextStyle(
                //                           color: Colors.white,
                //                           fontWeight: FontWeight.w500,
                //                           fontSize: 12,
                //                           shadows: [
                //                             Shadow(
                //                               blurRadius: 9.0,
                //                               color: Colors.black54,
                //                               offset: Offset(1.0, 1.5),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //         ),
                //       )
                //     : Container()),
              ],
            );
          },
        );
      },
    );
  }
}
