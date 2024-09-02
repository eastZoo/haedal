# haedal

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# global padding

padding:
const EdgeInsets.fromLTRB(20, 10, 20, 0),

# flutter 주의점

1. static한 그림파일 같은 거 불러올때 pubspec.yaml에 경로 추가하는걸 절대 잊지마..절대....



# 리팩토링 할것
1. 아래와 같이 일일이 페이지마다 isLoading 변수 선언 후 변경 하는게 아닌 상위 컴포넌트 만들어서 감싸주기
```dart
return Get.dialog(
      isLoading
          ? Center(
              //로딩바 구현 부분
              child: SpinKitFadingCube(
                // FadingCube 모양 사용
                color: AppColors().mainColor, // 색상 설정
                size: 50.0, // 크기 설정
                duration: const Duration(seconds: 2), //속도 설정
              ),
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.dg), // 원하는 반경으로 설정
              ),
              titlePadding: const EdgeInsets.fromLTRB(0, 15, 10,
```