import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:haedal/styles/colors.dart';

class LabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool multiLine;
  final String hintText;
  final bool readOnly;
  final Color? fillColor;
  final Function()? onTap;

  const LabelTextField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.multiLine = false,
    required this.hintText,
    this.readOnly = false,
    this.fillColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label.isNotEmpty)
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors().darkGreyText),
              ),
            ],
          ),
        const Gap(8),
        multiLine
            ? Container(
                margin: const EdgeInsets.all(12),
                height: 5 * 10.0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  maxLines: multiLine ? 5 : 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: fillColor ?? AppColors().white,
                    filled: true,
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              )
            : SizedBox(
                height: 3 * 14.0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  maxLines: multiLine ? null : 1,
                  textDirection: TextDirection.ltr,
                  cursorHeight: 30,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: fillColor ?? AppColors().white, // 배경색을 빨간색으로 설정
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none, // 기본 border 색상 없애기
                      borderRadius:
                          BorderRadius.circular(5), // border radius를 10으로 설정
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: hintText,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ),
              )
      ],
    );
  }
}
