import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';
import 'package:get/get.dart';

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

  // 인풋 에러 확인용 스테이트
  bool isEmailValid = true;
  bool isPasswordValid = true;

  // 버튼 관련상태
  bool email = false;
  bool password = false;

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
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUpToast() {
    Fluttertoast.showToast(
        msg: errorMsg,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent.shade100,
        fontSize: 14,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT);
  }

// 이메일 텍스트필드에서 커서 Out 됬을때 실행되는 함수
  void cursorMovedOutOfEmailTextField() async {
    // 커서 아웃됬을때 공백 전부 삭제
    emailController.text = emailController.text.replaceAll(" ", "");
    // 이메일 중복 확인하는 API
    await authCon.checkDuplicateEmail(emailController.text);

    // 이메일 필드가 <비어있으며> 커서 Out 됬을때
    if (emailController.text.isEmpty) {
      setState(() {
        isEmailValid = false;
        errorMsg = "이메일을 입력해 주세요";
      });
      return signUpToast();
    }
    // 이메일 필드가 <이메일 형식에 맞지 않으며> 커서 Out 됬을때
    if (!emailRegex.hasMatch(emailController.text)) {
      setState(() {
        isEmailValid = false;
        errorMsg = "올바른 이메일 형식이 아닙니다";
      });
      return signUpToast();
    }
    // 이미 존재하는 이메일일때
    if (authCon.isDuplicateEmail) {
      setState(() {
        isEmailValid = false;
        errorMsg = "이미 존재하는 메일 주소입니다. 다시 시도해주세요.";
      });
      return signUpToast();
    }

    // 모든조건을 만족했을때
    return setState(() {
      isEmailValid = true;
    });
  }

// 회원가입 버튼 클릭시 모달 창
  Future<dynamic> showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(emailController.text),
        content: const Text(
            '잘못된 메일 주소로 가입 시 서비스 이용에 제한 및 불이익이 발생할 수 있습니다. 입력하신 아이디로 가입을 진행할까요?'),
        actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, shadowColor: Colors.transparent),
            child: const Text(
              '아니오',
              style: TextStyle(color: Color(0xFF48C5C3)),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.transparent),
              child: const Text(
                '예',
                style: TextStyle(color: Color(0xFF48C5C3)),
              ),
              onPressed: () async {
                var result = await authCon.onSignUp(
                    emailController.text, passwordController.text);

                print("@@@@@@@@@@@@@@@ $result");
                if (result) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/code',
                    (route) => false,
                  );
                }
              }),
        ],
      ),
    );
  }

  // 회원가입 버튼 클릭시 모달창 pop
  void onSignUpModal() {
    showdialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // logo
                Image.asset(
                  "assets/icons/register-1.png",
                ),

                const SizedBox(height: 15),

                // welcome back, you've been missed!
                Text(
                  '반갑습니다!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                Text(
                  '해달 가입을 위한 정보를 입력해주세요.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                // username textfield
                MyTextField(
                    controller: emailController,
                    hintText: '이메일',
                    obscureText: false,
                    focusNode: userEmailfocusNode,
                    isValid: isEmailValid),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: '비밀번호',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  title: "회원가입",
                  onTap: onSignUpModal,
                  available: email && password,
                ),

                const SizedBox(height: 50),

                // or continue with
              ],
            ),
          ),
        ),
      ),
    );
  }
}
