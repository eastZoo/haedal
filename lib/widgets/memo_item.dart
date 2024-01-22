import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haedal/models/memos.dart';
import 'package:haedal/models/todo.dart';
import 'package:haedal/styles/colors.dart';

class MemoItem extends StatelessWidget {
  final Memos memo;
  const MemoItem({super.key, required this.memo});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () {
          print("clicked on Todo Item");
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          memo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: AppColors().mainColor,
        ),
        title: Text(
          memo.memo,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            decoration: memo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete),
            iconSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
