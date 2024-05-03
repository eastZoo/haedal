import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:haedal/models/memos.dart';
import 'package:haedal/models/todo.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/custom_app_bar.dart';
import 'package:haedal/widgets/memo_item.dart';

class MemoDetailScreen extends StatefulWidget {
  MemoDetailScreen({super.key, required this.id});
  String id;

  @override
  State<MemoDetailScreen> createState() => _MemoDetailScreenState(id);
}

class _MemoDetailScreenState extends State<MemoDetailScreen> {
  _MemoDetailScreenState(this.id);
  String id;
  final todoList = ToDo.todoList();
  final memoCon = Get.put(MemoController());

  @override
  void initState() {
    print("inint");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DISPOSE");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MemoController>(
        init: MemoController(),
        builder: (memoCon) {
          return Scaffold(
            appBar:
                CustomAppbar(title: memoCon.currentMemo!.category.toString()),
            body: Column(
              children: [
                Container(
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
                            // if (memoCon.currentMemo != null &&
                            //     memoCon.currentMemo!.memos!.isNotEmpty)
                            //   for (Memos memo in memoCon.currentMemo!.memos!)
                            //     MemoItem(memo: memo),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 50, right: 20, left: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 0.0),
                                blurRadius: 10.0,
                                spreadRadius: 0.0,
                              )
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                                hintText: 'Add a new memo item',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 50,
                          right: 20,
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors().mainColor,
                            minimumSize: const Size(80, 60),
                            elevation: 5,
                          ),
                          child: const Text(
                            "+",
                            style: TextStyle(fontSize: 40, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
