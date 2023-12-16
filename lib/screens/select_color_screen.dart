import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
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
    // TODO: implement initState
    super.initState();

    getColor();
  }

  getColor() async {
    final dataString = await storage.read(key: "color");

    print(dataString);
    print(dataString.runtimeType);
    if (dataString != null) {
      // Convert the string data to a map
      Map<String, dynamic> jsonData = json.decode(dataString);

      // Create an object from the map
      LabelColor myObject = LabelColor.fromJson(jsonData);

      // Access the properties of the object
      print('Code: ${myObject.code}');
      print('Name: ${myObject.name}');
      print('ID: ${myObject.id}');
    }

    // setState(() {
    //   chosenColor = value.code.toString();
    //                         chosenId = value.id;
    // });
    // print("########## $value");
    // print("########## ${myObject.code}");
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
        init: ScheduleController(),
        builder: (scheduleCon) {
          return LoadingOverlay(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(5),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 5),
                    child: Center(
                      heightFactor: 0.7,
                      child: Container(
                        width: 50,
                        height: 3,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.5),
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text("캘린더 라벨 색상 리스트"),
                  ),
                  const Gap(12),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: scheduleCon.colors.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Map<String, dynamic> dataSource = {
                            'code': scheduleCon.colors[index].code,
                            'name': scheduleCon.colors[index].name,
                            'id': scheduleCon.colors[index].id
                          };

                          final jsonString = jsonEncode(dataSource);

                          setState(() {
                            chosenColor = scheduleCon.colors[index].code;
                            chosenId = scheduleCon.colors[index].id;
                          });

                          Navigator.pop(context, jsonString);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                            width: double.infinity,
                            height: 55,
                            child: Row(
                              children: [
                                // 왼쪽 라벨 색깔
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(int.parse(
                                        scheduleCon.colors[index].code)),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  width: 6,
                                  height: 25,
                                ),

                                // 라벨을 제외한 컨텐츠 박스
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 2, 8, 2),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${scheduleCon.colors[index].name}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Radio(
                                          value: scheduleCon.colors[index].id,
                                          groupValue: chosenId,
                                          onChanged: (value) {
                                            setState(() {
                                              chosenId =
                                                  scheduleCon.colors[index].id;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
