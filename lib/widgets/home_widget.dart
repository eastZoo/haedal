import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/controller/home_controller.dart';
import 'package:intl/intl.dart';

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
                // 현재 날짜
                DateTime currentDate = DateTime.now();
                // 두 날짜 사이의 차이 계산

                return Stack(
                  children: [
                    // 위젯 드래그
                    if (homeCon.isElementVisible.value)
                      Positioned(
                        left: homeCon.elementOffset.dx,
                        top: homeCon.elementOffset.dy,
                        child: Obx(
                          () => homeCon.isEditMode.value
                              ? GestureDetector(
                                  onPanStart: (details) {
                                    print(details.globalPosition);
                                    homeCon.startDragOffset =
                                        details.globalPosition;
                                    homeCon.elementStartOffset =
                                        homeCon.elementOffset.offset;
                                  },
                                  onPanUpdate: (details) =>
                                      homeCon.onPanUpdate(details, context),
                                  onPanEnd: (details) {
                                    print("onPanEnd $details");
                                    homeCon.saveElementPosition();
                                  },
                                  child: Container(
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
                                            authCon.coupleInfo?.coupleData
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
                                          "${(currentDate.difference(authCon.coupleInfo?.coupleData?.firstDay ?? DateTime.now()).inDays + 1).toString()}일",
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
                                              authCon.coupleInfo?.me?.name ??
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
                                              authCon.coupleInfo?.partner
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
                                          authCon.coupleInfo?.coupleData
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
                                        "${(currentDate.difference(authCon.coupleInfo?.coupleData?.firstDay ?? DateTime.now()).inDays + 1).toString()}일",
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
                                            authCon.coupleInfo?.me?.name ?? "",
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
                                            authCon.coupleInfo?.partner?.name ??
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
                      ),
                  ],
                );
              });
        });
  }
}
