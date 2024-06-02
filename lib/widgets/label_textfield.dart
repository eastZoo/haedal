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
    this.height = 40,
    this.suffixIcon,
    this.textStyle,
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
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors().darkGreyText,
                    ),
                  ),
                ],
              ),
              const Gap(8),
            ],
          ),
        multiLine
            ? Container(
                margin: const EdgeInsets.all(12),
                height: 5 * 10.0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  obscureText: obscureText,
                  maxLines: multiLine ? 5 : 1,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: fillColor ?? AppColors().white,
                    filled: true,
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
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
                        color: AppColors().mainColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors().mainYellowColor,
                      ),
                    ),
                    hintText: hintText,
                    hintStyle:
                        TextStyle(color: AppColors().mainColor, fontSize: 14.0),
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
