import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:haedal/styles/colors.dart';

class LabelTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool multiLine;
  final String? hintText;
  final bool readOnly;
  final Color? fillColor;
  final Function()? onTap;
  final bool obscureText;
  final bool isValid;
  final double height;
  final Widget? suffixIcon;
  final TextStyle? textStyle;
  final Color? customColor;

  const LabelTextField({
    Key? key,
    this.label = "",
    this.controller,
    this.focusNode,
    this.multiLine = false,
    this.hintText,
    this.readOnly = false,
    this.fillColor,
    this.onTap,
    this.obscureText = false,
    this.isValid = true,
    this.height = 45,
    this.suffixIcon,
    this.textStyle,
    this.customColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (label.isNotEmpty)
          Column(
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: customColor ??
                          AppColors().darkGreyText, // customColor가 없으면 기본값 설정
                    ),
                  ),
                ],
              ),
              const Gap(8),
            ],
          ),
        multiLine
            ? SizedBox(
                height: 8 * 14.0,
                child: TextField(
                  cursorColor: AppColors().mainColor,
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  obscureText: obscureText,
                  maxLines: multiLine ? 5 : 1,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 10.0,
                    ),
                    filled: true,
                    fillColor: fillColor ?? AppColors().white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors().lightGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors().mainColor,
                      ),
                    ),
                    hintText: hintText,
                    hintStyle:
                        TextStyle(color: AppColors().lightGrey, fontSize: 14.0),
                    prefixIcon: isValid
                        ? null
                        : const Icon(Icons.error, color: Colors.red),
                    suffixIcon: suffixIcon,
                  ),
                  style: textStyle,
                ),
              )
            : SizedBox(
                height: height,
                child: TextField(
                  cursorColor: AppColors().mainColor,
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  obscureText: obscureText,
                  maxLines: multiLine ? null : 1,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    filled: true,
                    fillColor: fillColor ?? AppColors().white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors().lightGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors().mainColor,
                      ),
                    ),
                    hintText: hintText,
                    hintStyle:
                        TextStyle(color: AppColors().lightGrey, fontSize: 14.0),
                    prefixIcon: isValid
                        ? null
                        : const Icon(Icons.error, color: Colors.red),
                    suffixIcon: suffixIcon,
                  ),
                  style: textStyle,
                ),
              )
      ],
    );
  }
}
