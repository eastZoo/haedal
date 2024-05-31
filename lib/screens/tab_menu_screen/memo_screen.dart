import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:haedal/models/todo_task.dart';
import 'package:haedal/screens/add_memo_category_screen.dart';
import 'package:haedal/screens/show_add_memo_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/memo_group_widget.dart';
import 'package:flutter/cupertino.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({Key? key}) : super(key: key);

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  late final PageController pageController;

  final ScrollController _scrollController = ScrollController();
  int pageNo = 0;
  int currentIndex = 0;

  String errorMsg = "";

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        showBtmAppBr = false;
        setState(() {});
      } else {
        showBtmAppBr = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

// 색상 리스트 정의
  final List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
  ];

  Color getRandomColor() {
    final random = Random();
    return colorList[random.nextInt(colorList.length)];
  }

  bool showBtmAppBr = true;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    /** MEMO 추가 모달 */
    Future<void> showAddGroupModal() async {
      await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          builder: (context) {
            print(MediaQuery.of(context).viewInsets.bottom);
            return SingleChildScrollView(
                child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: const AddMemoCategoryScreen(),
            ));
          });

      // 모달이 닫힌 후 슬라이드의 첫 번째 아이템으로 포커스 이동
      pageController.jumpToPage(0);
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
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: 0.6,
            maxChildSize: 0.6,
            minChildSize: 0.5,
            expand: false,
            snap: true,
            builder: (context, scrollController) {
              return ShowAddMemoScreen();
            }),
      );
      Timer(const Duration(milliseconds: 300), () {
        pageController.jumpToPage(currentIndex);
      });
    }

    void showCustomBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 1.0,
            expand: true,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          // 프로그램적으로 최대 크기로 확장
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 30.0,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          children: List.generate(
                                            50,
                                            (index) => ListTile(
                                              title: Text('Item $index'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          size: 30.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: List.generate(
                            50,
                            (index) => ListTile(
                              title: Text('Item $index'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return GetBuilder<MemoController>(
        init: MemoController(),
        builder: (memoCon) {
          return LoadingOverlay(
              isLoading: memoCon.isLoading.value,
              child: Scaffold(
                backgroundColor: AppColors().white,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: isExpanded
                            ? 0
                            : MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                        print("카테고리 추가");
                                      },
                                      child: Text(
                                        "카테고리 추가 >",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors().textGrey,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  controller: pageController,
                                  onPageChanged: (index) {
                                    print("index :  $index");
                                    if (index != memoCon.memos.length) {
                                      currentIndex = index;
                                      memoCon.currentMemo =
                                          memoCon.memos[index];
                                    }
                                    pageNo = index;
                                    setState(() {});
                                  },
                                  itemBuilder: (_, index) {
                                    if (index != memoCon.memos.length) {
                                      return AnimatedBuilder(
                                        animation: pageController,
                                        builder: (ctx, child) {
                                          return GestureDetector(
                                            onTap: () async {
                                              await showAddMemoModal();
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                color: AppColors().subContainer,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        24, 12, 24, 24),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8),
                                                    Text("Category",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color:
                                                              AppColors().white,
                                                        )),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '${memoCon.memos[index].category}',
                                                      style: TextStyle(
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors()
                                                              .white),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    SizedBox(
                                                      height: 10,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child:
                                                            LinearProgressIndicator(
                                                          value: memoCon
                                                                  .memos[
                                                                      currentIndex]
                                                                  .memos!
                                                                  .isEmpty
                                                              ? 0
                                                              : memoCon
                                                                      .memos[
                                                                          currentIndex]
                                                                      .clear! /
                                                                  memoCon
                                                                      .memos[
                                                                          currentIndex]
                                                                      .memos!
                                                                      .length,
                                                          backgroundColor:
                                                              AppColors()
                                                                  .subContainerDisabled,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  AppColors()
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "progress",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: AppColors()
                                                                .white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${memoCon.memos[currentIndex].memos!.isNotEmpty ? ((memoCon.memos[currentIndex].clear! / memoCon.memos[currentIndex].memos!.length) * 100).toStringAsFixed(2) : 0} %",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: AppColors()
                                                                .white,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () async {
                                          await showAddGroupModal();
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.white70,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                blurRadius: 5.0,
                                                spreadRadius: 0.0,
                                                offset: const Offset(0, 7),
                                              )
                                            ],
                                          ),
                                          child: const Center(
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  itemCount: memoCon.memos.length + 1,
                                ),
                              ),
                              const SizedBox(height: 5),
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
                                        color: pageNo == index
                                            ? AppColors().subContainer
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
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        height: isExpanded
                            ? MediaQuery.of(context).size.height
                            : MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: AppColors().toDoGrey,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("모두 보기");
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "All Task",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors().textGrey,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Icon(
                                          isExpanded
                                              ? Icons.keyboard_arrow_down
                                              : Icons.keyboard_arrow_up,
                                          color: AppColors().textGrey,
                                          size: 24.0,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: memoCon.memos.isNotEmpty &&
                                        memoCon.memos[0].memos != null
                                    ? memoCon.memos[0].memos!.length
                                    : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  if (memoCon
                                      .memos[currentIndex].memos!.isNotEmpty) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          right: 10,
                                          left: 10,
                                          top: 8,
                                          bottom: 0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: AppColors().white,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: ListTile(
                                          leading: Checkbox(
                                            value: memoCon.memos[currentIndex]
                                                .memos?[index].isDone,
                                            onChanged: (bool? value) {
                                              // setState(() {
                                              //   memo.isChecked = value!;
                                              // });
                                            },
                                          ),
                                          title: Text(
                                              '${memoCon.memos[currentIndex].memos?[index].memo}'),
                                          onTap: () async {
                                            var dataSource = {
                                              "id": memoCon.memos[currentIndex]
                                                  .memos?[index].id,
                                              "isDone": !memoCon
                                                  .memos[currentIndex]
                                                  .memos![index]
                                                  .isDone
                                            };
                                            var result = await memoCon
                                                .updateMemoItem(dataSource);
                                            print(result);
                                            if (result) {
                                            } else {
                                              return CustomToast().alert(
                                                  "업데이트 실패했습니다.",
                                                  type: "error");
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
