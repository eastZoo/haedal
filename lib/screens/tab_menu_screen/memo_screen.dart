import 'dart:async';
import 'dart:ffi';
import 'dart:math';

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
              body: SafeArea(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6FB),
                  ),
                  child: Column(
                    children: [
                      // 슬라이드 스크린
                      Container(
                        padding: const EdgeInsets.only(bottom: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(50.0),
                              bottomRight: Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20, 20, 20, 0), // 위시리스트 사이드 패딩 설정
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
                              height: 200, // 카테고리 카드 크기
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
                                  if (index != memoCon.memos.length) {
                                    /** 카테고리 카드 생성 **/
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
                                                top: 16,
                                                bottom: 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: AppColors().subContainer,
                                            ),
                                            child: Padding(
                                              // 카테고리 카드 안 텍스트 전체 패딩
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      24, 12, 24, 24),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Gap(8),
                                                  Text("Category",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color:
                                                            AppColors().white,
                                                      )),
                                                  const Gap(8),
                                                  Text(
                                                    '${memoCon.memos[index].category}', // 카테고리 타이틀
                                                    style: TextStyle(
                                                        fontSize: 24.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            AppColors().white),
                                                  ),
                                                  const Gap(10),
                                                  // Text(
                                                  //   "${memoCon.memos[currentIndex].memos?.length} Tasks",
                                                  //   style: const TextStyle(
                                                  //     fontSize: 16.0,
                                                  //   ),
                                                  // ),
                                                  const Gap(5),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 0),
                                                    // 프로그레스바 조건문
                                                    child: SizedBox(
                                                      height: 10, // 원하는 높이로 설정
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    5)), // 원하는 반경으로 설정
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
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 8, 0, 0),
                                                    child: Row(
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
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    /** 카테고리 추가 카드 컨테이너 **/
                                    return GestureDetector(
                                      onTap: () async {
                                        await showAddGroupModal();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 8,
                                            left: 8,
                                            top: 16,
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
                            const Gap(15),
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
                      // AddTask 타이틀
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            20, 20, 20, 0), // 위시리스트 사이드 패딩 설정
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Add Task",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    /** 메모 추가 모달 */
                                    await showAddMemoModal();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors().subContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(
                                        2.0), // 원의 크기를 조정하기 위한 여백
                                    child: const Icon(
                                      Icons.add_outlined,
                                      color: Colors
                                          .white, // 아이콘 색상을 흰색으로 변경하여 대비를 높임
                                      size: 20.0, // 아이콘 크기
                                    ),
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                print("카테고리 추가");
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
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors()
                                        .textGrey, // 아이콘 색상을 흰색으로 변경하여 대비를 높임
                                    size: 24.0, // 아이콘 크기
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // 체크 리스트
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      //     child: memoCon
                      //                 .memos[currentIndex].memos!.isNotEmpty &&
                      //             currentIndex == pageNo
                      //         ? ListView.builder(
                      //             itemCount:
                      //                 memoCon.memos[currentIndex].memos?.length,
                      //             itemBuilder:
                      //                 (BuildContext context, int index) {
                      //               if (memoCon.memos[currentIndex].memos!
                      //                   .isNotEmpty) {
                      //                 return Container(
                      //                   margin: const EdgeInsets.only(
                      //                       right: 10,
                      //                       left: 10,
                      //                       top: 8,
                      //                       bottom: 0),
                      //                   decoration: BoxDecoration(
                      //                     borderRadius:
                      //                         BorderRadius.circular(10.0),
                      //                     color: AppColors().white,
                      //                   ),
                      //                   child: GestureDetector(
                      //                     onTap: () {},
                      //                     child: ListTile(
                      //                       leading: Checkbox(
                      //                         value: memoCon.memos[currentIndex]
                      //                             .memos?[index].isDone,
                      //                         onChanged: (bool? value) {
                      //                           // setState(() {
                      //                           //   memo.isChecked = value!;
                      //                           // });
                      //                         },
                      //                       ),
                      //                       title: Text(
                      //                           '${memoCon.memos[currentIndex].memos?[index].memo}'),
                      //                       onTap: () async {
                      //                         // 체크박스 클릭시 post 데이터 생성
                      //                         var dataSource = {
                      //                           "id": memoCon
                      //                               .memos[currentIndex]
                      //                               .memos?[index]
                      //                               .id,
                      //                           "isDone": !memoCon
                      //                               .memos[currentIndex]
                      //                               .memos![index]
                      //                               .isDone
                      //                         };
                      //                         /** 메모 리스트 체크박스 업데이트 부분 */
                      //                         var result = await memoCon
                      //                             .updateMemoItem(dataSource);
                      //                         print(result);
                      //                         // 업데이트 성공시
                      //                         if (result) {
                      //                           // 성공할 때 마다 메세지 띄울 필요는 없을듯?
                      //                         } else {
                      //                           return CustomToast().alert(
                      //                               "업데이트 실패했습니다.",
                      //                               type: "error");
                      //                         }
                      //                       },
                      //                     ),
                      //                   ),
                      //                 );
                      //               }
                      //               return null;
                      //             },
                      //           )
                      //         : // 메모 추가 리스트
                      //         GestureDetector(
                      //             onTap: () async {
                      //               showAddMemoModal();
                      //             },
                      //             child: currentIndex == pageNo
                      //                 ? const Column(
                      //                     children: [
                      //                       Gap(20),
                      //                       Text("메모를 추가해주세요"),
                      //                       Gap(10),
                      //                       Center(
                      //                         child: Icon(
                      //                           Icons.add,
                      //                           size: 25,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   )
                      //                 :
                      //                 // pageNo 와 currentIndex 가 다를때는 카테고리 추가 카드부분( 슬라이드 마지막)이라는 뜻이므로 리스트가 아닌 빈화면
                      //                 Container(),
                      //           ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            )

            /** 등록된 메모 카테고리가 하나도 없을때 [+] 카드 */
            //     Scaffold(
            //   body: SafeArea(
            //     child: SingleChildScrollView(
            //       controller: _scrollController,
            //       child: Column(
            //         children: [
            //           const Text(
            //             "Wish List",
            //             style: TextStyle(
            //               fontSize: 20.0,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           // 슬라이드 스크린
            //           SizedBox(
            //             height: 170,
            //             child: PageView.builder(
            //               controller: pageController,
            //               itemBuilder: (_, index) {
            //                 // 마지막 인덱스 카드 추가버튼
            //                 return GestureDetector(
            //                   onTap: () async {
            //                     await showAddGroupModal();
            //                   },
            //                   child: Container(
            //                     margin: const EdgeInsets.only(
            //                         right: 8, left: 8, top: 24, bottom: 12),
            //                     decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(20.0),
            //                       color: Colors.grey,
            //                     ),
            //                     child: const Column(
            //                       children: [
            //                         Text("카테고리를 추가해주세요"),
            //                         Center(
            //                           child: Icon(Icons.add),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               },
            //               itemCount: 1,
            //             ),
            //           ),
            //           const SizedBox(
            //             height: 6.0,
            //           ),
            //           // 스크린 dot 페이지네이션
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: List.generate(
            //               memoCon.memos.length + 1,
            //               (index) => GestureDetector(
            //                 child: Container(
            //                   margin: const EdgeInsets.all(2.0),
            //                   child: Icon(
            //                     Icons.circle,
            //                     size: 12.0,
            //                     color: pageNo == index
            //                         ? Colors.indigoAccent
            //                         : Colors.grey.shade300,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            );
      },
    );
  }
}
