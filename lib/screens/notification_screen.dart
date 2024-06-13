import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              value:
                  memoCon.memos[memoCon.currentIndex].memos[index].isDone.value,
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
                decoration: memoCon
                        .memos[memoCon.currentIndex].memos[index].isDone.value
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            onTap: () async {
              try {
                var dataSource = {
                  "id": memoCon.memos[memoCon.currentIndex].memos[index].id,
                  "isDone": !memoCon
                      .memos[memoCon.currentIndex].memos[index].isDone.value,
                };
                var result = await memoCon.updateMemoItem(dataSource);

                if (!result) {
                  return CustomToast().alert("업데이트 실패했습니다.", type: "error");
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
      backgroundColor: AppColors().toDoGrey,
      appBar: AppBar(
        title: Text(
          '알림',
          style: TextStyle(
            color: AppColors().darkGreyText,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: AppColors().white,
        iconTheme: IconThemeData(color: AppColors().darkGreyText),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 5, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    // 전체

                    Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors().mainColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          '전체',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors().white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 읽지 않음
                    Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors().darkGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          '읽지 않음',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors().white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                // 리스트 시작
                Expanded(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      return buildTaskTile(memoCon, index);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
