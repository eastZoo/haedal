import 'package:flutter/material.dart';
import 'package:haedal/models/alarm_history.dart';
import 'package:haedal/styles/colors.dart';

// 카테고리별 알람 메시지 변환 함수
TextSpan AlarmCategoryTranslate(AlarmHistory alarm) {
  switch (alarm.type) {
    case 'albumboard':
      return TextSpan(
        children: [
          TextSpan(
            text: "${alarm.user?.name}",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: "님이 ",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: alarm.content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: ' 앨범에 ',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: '${alarm.picQty}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors().mainYellowColor,
            ),
          ),
          const TextSpan(
            text: '장의 사진을 올렸습니다.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      );
    case 'memo':
      return TextSpan(
        children: [
          TextSpan(
            text: "${alarm.user?.name}",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: "님이 ",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: alarm.content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: ' 럽킷 리스트에 ',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: alarm.sub_content,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors().mainColor,
            ),
          ),
          const TextSpan(
            text: ' 메모를 추가했습니다.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      );
    case 'memoCategory':
      return TextSpan(
        children: [
          TextSpan(
            text: "${alarm.user?.name}",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: "님이 ",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const TextSpan(
            text: '럽킷 카테고리에 ',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: alarm.content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: '을 추가했습니다.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      );
    case 'calendar':
      return TextSpan(
        children: [
          TextSpan(
            text: "${alarm.user?.name}",
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.blue,
            ),
          ),
          const TextSpan(
            text: "님이 ",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const TextSpan(
            text: '🗓️캘린더에 ',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: alarm.sub_content,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const TextSpan(
            text: ' ',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: alarm.content,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const TextSpan(
            text: '를 추가했습니다.',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      );
    case 'event':
      return const TextSpan(
        text: '이벤트',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
    default:
      return const TextSpan(
        text: '알 수 없음',
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      );
  }
}
