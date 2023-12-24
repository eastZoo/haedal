import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_memo_category_screen.dart';
import 'package:haedal/screens/select_color_screen.dart';
import 'package:haedal/screens/todo_detail_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/todo_box_item_widget.dart';

class MemoGroupWidget extends StatelessWidget {
  const MemoGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    showColorPicker() {
      return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.7,
          minChildSize: 0.6,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: const Scaffold(
                body: AddMemoCategoryScreen(),
              ),
            );
          },
        ),
      );
    }

    return GetBuilder<MemoController>(
        init: MemoController(),
        builder: (memoCon) {
          print("GetBuilder<MemoController> ${memoCon.memos}");
          return LoadingOverlay(
            isLoading: memoCon.isLoading,
            child: memoCon.memos.isNotEmpty
                ? GridView.count(
                    childAspectRatio: 0.68,
                    crossAxisCount: 2,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    children: [
                      for (int i = 0; i < memoCon.memos.length; i++)
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return const TodoDetailScreen();
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: AppColors().subColor)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        memoCon.memos[i]["category"],
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF4C53A5),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.checklist_rtl,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        Text(
                                          "0/29 완료",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Gap(6),
                                Column(
                                  children: [
                                    for (int i = 1; i < 0; i++)
                                      Container(
                                        child: const TodoBoxItemWidget(),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(25),
                              const Text('그룹 추가'),
                              IconButton(
                                onPressed: () {
                                  showColorPicker();
                                },
                                icon: const Icon(
                                  Icons.add,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Gap(25),
                          const Text('저장된 메모가 없습니다.'),
                          IconButton(
                            onPressed: () {
                              showColorPicker();
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
