import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
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

  bool showBtmAppBr = true;

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

    return GetBuilder<MemoController>(
      init: MemoController(),
      builder: (memoCon) {
        return LoadingOverlay(
          isLoading: memoCon.isLoading.value,
          child: memoCon.memos.isNotEmpty
              ? Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        // 슬라이드 스크린
                        SizedBox(
                          height: 170,
                          child: PageView.builder(
                            controller: pageController,
                            onPageChanged: (index) {
                              print("index :  $index");
                              if (index != memoCon.memos.length) {
                                // currentIdex 는 현재 보고있는 메모카테고리 index담아두는곳
                                currentIndex = index;
                                memoCon.currentMemo = memoCon.memos[index];
                                setState(() {});
                              }
                              // pageNo는 마지막 카테고리 추가 박스를 위한 index
                              pageNo = index;
                              setState(() {});
                            },
                            itemBuilder: (_, index) {
                              if (index == memoCon.memos.length) {
                                // 마지막 인덱스 카드 추가버튼
                                return GestureDetector(
                                  onTap: () async {
                                    await showAddGroupModal();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 8, left: 8, top: 24, bottom: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.white70,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
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
                              } else {
                                //카테고리 카드 생성
                                return AnimatedBuilder(
                                  animation: pageController,
                                  builder: (ctx, child) {
                                    return GestureDetector(
                                      onTap: () async {
                                        /** 메모 추가 모달 */
                                        await showAddMemoModal();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 8,
                                            left: 8,
                                            top: 24,
                                            bottom: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          color: Colors.white70,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.7),
                                              blurRadius: 5.0,
                                              spreadRadius: 0.0,
                                              offset: const Offset(0, 7),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${memoCon.memos[index].category}',
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            Text(
                                              "${memoCon.memos[currentIndex].memos?.length} Tasks",
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              // 프로그레스바 조건문
                                              child: LinearProgressIndicator(
                                                value: memoCon
                                                        .memos[currentIndex]
                                                        .memos!
                                                        .isEmpty
                                                    ? 0
                                                    : memoCon
                                                            .memos[currentIndex]
                                                            .clear! /
                                                        memoCon
                                                            .memos[currentIndex]
                                                            .memos!
                                                            .length,
                                                backgroundColor: Colors.grey,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        AppColors().mainColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            itemCount: memoCon.memos.length + 1,
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        // 스크린 dot 페이지네이션
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
                                      ? AppColors().mainColor
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 체크 리스트
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: memoCon.memos[currentIndex].memos!
                                        .isNotEmpty &&
                                    currentIndex == pageNo
                                ? ListView.builder(
                                    itemCount: memoCon
                                        .memos[currentIndex].memos?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (memoCon.memos[currentIndex].memos!
                                          .isNotEmpty) {
                                        return GestureDetector(
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
                                              // 체크박스 클릭시 post 데이터 생성
                                              var dataSource = {
                                                "id": memoCon
                                                    .memos[currentIndex]
                                                    .memos?[index]
                                                    .id,
                                                "isDone": !memoCon
                                                    .memos[currentIndex]
                                                    .memos![index]
                                                    .isDone
                                              };
                                              /** 메모 리스트 체크박스 업데이트 부분 */
                                              var result = await memoCon
                                                  .updateMemoItem(dataSource);
                                              print(result);
                                              // 업데이트 성공시
                                              if (result) {
                                                // 성공할 때 마다 메세지 띄울 필요는 없을듯?
                                              } else {
                                                return CustomToast().alert(
                                                    "업데이트 실패했습니다.",
                                                    type: "error");
                                              }
                                            },
                                          ),
                                        );
                                      }
                                      return null;
                                    },
                                  )
                                : // 메모 추가 리스트
                                GestureDetector(
                                    onTap: () async {
                                      showAddMemoModal();
                                    },
                                    child: currentIndex == pageNo
                                        ? const Column(
                                            children: [
                                              Gap(20),
                                              Text("메모를 추가해주세요"),
                                              Gap(10),
                                              Center(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 25,
                                                ),
                                              ),
                                            ],
                                          )
                                        :
                                        // pageNo 와 currentIndex 가 다를때는 카테고리 추가 카드부분( 슬라이드 마지막)이라는 뜻이므로 리스트가 아닌 빈화면
                                        Container(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              :
              /** 등록된 메모 카테고리가 하나도 없을때 [+] 카드 */
              Scaffold(
                  body: SafeArea(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          // 슬라이드 스크린
                          SizedBox(
                            height: 170,
                            child: PageView.builder(
                              controller: pageController,
                              itemBuilder: (_, index) {
                                // 마지막 인덱스 카드 추가버튼
                                return GestureDetector(
                                  onTap: () async {
                                    await showAddGroupModal();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 8, left: 8, top: 24, bottom: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.grey,
                                    ),
                                    child: const Column(
                                      children: [
                                        Text("카테고리를 추가해주세요"),
                                        Center(
                                          child: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: 1,
                            ),
                          ),
                          const SizedBox(
                            height: 6.0,
                          ),
                          // 스크린 dot 페이지네이션
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
                                        ? Colors.indigoAccent
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
        );
      },
    );
  }
}
