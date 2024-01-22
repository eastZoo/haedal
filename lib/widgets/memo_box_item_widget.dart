import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haedal/models/memos.dart';
import 'package:haedal/styles/colors.dart';

class MemoBoxItemWidget extends StatelessWidget {
  MemoBoxItemWidget({super.key, this.memos});
  Memos? memos;
  final bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      width: double.infinity,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors().subContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          memos!.memo,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.crop_square,
                      color: Colors.grey,
                      size: 18,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
