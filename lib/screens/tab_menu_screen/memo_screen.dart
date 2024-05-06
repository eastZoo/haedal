import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:haedal/models/todo_task.dart';
import 'package:haedal/screens/add_memo_category_screen.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/styles/colors.dart';
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

    return GetBuilder<MemoController>(
      init: MemoController(),
      builder: (memoCon) {
        print("GetBuilder<MemoController> ${memoCon.memos.length}");
        return LoadingOverlay(
          isLoading: memoCon.isLoading,
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
                              pageNo = index;
                              setState(() {});
                            },
                            itemBuilder: (_, index) {
                              if (index == memoCon.memos.length) {
                                // 마지막 인덱스 카드 추가버튼
                                return GestureDetector(
                                  onTap: () async {
                                    await showAddGroupModal();

                                    print("ADD MEMO");
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
                                int memoIndex = index;
                                if (index > 0 && memoCon.memos.length == 1) {
                                  memoIndex = index;
                                }
                                return AnimatedBuilder(
                                  animation: pageController,
                                  builder: (ctx, child) {
                                    return GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "Hello you tapped at $index "),
                                          ),
                                        );
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
                                              '${memoCon.memos[memoIndex].category}',
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10.0),
                                            Text(
                                              "${memoCon.memos.length} Tasks",
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            const SizedBox(height: 20.0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                              child: LinearProgressIndicator(
                                                value: 1 / 2,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: ListView.builder(
                              itemCount: 50,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text('리스트 아이템 $index'),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Scaffold(
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
                              onPageChanged: (index) {
                                pageNo = index;
                                setState(() {});
                              },
                              itemBuilder: (_, index) {
                                // 마지막 인덱스 카드 추가버튼
                                return GestureDetector(
                                  onTap: () async {
                                    await showAddGroupModal();

                                    print("ADD MEMO");
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
