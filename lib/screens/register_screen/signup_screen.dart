import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/service/provider/auth_provider.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/label_textfield.dart';
import 'package:get/get.dart';
import 'package:haedal/widgets/my_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final authCon = Get.put(AuthController());

  // 이메일 텍스트 controllers
  final emailController = TextEditingController();
  FocusNode userEmailfocusNode = FocusNode();
  // 비밀번호 텍스트 controllers
  final passwordController = TextEditingController();
  // 비밀번호 확인 텍스트 controllers
  final passwordCheckController = TextEditingController();

  // 인풋 에러 확인용 스테이트
  bool isEmailValid = true;
  bool isPasswordValid = true;

  // 버튼 관련상태
  bool email = false;
  bool password = false;

  bool isLoading = false;

  // 이메일 형식 판별 정규식
  RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
  );
  // 비밀번호 유효성 검사 정규식 ( 영문 숫자 포함 8자 이상 )
  RegExp passwordRegex = RegExp(r'^(?=.*[0-9])[a-zA-Z0-9]{8,}$');

  String errorMsg = "";

  @override
  void initState() {
    super.initState();
    // 이메일 텍스트 얻어오는 컨트롤러 부착
    try {
      emailController.addListener(() {
        // 공백제거
        if (emailRegex.hasMatch(emailController.text)) {
          setState(() {
            email = emailController.text.isNotEmpty;
            isEmailValid = true;
          });
        } else {
          setState(() {
            email = false;
          });
        }
      });
      // 비밀번호 얻어오는 컨트롤러 부착
      passwordController.addListener(() {
        // 영문 숫자 포함 8자 이상일 때만 true
        if (passwordRegex.hasMatch(passwordController.text)) {
          setState(() {
            password = passwordController.text.isNotEmpty;
          });
        } else {
          setState(() {
            password = false;
          });
        }
      });
      // 이메일 커서 포커스 감지하는 함수 부착
      userEmailfocusNode.addListener(() {
        if (!userEmailfocusNode.hasFocus) {
          cursorMovedOutOfEmailTextField();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordCheckController.dispose();
    super.dispose();
  }

  // 모달창에서 로그인 승인 ( 예 클릭 시 ) 이미 회원가입된 상태 ( 아니오 누르면 회원가입 취소 로직 탐 )
  void onSignup() async {
    if (passwordController.text != passwordCheckController.text) {
      CustomToast().alert("비밀번호가 일치하지 않습니다.");
      Navigator.of(context).pop();
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      var result = await authCon.onSignUp(
          emailController.text, passwordController.text, "email");

      if (result) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/code',
          (route) => false,
        );
      }
    } catch (e) {
      CustomToast().alert("회원가입에 실패했습니다. 다시 시도해주세요.");
      print(e);
    }
  }

  // 이메일 텍스트필드에서 커서 Out 됬을때 실행되는 함수
  void cursorMovedOutOfEmailTextField() async {
    // 이메일 필드가 <비어있으며> 커서 Out 됬을때
    if (emailController.text.isEmpty) {
      setState(() {
        isEmailValid = false;
        errorMsg = "이메일을 입력해 주세요";
      });
      return CustomToast().alert(errorMsg);
    }

    // 커서 아웃됬을때 공백 전부 삭제
    emailController.text = emailController.text.replaceAll(" ", "");
    // 이메일 중복 확인하는 API
    await authCon.checkDuplicateEmail(emailController.text);

    // 이메일 필드가 <이메일 형식에 맞지 않으며> 커서 Out 됬을때
    if (!emailRegex.hasMatch(emailController.text)) {
      setState(() {
        isEmailValid = false;
        errorMsg = "올바른 이메일 형식이 아닙니다";
      });
      return CustomToast().alert(errorMsg);
    }
    // 이미 존재하는 이메일일때
    if (authCon.isDuplicateEmail) {
      setState(() {
        isEmailValid = false;
        errorMsg = "이미 존재하는 메일 주소입니다. 다시 시도해주세요.";
      });
      return CustomToast().alert(errorMsg);
    }

    // 모든조건을 만족했을때
    return setState(() {
      isEmailValid = true;
    });
  }

  //팝업창을 띄우는 전역함수
  Future<dynamic> popWindow(BuildContext context, String title) {
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
              titlePadding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
              backgroundColor: Colors.white,
              title: SizedBox(
                  width: 560,
                  height: 45,
                  child: Stack(children: [
                    //제목
                    Positioned(
                        top: 5,
                        left: 0,
                        right: 0,
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),
                        )),
                    //닫기 버튼
                    Positioned(
                        width: 45,
                        height: 45,
                        right: 0,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); //창 닫기
                          },
                          child: const Icon(Icons.close, color: Colors.black),
                        ))
                  ])),
              //화면에 표시될 영역
              content: Text(
                '잘못된 메일 주소로 가입 시 서비스 이용에 제한 및\n 불이익이 발생할 수 있습니다.\n입력하신 아이디로 가입을 진행할까요?',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 13.sp,
                ),
              ),
              actions: [
                ButtonBar(
                  alignment: MainAxisAlignment.center, // 중앙 정렬

                  children: <Widget>[
                    Row(
                      children: [
                        SizedBox(
                          width: 125,
                          child: ElevatedButton(
                            onPressed: () {
                              // 뒤로가기
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.grey, // 버튼 텍스트 색상
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ), // 버튼 패딩
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // 버튼 모서리 둥글게
                              ),
                            ),
                            child: const Text('아니오'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 125,
                          child: ElevatedButton(
                            onPressed: () {
                              // 뒤로가기
                              onSignup();
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  AppColors().mainColor, // 버튼 텍스트 색상
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ), // 버튼 패딩
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // 버튼 모서리 둥글게
                              ),
                            ),
                            child: const Text('예'),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
      barrierDismissible: false,
    );
  }

  // email(local) 회원가입 버튼 클릭시 모달창 pop
  onSignUpModal() async {
    popWindow(context, emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors().white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Gap(120),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/step-1.png",
                    width: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/Step1.png",
                    width: 95,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '반갑습니다',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
                Text(
                  '해달 가입을 위한 정보를 입력해주세요.',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                LabelTextField(
                    controller: emailController,
                    hintText: '이메일',
                    obscureText: false,
                    focusNode: userEmailfocusNode,
                    isValid: isEmailValid),
                const SizedBox(height: 10),
                LabelTextField(
                  controller: passwordController,
                  hintText: '비밀번호',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                LabelTextField(
                  controller: passwordCheckController,
                  hintText: '비밀번호 확인',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                // 추가할 버튼 영역이 여기에 위치하는 대신 bottomNavigationBar에 추가됩니다.
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(35, 0, 35, 35),
        child: MyButton(
          title: "다음",
          height: 45,
          fontSize: 15.sp,
          onTap: onSignUpModal,
          available: email && password && !isLoading,
        ),
      ),
    );
  }
}
