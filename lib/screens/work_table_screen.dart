import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/widgets/custom_app_bar.dart';
import 'package:haedal/widgets/date_time_widget.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/endpoints.dart';
import 'package:path/path.dart' hide context;

class WorkTableScreen extends StatefulWidget {
  const WorkTableScreen({super.key});

  @override
  State<WorkTableScreen> createState() => _WorkTableScreenState();
}

class _WorkTableScreenState extends State<WorkTableScreen> {
  DateTime initalStartDay = DateTime.now();
  final scheduleCon = Get.put(ScheduleController());

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImages;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWorkTabelUrl();
  }

  // 이미지 불러오기
  void getOneImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    setState(() {
      isLoading = true;
      _pickedImages = pickedFile;
    });
    Map<String, dynamic> requestData = {};
    var images = [];

    images.add(
      await MultipartFile.fromFile(
        _pickedImages!.path,
        filename: basename(_pickedImages!.path),
      ),
    );
    var dataSource = {
      "workMonth": initalStartDay.toString(),
    };
    requestData["postData"] = json.encode(dataSource);
    requestData["images"] = images;

    var res = await scheduleCon.workTableSubmit(requestData);
    setState(() {
      isLoading = false;
    });

    if (res) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => scheduleCon.getCurrentWorkTableUrl(
            "${initalStartDay.year.toString()}-${getFormattedMonth(initalStartDay.month)}"),
      );
    }

    // print(_pickedImages);
  }

  String getFormattedMonth(int month) {
    // Add a leading zero if the month is less than 10
    return month < 10 ? '0$month' : '$month';
  }

  getCurrentWorkTabelUrl() {
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${getFormattedMonth(initalStartDay.month)}");
  }

  void prevMonth() {
    setState(() {
      initalStartDay = initalStartDay.subtract(const Duration(days: 29));
    });
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${getFormattedMonth(initalStartDay.month)}");
  }

  void forwardMonth() {
    setState(() {
      initalStartDay = initalStartDay.add(const Duration(days: 29));
    });
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${getFormattedMonth(initalStartDay.month)}");
  }

  void getCurrentMonth() {
    setState(() {
      initalStartDay = DateTime.now();
    });
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${getFormattedMonth(initalStartDay.month)}");
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: GetBuilder<ScheduleController>(
          init: ScheduleController(),
          builder: (ScheduleCon) {
            return Scaffold(
                appBar: CustomAppbar(title: "근무표"),
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            prevMonth();
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.grey,
                          ),
                        ),
                        DateTimeWidget(
                          valueText:
                              "${initalStartDay.year}년 ${initalStartDay.month}월",
                          iconSection: CupertinoIcons.calendar,
                          onTap: () async {
                            getCurrentMonth();
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            forwardMonth();
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    ScheduleCon.currentWorkTableUrl != null
                        ? Column(
                            children: [
                              Center(
                                child: Hero(
                                  tag:
                                      "${Endpoints.hostUrl}/${ScheduleCon.currentWorkTableUrl?.workScheduleFile?.first.filename}",
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Endpoints.hostUrl}/${ScheduleCon.currentWorkTableUrl?.workScheduleFile?.first.filename}",
                                    fit: BoxFit.cover,
                                    height:
                                        MediaQuery.of(context).size.width * 1.5,
                                  ),
                                ),
                              ),
                              Container(
                                child: MyButton(
                                  title: "삭제하기",
                                  onTap: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    var res = await scheduleCon.deleteWorkTable(
                                        ScheduleCon.currentWorkTableUrl!.id);

                                    print("DELETE $res");
                                    if (res) {
                                      Future.delayed(
                                        const Duration(microseconds: 100),
                                        () => scheduleCon.getCurrentWorkTableUrl(
                                            "${initalStartDay.year.toString()}-${getFormattedMonth(initalStartDay.month)}"),
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  available: true,
                                ),
                              )
                            ],
                          )
                        : Container(
                            child: MyButton(
                              title: "근무표 업로드",
                              onTap: () {
                                getOneImage();
                              },
                              available: true,
                            ),
                          )
                  ],
                ));
          }),
    );
  }
}
