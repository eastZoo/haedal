import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/custom_app_bar.dart';
import 'package:haedal/widgets/memo_item.dart';

class TodoDetailScreen extends StatelessWidget {
  const TodoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "title"),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: const Text(
                      "All ToDos",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const MemoItem(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
