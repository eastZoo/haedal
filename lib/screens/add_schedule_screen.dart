import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/screens/select_color_screen.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/date_time_widget.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/textfield_widget.dart';

class AddScheduleScreen extends StatefulWidget {
  DateTime? selectedDay;
  AddScheduleScreen({super.key, required this.selectedDay});

  @override
  State<AddScheduleScreen> createState() =>
      _AddScheduleScreenState(selectedDay);
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  _AddScheduleScreenState(this.selectedDay);

  ScheduleController scheduleCon = Get.put(ScheduleController());

  DateTime? selectedDay;
  bool _isMemoChecked = false;
  bool _isDateChecked = true;

  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();
// 일정 시작 날짜
  final startTodoDayController = TextEditingController();
  // 일정 시작 시간
  final startTodoTimeController = TextEditingController();
  // 일정 종료 날짜
  final endTodoDayController = TextEditingController();
  // 일정 종료 시간
  final endTodoTimeController = TextEditingController();

  // label color
  String chosenColorCode = "0xff8468A0";

  DateTime initalStartDay = DateTime.now();
  DateTime initalEndDay = DateTime.now();

  TimeOfDay initalStartTime = TimeOfDay.now();
  TimeOfDay initalEndTime = TimeOfDay.now();

  String errorMsg = "";
  bool isLoading = false;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startTodoDayController.text = "$selectedDay".split(".")[0];
      startTodoTimeController.text = TimeOfDay.now().toString();
      initalStartDay = DateTime.parse(selectedDay.toString()).toLocal();

      endTodoDayController.text = "$selectedDay".split(".")[0];
      endTodoTimeController.text = TimeOfDay.now().toString();
      initalEndDay = DateTime.parse(selectedDay.toString()).toLocal();
    });
    getColor();
  }

  // 초기 로딩시 로컬스토리지에 색데이터 있는지 확인후 있다면 디폴트 세팅
  getColor() async {
    final dataString = await storage.read(key: "color");
    if (dataString != null) {
      Map<String, dynamic> jsonData = json.decode(dataString);

      LabelColor localColor = LabelColor.fromJson(jsonData);

      setState(() {
        chosenColorCode = localColor.code;
      });

      return;
    }
    print("NO COLOR DATA");
    return;
  }

  // 색깔 고르는 바텀시트
  _showColorPicker() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.65,
          minChildSize: 0.6,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: const Scaffold(
                body: SelectColorScreen(),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const SizedBox(
                      width: 40,
                      child: Icon(
                        Icons.close,
                        size: 24,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      if (titleTextController.text.isEmpty) {
                        setState(() {
                          errorMsg = "제목을 입력해주세요.";
                        });
                        return CustomToast().signUpToast(errorMsg);
                      }
                      if (DateTime.parse(endTodoDayController.text).isBefore(
                          DateTime.parse(startTodoDayController.text))) {
                        setState(() {
                          errorMsg = "시작 날짜가 종료날짜보다 이전 날짜일 수 없습니다.";
                        });
                        return CustomToast().signUpToast(errorMsg);
                      }

                      // 데이터 통신 전 로딩 상태 변경
                      setState(() {
                        isLoading = true;
                      });

                      // 등록 데이터 모델
                      // 종일 체크 시 시작 && 끝 날자 선택 오늘 날짜로 디폴트 들어감
                      Map<String, dynamic> dataSource = {
                        "title": titleTextController.text,
                        "content": contentTextController.text.isEmpty
                            ? null
                            : contentTextController.text,
                        "allDay": _isDateChecked,
                        "startDate": _isDateChecked
                            ? "${startTodoDayController.text.split(' ')[0]} "
                            : "${startTodoDayController.text.split(' ')[0]} ${startTodoTimeController.text.substring(10, 15)}:00",
                        "endDate": _isDateChecked
                            ? endTodoDayController.text.split(' ')[0]
                            : "${endTodoDayController.text.split(' ')[0]} ${endTodoTimeController.text.substring(10, 15)}:00",
                        "color": chosenColorCode
                      };

                      var res = await scheduleCon.scheduleSubmit(dataSource);
                      setState(() {
                        isLoading = false;
                      });
                      if (res) {
                        scheduleCon.refetchDataSource();
                        Navigator.pop(context, true);
                      }
                    },
                    child: const SizedBox(
                        width: 60,
                        height: 40,
                        child: Center(
                          child: Text(
                            "저장",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                  )
                ],
              ),

              const Gap(12),
              // 제목
              Text(
                "할 일",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(
                    int.parse(chosenColorCode),
                  ),
                ),
                textAlign: TextAlign.end,
              ),
              const Gap(6),
              TextFieldWidget(
                controller: titleTextController,
                maxLine: 1,
                hintText: "Title",
              ),
              const Gap(15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        color: Color(
                          int.parse(chosenColorCode),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '메모',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(
                            int.parse(chosenColorCode),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: _isMemoChecked,
                    activeColor: AppColors().mainColor,
                    onChanged: (bool? value) {
                      setState(() {
                        _isMemoChecked = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const Gap(6),
              _isMemoChecked
                  ? TextFieldWidget(
                      controller: contentTextController,
                      maxLine: 3,
                      hintText: '메모를 적어주세요.')
                  : const SizedBox(),
              const Gap(12),
              // 날짜 범위 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history_outlined,
                        color: Color(
                          int.parse(chosenColorCode),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '종일',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(
                            int.parse(chosenColorCode),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: _isDateChecked,
                    activeColor: AppColors().mainColor,
                    onChanged: (bool? value) {
                      setState(() {
                        _isDateChecked = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const Gap(10),
              // 날짜 섹션
              !_isDateChecked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Gap(15),
                        Text(
                          '시작',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(
                              int.parse(chosenColorCode),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateTimeWidget(
                              valueText:
                                  initalStartDay.toString().split(" ")[0] ??
                                      'dd/mm/yy',
                              iconSection: CupertinoIcons.calendar,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.parse(selectedDay.toString())
                                          .toLocal(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2100),
                                );

                                if (picked != initalStartDay &&
                                    picked != null) {
                                  setState(() {
                                    initalStartDay = picked;
                                    startTodoDayController.text =
                                        "${picked.toLocal()}";
                                  });
                                }
                              },
                            ),
                            const Gap(20),
                            DateTimeWidget(
                              valueText:
                                  "${initalStartTime.hour}:${initalStartTime.minute}" ??
                                      'hh : mm',
                              iconSection: CupertinoIcons.clock,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      initalStartTime ?? TimeOfDay.now(),
                                );
                                if (picked != initalStartTime &&
                                    picked != null) {
                                  setState(() {
                                    initalStartTime = picked;
                                    startTodoTimeController.text = "$picked";
                                  });

                                  print("TIME ::: $picked");
                                }
                              },
                            )
                          ],
                        ),
                        const Gap(15),
                        // end time
                        Text(
                          '종료',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(
                              int.parse(chosenColorCode),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateTimeWidget(
                              valueText:
                                  initalEndDay.toString().split(" ")[0] ??
                                      'dd/mm/yy',
                              iconSection: CupertinoIcons.calendar,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.parse(selectedDay.toString())
                                          .toLocal(),
                                  firstDate: DateTime(2021),
                                  lastDate: DateTime(2100),
                                );

                                if (picked != initalEndDay && picked != null) {
                                  setState(() {
                                    initalEndDay = picked;
                                    endTodoDayController.text =
                                        "${picked.toLocal()}";
                                  });
                                }
                              },
                            ),
                            const Gap(20),
                            DateTimeWidget(
                              valueText:
                                  "${initalEndTime.hour}:${initalEndTime.minute}" ??
                                      'hh : mm',
                              iconSection: CupertinoIcons.clock,
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: initalEndTime ?? TimeOfDay.now(),
                                );
                                if (picked != initalEndTime && picked != null) {
                                  setState(() {
                                    initalEndTime = picked;
                                    endTodoTimeController.text = "$picked";
                                  });

                                  print("TIME ::: $picked");
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Gap(10),
              InkWell(
                onTap: () async {
                  var result = await _showColorPicker();
                  print("_showColorPicker : $result");
                  // 컬러 리스트에 들어갔다가 아무것도 고르지 않고 나오는 경우를 제외한
                  if (result != null) {
                    var decode = json.decode(result);

                    setState(() {
                      chosenColorCode = decode["code"];
                    });
                    await storage.write(key: "color", value: result);
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.color_lens_outlined,
                            color: Color(
                              int.parse(chosenColorCode),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '라벨컬러',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(
                                int.parse(chosenColorCode),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Color(
                          int.parse(chosenColorCode),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(10),
              Center(
                heightFactor: 2,
                child: Image.asset(
                  "assets/icons/clipboard.png",
                  height: 80,
                  width: 80,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
