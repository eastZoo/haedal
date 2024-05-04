import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:haedal/models/todo_task.dart';
import 'package:haedal/service/controller/memo_controller.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/memo_group_widget.dart';
import 'package:flutter/cupertino.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

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
    return GetBuilder<MemoController>(
        init: MemoController(),
        builder: (memoCon) {
          print("GetBuilder<MemoController> ${memoCon.memos.length}");
          return LoadingOverlay(
            isLoading: memoCon.isLoading,
            child: memoCon.memos.isNotEmpty
                ? Scaffold(
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
                                  if (index == memoCon.memos.length - 1) {
                                    // Add Card Button
                                    return GestureDetector(
                                      onTap: () {
                                        // Add card action
                                        // For example:
                                        // memoCon.addMemo(); // Add memo functionality from your controlle
                                        print("ADD MEMO");
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 8,
                                            left: 8,
                                            top: 24,
                                            bottom: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24.0),
                                          color: Colors.grey,
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    );
                                  } else {
                                    int memoIndex = index;
                                    if (index > 0 &&
                                        memoCon.memos.length == 1) {
                                      memoIndex = index - 1;
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
                                                  BorderRadius.circular(24.0),
                                              color: Colors.grey,
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
                                                const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 0, 15, 0),
                                                  child:
                                                      LinearProgressIndicator(
                                                    value: 1 / 2,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Colors.blue),
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
                  )
                : Container(),
          );
        });
  }
}
