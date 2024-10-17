import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/label_colorpicker.dart';
import 'package:haedal/widgets/label_textfield.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/my_button.dart';

class AddMemoCategoryScreen extends StatefulWidget {
  const AddMemoCategoryScreen({super.key});

  @override
  State<AddMemoCategoryScreen> createState() => _AddMemoCategoryScreenState();
}

class _AddMemoCategoryScreenState extends State<AddMemoCategoryScreen> {
  _AddMemoCategoryScreenState();

  final categoryTextController = TextEditingController();
  final titleTextController = TextEditingController();
  final memoCon = Get.put(MemoController());
  String errorMsg = "";

  bool isLoading = false;

  Color selectedColor = AppColors().pickerBlue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
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
                      controller: categoryTextController,
                      fillColor: AppColors().toDoGrey,
                    ),
                    const Gap(15),
                    LabelTextField(
                      label: '제목',
                      hintText: "함께하고자 하는 위시를 적어주세요",
                      controller: titleTextController,
                      fillColor: AppColors().toDoGrey,
                    ),
                    const Gap(15),
                    CustomBlockPicker(
                      label: "색상 선택",
                      currentColor: selectedColor,
                      onColorChanged: (Color color) {
                        setState(() {
                          selectedColor = color;
                        });
                        print(selectedColor);
                      },
                      availableColors: [
                        AppColors().pickerBlue,
                        AppColors().pickerRed,
                        AppColors().pickerOrange,
                        AppColors().pickerYellow,
                        AppColors().pickerGreen,
                        AppColors().pickerPurple,
                        AppColors().pickerblack,
                      ],
                      colorsPerRow: 7,
                      blockWidth: 60.0,
                      blockHeight: 60.0,
                    ),
                    const Gap(15),
                    MyButton(
                      onTap: () async {
                        /** 1. 유효성 검증  */
                        if (categoryTextController.text.isEmpty) {
                          setState(() {
                            errorMsg = "카테고리를 입력해주세요.";
                          });
                          return CustomToast().alert(errorMsg);
                        }
                        if (titleTextController.text.isEmpty) {
                          setState(() {
                            errorMsg = "항목을 입력해주세요.";
                          });
                          return CustomToast().alert(errorMsg);
                        }

                        /** 2. 로딩 값 변경  */
                        setState(() {
                          isLoading = true;
                        });
                        /** 3. 데이터 송신  */

                        var dataSource = {
                          "category": categoryTextController.text,
                          "title": titleTextController.text,
                          "color": selectedColor.value
                              .toRadixString(16)
                              .padLeft(8, '0')
                              .toUpperCase()
                              .substring(2),
                        };

                        print("dataSource : $dataSource");
                        var result =
                            await memoCon.createMemoCategory(dataSource);
                        if (result) {
                          setState(() {
                            isLoading = false;
                          });
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
      ),
    );
  }
}
