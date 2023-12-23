import 'package:flutter/material.dart';
import 'package:haedal/styles/colors.dart';

class TodoBoxItemWidget extends StatefulWidget {
  const TodoBoxItemWidget({
    super.key,
  });

  @override
  State<TodoBoxItemWidget> createState() => _TodoBoxItemWidgetState();
}

class _TodoBoxItemWidgetState extends State<TodoBoxItemWidget> {
  final bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors().subContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "todo list",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
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
