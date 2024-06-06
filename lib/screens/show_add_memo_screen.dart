import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_schedule_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/calendar_widget.dart';
import 'package:haedal/widgets/label_textfield.dart';
import 'package:haedal/widgets/my_button.dart';
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(5),
            Center(
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
            const Center(
              child: Text("투두 카테고리 추가"),
            ),
            const Gap(12),
            Expanded(
              child: ListView(
                children: [
                  LabelTextField(
                    label: '카테고리',
                    hintText: "카테고리 이름",
                    controller: memoTextController,
                    fillColor: AppColors().toDoGrey,
                  ),
                  const Gap(30),
                  MyButton(
                    onTap: () async {
                      if (memoTextController.text.isEmpty) {
                        setState(() {
                          errorMsg = "제목을 입력해주세요.";
                        });
                        return CustomToast().alert(errorMsg);
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
                    title: "저장",
                    available: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
