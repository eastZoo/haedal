import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/loading_overlay.dart';

class SelectColorScreen extends StatefulWidget {
  const SelectColorScreen({super.key});

  @override
  State<SelectColorScreen> createState() => _SelectColorScreenState();
}

class _SelectColorScreenState extends State<SelectColorScreen> {
  _SelectColorScreenState();
  String chosenColor = "";
  String chosenId = "";
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    getColor();
    // 컨트롤러의 색상 데이터 로드
    Get.find<ScheduleController>().getCalendarLabelColor();
  }

  // 초기 로딩시 로컬스토리지에 색데이터 있는지 확인후 있다면 디폴트 세팅
  getColor() async {
    final dataString = await storage.read(key: "color");

    if (dataString != null) {
      Map<String, dynamic> jsonData = json.decode(dataString);

      LabelColor localColor = LabelColor.fromJson(jsonData);

      setState(() {
        chosenId = localColor.id;
        chosenColor = localColor.code;
      });

      return;
    }
    print("NO COLOR DATA");
    return;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
        init: ScheduleController(),
        builder: (scheduleCon) {
          // 로딩 상태 확인
          if (scheduleCon.colors.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return LoadingOverlay(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(5),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "캘린더 라벨 색상",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors().mainColor,
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: scheduleCon.colors.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Map<String, dynamic> dataSource = {
                              'code': scheduleCon.colors[index].code,
                              'name': scheduleCon.colors[index].name,
                              'id': scheduleCon.colors[index].id
                            };

                            // json 형태로 인코딩해서 로컬스토리지에 저장
                            final jsonString = jsonEncode(dataSource);

                            setState(() {
                              chosenColor = scheduleCon.colors[index].code;
                              chosenId = scheduleCon.colors[index].id;
                            });

                            Navigator.pop(context, jsonString);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        "0xFF${scheduleCon.colors[index].code}")),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const Gap(16),
                                Expanded(
                                  child: Text(
                                    scheduleCon.colors[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Radio(
                                  value: scheduleCon.colors[index].id,
                                  groupValue: chosenId,
                                  activeColor: AppColors().mainColor,
                                  onChanged: (value) {
                                    setState(() {
                                      chosenId = scheduleCon.colors[index].id;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
