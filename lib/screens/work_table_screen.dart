import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/widgets/custom_app_bar.dart';
import 'package:haedal/widgets/date_time_widget.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/endpoints.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWorkTabelUrl();
  }

  // 이미지 여러개 불러오기
  void getOneImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }
    setState(() {
      _pickedImages = pickedFile;
    });
    // scheduleCon.workTableSubmit();
    print(_pickedImages);
  }

  getCurrentWorkTabelUrl() {
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${initalStartDay.month.toString()}");
  }

  void prevMonth() {
    setState(() {
      initalStartDay = initalStartDay.subtract(const Duration(days: 29));
    });
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${initalStartDay.month.toString()}");
  }

  void forwardMonth() {
    setState(() {
      initalStartDay = initalStartDay.add(const Duration(days: 29));
    });
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${initalStartDay.month.toString()}");
  }

  void getCurrentMonth() {
    setState(() {
      initalStartDay = DateTime.now();
    });
    scheduleCon.getCurrentWorkTableUrl(
        "${initalStartDay.year.toString()}-${initalStartDay.month.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
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
                      ? Container(
                          child: Column(
                            children: [
                              Center(
                                child: Hero(
                                  tag:
                                      "${Endpoints.hostUrl}/${ScheduleCon.currentWorkTableUrl?.workScheduleFile?.first.filename}",
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Endpoints.hostUrl}/${ScheduleCon.currentWorkTableUrl?.workScheduleFile?.first.filename}",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
        });
  }
}
