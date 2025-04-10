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
import 'package:haedal/widgets/label_textfield.dart';
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
  String chosenColorCode = "8468A0";

  DateTime initalStartDay = DateTime.now();
  DateTime initalEndDay = DateTime.now();

  TimeOfDay initalStartTime = TimeOfDay.now();
  TimeOfDay initalEndTime = TimeOfDay.now();

  String errorMsg = "";
  bool isLoading = false;

  final storage = const FlutterSecureStorage();

  // 공통으로 사용할 그림자 스타일
  final BoxShadow commonShadow = BoxShadow(
    color: Colors.black.withOpacity(0.08),
    offset: const Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );

  @override
  void initState() {
    super.initState();

    // 현재 시간의 분을 5의 배수로 조정
    final now = DateTime.now();
    final adjustedTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      (now.minute ~/ 5) * 5,
    );

    setState(() {
      startTodoDayController.text = "$selectedDay".split(".")[0];
      startTodoTimeController.text =
          TimeOfDay.fromDateTime(adjustedTime).toString();
      initalStartDay = DateTime.parse(selectedDay.toString()).toLocal();
      initalStartTime = TimeOfDay.fromDateTime(adjustedTime);

      endTodoDayController.text = "$selectedDay".split(".")[0];
      endTodoTimeController.text =
          TimeOfDay.fromDateTime(adjustedTime).toString();
      initalEndDay = DateTime.parse(selectedDay.toString()).toLocal();
      initalEndTime = TimeOfDay.fromDateTime(adjustedTime);
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
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: const SelectColorScreen(),
          ),
        ),
      ),
    );
  }

  // _showIOSDateTimePicker 메서드 수정
  void _showIOSDateTimePicker({
    required BuildContext context,
    required DateTime initialDateTime,
    required Function(DateTime) onDateTimeChanged,
    bool dateOnly = false,
  }) {
    // 초기 시간의 분을 5의 배수로 조정
    final adjustedDateTime = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day,
      initialDateTime.hour,
      (initialDateTime.minute ~/ 5) * 5, // 5의 배수로 내림
    );

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 280,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors().white,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors().lightGrey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        '취소',
                        style: TextStyle(
                          color: Color(int.parse("0xFF$chosenColorCode")),
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Text(
                        '완료',
                        style: TextStyle(
                          color: Color(int.parse("0xFF$chosenColorCode")),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        onDateTimeChanged(initialDateTime);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: dateOnly
                      ? CupertinoDatePickerMode.date
                      : CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: adjustedDateTime, // 조정된 시간 사용
                  onDateTimeChanged: (DateTime newDateTime) {
                    initialDateTime = newDateTime;
                  },
                  use24hFormat: true,
                  minuteInterval: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitSchedule() async {
    if (titleTextController.text.isEmpty) {
      setState(() {
        errorMsg = "제목을 입력해주세요.";
      });
      return CustomToast().alert(errorMsg);
    }

    // 종일이 아닐 때만 날짜 범위 검증
    if (!_isDateChecked) {
      // DateTime 객체로 시작 시간과 종료 시간 생성
      final startDateTime = DateTime(
        initalStartDay.year,
        initalStartDay.month,
        initalStartDay.day,
        initalStartTime.hour,
        initalStartTime.minute,
      );

      final endDateTime = DateTime(
        initalEndDay.year,
        initalEndDay.month,
        initalEndDay.day,
        initalEndTime.hour,
        initalEndTime.minute,
      );

      // 정확한 DateTime 비교
      if (endDateTime.isBefore(startDateTime)) {
        setState(() {
          errorMsg = "종료 시간이 시작 시간보다 빠를 수 없습니다.";
        });
        return CustomToast().alert(errorMsg);
      }
    }

    // 데이터 통신 전 로딩 상태 변경
    setState(() {
      isLoading = true;
    });

    // 등록 데이터 모델
    Map<String, dynamic> dataSource = {
      "title": titleTextController.text,
      "content": contentTextController.text.isEmpty
          ? null
          : contentTextController.text,
      "allDay": _isDateChecked,
      "startDate": _isDateChecked
          ? "${startTodoDayController.text.split(' ')[0]} 00:00:00"
          : "${startTodoDayController.text.split(' ')[0]} ${startTodoTimeController.text.substring(10, 15)}:00",
      "endDate": _isDateChecked
          ? "${endTodoDayController.text.split(' ')[0]} 00:00:00"
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(int.parse("0xFF$chosenColorCode")),
            size: 22,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '일정 추가',
          style: TextStyle(
            color: Color(int.parse("0xFF$chosenColorCode")),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () => _submitSchedule(),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor:
                    Color(int.parse("0xFF$chosenColorCode")).withOpacity(0.1),
              ),
              child: Text(
                '저장',
                style: TextStyle(
                  color: Color(int.parse("0xFF$chosenColorCode")),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LoadingOverlay(
          isLoading: isLoading,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 제목 입력 필드
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                '할 일',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Color(int.parse("0xFF$chosenColorCode")),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors().toDoGrey,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [commonShadow],
                              ),
                              child: TextField(
                                controller: titleTextController,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                cursorColor:
                                    Color(int.parse("0xFF$chosenColorCode")),
                                decoration: InputDecoration(
                                  hintText: "할 일을 입력해주세요",
                                  hintStyle: TextStyle(
                                    color:
                                        AppColors().darkGrey.withOpacity(0.5),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),

                        // 메모 섹션
                        _buildSectionHeader(
                          icon: Icons.note_alt_outlined,
                          title: '메모',
                          trailing: CupertinoSwitch(
                            value: _isMemoChecked,
                            activeTrackColor:
                                Color(int.parse("0xFF$chosenColorCode")),
                            onChanged: (value) =>
                                setState(() => _isMemoChecked = value),
                          ),
                        ),
                        if (_isMemoChecked) ...[
                          const Gap(16),
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors().toDoGrey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [commonShadow],
                            ),
                            child: TextField(
                              controller: contentTextController,
                              maxLines: 5,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              cursorColor:
                                  Color(int.parse("0xFF$chosenColorCode")),
                              decoration: InputDecoration(
                                hintText: "메모를 입력해주세요",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                        const Gap(24),

                        // 종일 섹션
                        _buildSectionHeader(
                          icon: Icons.access_time_rounded,
                          title: '종일',
                          trailing: CupertinoSwitch(
                            value: _isDateChecked,
                            activeTrackColor:
                                Color(int.parse("0xFF$chosenColorCode")),
                            onChanged: (value) {
                              setState(() {
                                _isDateChecked = value;
                                if (value) {
                                  // 종일 체크 시 시작/종료 시간을 00:00:00으로 설정
                                  final startDate = DateTime(
                                    initalStartDay.year,
                                    initalStartDay.month,
                                    initalStartDay.day,
                                    0,
                                    0,
                                    0,
                                  );
                                  final endDate = DateTime(
                                    initalEndDay.year,
                                    initalEndDay.month,
                                    initalEndDay.day,
                                    0,
                                    0,
                                    0,
                                  );

                                  initalStartDay = startDate;
                                  initalEndDay = endDate;
                                  initalStartTime =
                                      const TimeOfDay(hour: 0, minute: 0);
                                  initalEndTime =
                                      const TimeOfDay(hour: 0, minute: 0);

                                  startTodoDayController.text =
                                      startDate.toString();
                                  endTodoDayController.text =
                                      endDate.toString();
                                  startTodoTimeController.text =
                                      const TimeOfDay(hour: 0, minute: 0)
                                          .toString();
                                  endTodoTimeController.text =
                                      const TimeOfDay(hour: 0, minute: 0)
                                          .toString();
                                }
                              });
                            },
                          ),
                        ),

                        if (!_isDateChecked) ...[
                          const Gap(16),
                          _buildDateTimeSection(
                            title: '시작',
                            date: initalStartDay,
                            time: initalStartTime,
                            onDateTap: () {},
                            onTimeTap: () {},
                          ),
                          _buildDateTimeSection(
                            title: '종료',
                            date: initalEndDay,
                            time: initalEndTime,
                            onDateTap: () {},
                            onTimeTap: () {},
                          ),
                        ],

                        const Gap(24),

                        // 라벨 컬러 선택
                        InkWell(
                          onTap: () async {
                            var result = await _showColorPicker();
                            if (result != null) {
                              var decode = json.decode(result);
                              setState(() {
                                chosenColorCode = decode["code"];
                              });
                              await storage.write(key: "color", value: result);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors().toDoGrey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  offset: const Offset(0, 4),
                                  blurRadius: 12,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.color_lens_outlined,
                                      color: Color(
                                          int.parse("0xFF$chosenColorCode")),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '라벨 컬러',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(
                                            int.parse("0xFF$chosenColorCode")),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Color(
                                        int.parse("0xFF$chosenColorCode")),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors().toDoGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Color(int.parse("0xFF$chosenColorCode")),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(int.parse("0xFF$chosenColorCode")),
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildDateTimeSection({
    required String title,
    required DateTime date,
    required TimeOfDay time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(int.parse("0xFF$chosenColorCode")),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors().toDoGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors().lightGrey.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  _showIOSDateTimePicker(
                    context: context,
                    initialDateTime: DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        if (title == '시작') {
                          initalStartDay = newDateTime;
                          initalStartTime = TimeOfDay.fromDateTime(newDateTime);
                          startTodoDayController.text = newDateTime.toString();
                          startTodoTimeController.text =
                              TimeOfDay.fromDateTime(newDateTime).toString();
                        } else {
                          initalEndDay = newDateTime;
                          initalEndTime = TimeOfDay.fromDateTime(newDateTime);
                          endTodoDayController.text = newDateTime.toString();
                          endTodoTimeController.text =
                              TimeOfDay.fromDateTime(newDateTime).toString();
                        }
                      });
                    },
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        color: Color(int.parse("0xFF$chosenColorCode")),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "${date.year}년 ${date.month}월 ${date.day}일 ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors().darkGrey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
