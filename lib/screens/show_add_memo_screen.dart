import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_schedule_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/calendar_widget.dart';
import 'package:haedal/widgets/textfield_widget.dart';
import 'package:intl/intl.dart';

class ShowAddMemoScreen extends StatefulWidget {
  ShowAddMemoScreen({super.key});
  DateTime? selectedDay;
  List<Meeting>? appointments;

  @override
  State<ShowAddMemoScreen> createState() => _ShowAddMemoScreenState();
}

class _ShowAddMemoScreenState extends State<ShowAddMemoScreen> {
  _ShowAddMemoScreenState();

  MemoController memoCon = Get.put(MemoController());

  TextEditingController memoTextController = TextEditingController();

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black,
      fontSize: 20,
    );

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            heightFactor: 0.7,
            child: Container(
              width: 50,
              height: 3,
              margin: const EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.grey.shade400,
              ),
            ),
          ),
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
                  if (memoTextController.text.isEmpty) {
                    setState(() {
                      errorMsg = "제목을 입력해주세요.";
                    });
                    return CustomToast().signUpToast(errorMsg);
                  }

                  var dataSource = {
                    "memo": memoTextController.text,
                    "categoryId": memoCon.currentMemo?.id
                  };

                  var res = await memoCon.createMemo(dataSource);

                  if (res) {
                    memoCon.reload();
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "할 일",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.end,
                ),
                const Gap(6),
                TextFieldWidget(
                  controller: memoTextController,
                  maxLine: 1,
                  hintText: "Title",
                ),
                const Gap(15),
                const SizedBox(height: 20.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
