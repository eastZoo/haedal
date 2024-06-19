import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/add_memo_category_screen.dart';
import 'package:haedal/screens/select_color_screen.dart';
import 'package:haedal/screens/memo_detail_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/memo_box_item_widget.dart';

class MemoGroupWidget extends StatelessWidget {
  const MemoGroupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    showAddGroupModal() {
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
          return LoadingOverlay(
            isLoading: memoCon.isLoading.value,
            child: memoCon.memos.isNotEmpty
                ? Column(
                    children: [
                      GridView.count(
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
                              onTap: () async {
                                var result = await memoCon
                                    .getDetailMemoData(memoCon.memos[i].id!);

                                if (result) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return MemoDetailScreen(
                                            id: memoCon.memos[i].id!);
                                      },
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: AppColors().mainColor)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(
                                            "${memoCon.memos[i].category}",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF4C53A5),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Icon(
                                              Icons.checklist_rtl,
                                              color: Colors.grey,
                                              size: 18,
                                            ),
                                            Text(
                                              "0/${memoCon.memos[i].memos.length} 완료",
                                              style: const TextStyle(
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
                                    // 메모가 한개 이상일 때

                                    memoCon.memos[i].memos.isNotEmpty
                                        ? Column(
                                            children: [
                                              for (int j = 0;
                                                  j <
                                                      memoCon.memos[i].memos
                                                          .length;
                                                  j++)
                                                Container(
                                                  child: MemoBoxItemWidget(
                                                      memos: memoCon
                                                          .memos[i].memos[j]),
                                                ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Gap(25),
                                const Text('그룹 추가'),
                                IconButton(
                                  onPressed: () {
                                    showAddGroupModal();
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Gap(25),
                              const Text('저장된 메모가 없습니다.'),
                              IconButton(
                                onPressed: () {
                                  showAddGroupModal();
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
                  ),
          );
        });
  }
}
