import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/select_color_screen.dart';
import 'package:haedal/service/controller/map_controller.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/styles/app_style.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/date_time_widget.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/textfield_widget.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  DateTime initalStartDay = DateTime.now();
  DateTime initalEndDay = DateTime.now();

  TimeOfDay initalStartTime = TimeOfDay.now();
  TimeOfDay initalEndTime = TimeOfDay.now();

  String errorMsg = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      startTodoDayController.text = "$selectedDay".split(".")[0];
      startTodoTimeController.text = TimeOfDay.now().toString();

      endTodoDayController.text = "$selectedDay".split(".")[0];
      endTodoTimeController.text = TimeOfDay.now().toString();
    });
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
        child: Container(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                        };

                        print(dataSource);
                        var res = await scheduleCon.scheduleSubmit(dataSource);
                        setState(() {
                          isLoading = false;
                        });
                        if (res) {
                          scheduleCon.refetchDataSource();
                          Navigator.pop(context);
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
                const Text(
                  "할 일",
                  style: AppStyle.headingOne,
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
                    const Row(
                      children: [
                        Icon(Icons.note_alt_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('메모', style: AppStyle.headingOne),
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
                    const Row(
                      children: [
                        Icon(Icons.history_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('종일', style: AppStyle.headingOne),
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
                          const Text(
                            '시작',
                            style: AppStyle.headingOne,
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
                                    initialDate: DateTime.now(),
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
                          // end time
                          const Text(
                            '종료',
                            style: AppStyle.headingOne,
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
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime(2100),
                                  );

                                  if (picked != initalEndDay &&
                                      picked != null) {
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
                                    initialTime:
                                        initalEndTime ?? TimeOfDay.now(),
                                  );
                                  if (picked != initalEndTime &&
                                      picked != null) {
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
                    print(result);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const SizedBox(
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.color_lens_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text('라벨컬러', style: AppStyle.headingOne),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_sharp),
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
      ),
    );
  }
}
