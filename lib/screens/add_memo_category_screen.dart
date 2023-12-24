import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/models/label-color.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/service/controller/schedule_controller.dart';
import 'package:haedal/utils/toast.dart';
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
  final memoCon = Get.put(MemoController());
  String errorMsg = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Text("투두 카테고리 추가"),
        ),
        const Gap(12),
        Expanded(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: renderTextFormField(
                label: '카테고리',
                hintText: "카테고리 이름",
                controller: categoryTextController,
              ),
            ),
            const Gap(20),
            MyButton(
              onTap: () async {
                if (categoryTextController.text.isEmpty) {
                  setState(() {
                    errorMsg = "카테고리를 입력해주세요.";
                  });
                  return CustomToast().signUpToast(errorMsg);
                }
                var dataSource = {
                  "category": categoryTextController.text,
                };

                var result = await memoCon.createMemoCategory(dataSource);
                if (result) {
                  Navigator.pop(context);
                }
                print("result:  : $result");
              },
              title: "저장",
              available: true,
            )
          ],
        )),
      ],
    );
  }

  renderTextFormField(
      {final String label = "",
      final controller,
      final focusNode,
      final multiLine = false,
      required hintText,
      readOnly = false,
      Function()? onTap}) {
    return Column(
      children: [
        Row(
          children: [
            label.isNotEmpty
                ? Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        multiLine
            ? Container(
                margin: const EdgeInsets.all(12),
                height: 5 * 24.0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  maxLines: multiLine ? 5 : 1,
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
              )
            : TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: readOnly,
                onTap: onTap,
                maxLines: multiLine ? null : 1,
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    filled: true,
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey[500])),
              )
      ],
    );
  }
}
