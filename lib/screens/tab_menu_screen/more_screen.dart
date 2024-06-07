import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/models/memos.dart';
import 'package:haedal/screens/add_memo_category_screen.dart';
import 'package:haedal/screens/show_add_memo_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';

import 'package:haedal/widgets/my_button.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late final PageController pageController;

  String errorMsg = "";
  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool showBtmAppBr = true;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    String errorMsg = "";

    return GetBuilder<MemoController>(
        init: MemoController(),
        builder: (memoCon) {
          void toggleExpanded() {
            setState(() {
              isExpanded = !isExpanded;
            });
          }

          /** MEMO  카테고리 추가 모달 */
          showAddGroupModal() async {
            return await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
              ),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: AddMemoCategoryScreen(),
                    ),
                  ),
                );
              },
            );
          }

          // 메모 추가 모달
          Future<void> showAddMemoModal() async {
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.0),
                ),
              ),
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ShowAddMemoScreen(),
                    ),
                  ),
                );
              },
            );
            Timer(const Duration(seconds: 300), () {
              if (mounted) {
                pageController.jumpToPage(memoCon.currentIndex);
              }
            });
          }

          //  메모 카테고리 카드 위젯
          Widget buildMemoCard(Memo memoCard) {
            return Container(
              width: 100,
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(int.parse('0xFF${memoCard.color}')),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      memoCard.category!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors().white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      memoCard.title!,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors().white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: memoCard.memos.isEmpty
                              ? 0
                              : memoCard.clear! / memoCard.memos.length,
                          backgroundColor: Color.alphaBlend(
                              AppColors().white.withOpacity(0.2),
                              Color(int.parse('0xFF${memoCard.color}'))),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors().white.withOpacity(0.8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "progress",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: AppColors().white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${memoCard.memos.isNotEmpty ? ((memoCard.clear! / memoCard.memos.length) * 100).toStringAsFixed(2) : 0} %",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors().white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          // 투두 카테고리 추가 컴포넌트
          Widget buildAddButton() {
            return GestureDetector(
              onTap: () async {
                var result = await showAddGroupModal();

                // AddMemoCategoryScreen 에서 true 반환시 페이지 이동
                if (result != null && result == true) {
                  pageController.jumpToPage(0);
                }
              },
              child: Container(
                width: 100,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors().toDoGrey,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors().darkGrey),
                      const Gap(15),
                      Text(
                        "리스트를 추가해주세요",
                        style: TextStyle(color: AppColors().darkGrey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // 할일 타일
          Widget buildTaskTile(MemoController memoCon, int index) {
            return Slidable(
              endActionPane: const ActionPane(
                motion: ScrollMotion(),
                extentRatio: 0.25,
                openThreshold: 0.2,
                children: [
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: AppColors().white,
                ),
                child: ListTile(
                  leading: Checkbox(
                    activeColor: AppColors().mainColor,
                    value: memoCon
                        .memos[memoCon.currentIndex].memos[index].isDone.value,
                    onChanged: (bool? value) {
                      // Update logic here
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    side: WidgetStateBorderSide.resolveWith(
                      (states) => const BorderSide(
                        width: 1.8,
                        color: Color(0xFF6AADE1),
                      ),
                    ),
                  ),
                  title: Text(
                    memoCon.memos[memoCon.currentIndex].memos[index].memo,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors().mainColor,
                      decorationColor: AppColors().mainColor,
                      decoration: memoCon.memos[memoCon.currentIndex]
                              .memos[index].isDone.value
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  onTap: () async {
                    try {
                      var dataSource = {
                        "id":
                            memoCon.memos[memoCon.currentIndex].memos[index].id,
                        "isDone": !memoCon.memos[memoCon.currentIndex]
                            .memos[index].isDone.value,
                      };
                      var result = await memoCon.updateMemoItem(dataSource);

                      if (!result) {
                        return CustomToast()
                            .alert("업데이트 실패했습니다.", type: "error");
                      }
                    } catch (e) {
                      print(e);
                      print("error");
                    }
                  },
                ),
              ),
            );
          }

          return Scaffold(
            body: Column(
              children: [
                // 위의 Flex
                Flexible(
                  flex: isExpanded ? 0 : 4,
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                      child: isExpanded
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Wish List",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().darkGrey,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          var result =
                                              await showAddGroupModal();

                                          // AddMemoCategoryScreen 에서 true 반환시 페이지 이동
                                          if (result != null &&
                                              result == true) {
                                            pageController.jumpToPage(0);
                                          }
                                        },
                                        child: Text(
                                          "카테고리 추가 >",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors().darkGreyText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(10),
                                SizedBox(
                                  height: 160,
                                  width: 120,
                                  child: PageView.builder(
                                    controller: pageController,
                                    onPageChanged: (index) {
                                      if (index != memoCon.memos.length) {
                                        memoCon.currentIndex = index;

                                        memoCon.currentMemo =
                                            memoCon.memos[index];
                                      }

                                      memoCon.pageNo = index;

                                      setState(() {});
                                    },
                                    itemCount: memoCon.memos.length + 1,
                                    itemBuilder: (_, index) {
                                      if (index == memoCon.memos.length) {
                                        return buildAddButton();
                                      }
                                      Memo memoCard = memoCon.memos[index];
                                      print("memoCard");
                                      print(memoCard);
                                      if (memoCard.id != null) {
                                        return buildMemoCard(memoCard);
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const Gap(15),
                                // 페이지 네이션
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    memoCon.memos.length + 1,
                                    (index) => GestureDetector(
                                      child: Container(
                                        margin: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.circle,
                                          size: 12.0,
                                          color: memoCon.pageNo == index
                                              ? AppColors().mainColor
                                              : Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                // 아래의 Flex
                Flexible(
                  flex: isExpanded ? 1 : 4,
                  child: Container(
                    color: Colors.green,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Task",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors().darkGreyText,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      await showAddMemoModal();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors().mainColor,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(2.0),
                                      child: const Icon(
                                        Icons.add_outlined,
                                        color: Colors.white,
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  print("모두 보기");
                                  toggleExpanded();
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "All Task",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors().darkGreyText,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Icon(
                                      isExpanded
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_up,
                                      color: AppColors().darkGreyText,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        memoCon.memos.isNotEmpty &&
                                memoCon.memos[memoCon.currentIndex].memos
                                    .isNotEmpty &&
                                memoCon.pageNo == memoCon.currentIndex
                            ? Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.only(
                                      bottom: isExpanded ? 200 : 230), // 패딩 추가
                                  itemCount: memoCon.memos.isNotEmpty &&
                                          memoCon.memos[memoCon.currentIndex]
                                              .memos.isNotEmpty
                                      ? memoCon.memos[memoCon.currentIndex]
                                          .memos.length
                                      : 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (memoCon.memos[memoCon.currentIndex]
                                        .memos.isNotEmpty) {
                                      return buildTaskTile(memoCon, index);
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              )
                            : Text("등록된 위시가 없습니다.",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors().mainColor,
                                ))
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
