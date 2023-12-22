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
  bool? _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: const Text(
        "Todo list",
        style: TextStyle(fontSize: 14),
      ),
      value: _isChecked,
      onChanged: (bool? newValue) {
        setState(() {
          _isChecked = newValue;
        });
      },
      activeColor: AppColors().mainColor,
      checkColor: Colors.white,
      tileColor: AppColors().subColor,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
