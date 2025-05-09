import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:haedal/screens/find_id_screen.dart';
import 'package:haedal/service/controller/auth_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/createJwt.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/label_textfield.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:haedal/widgets/my_button.dart';
import 'package:haedal/widgets/my_textfield.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editing controllers

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 이메일 텍스트 controllers
  FocusNode userEmailfocusNode = FocusNode();

  String errorMsg = "";

  bool isLoading = false;

  final authCon = Get.put(AuthController());

  bool isSaveId = false;

  @override
  void initState() {
    super.initState();
    // 이메일 커서 포커스 감지하는 함수 부착
    userEmailfocusNode.addListener(() {
      if (!userEmailfocusNode.hasFocus) {
        cursorMovedOutOfEmailTextField();
      }
    });
    // 저장된 이메일 불러오기
    _loadSavedEmail();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // 이메일 텍스트필드에서 커서 Out 됬을때 실행되는 함수
  void cursorMovedOutOfEmailTextField() async {
    // 커서 아웃됬을때 공백 전부 삭제
    emailController.text = emailController.text.replaceAll(" ", "");
  }

  // 이메일 저장 상태 불러오기
  void _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isSaveId = prefs.getBool('isSaveId') ?? false;
      if (isSaveId) {
        emailController.text = prefs.getString('savedEmail') ?? '';
      }
    });
  }

  // 이메일 저장하기
  void _saveEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSaveId', isSaveId);
    if (isSaveId) {
      await prefs.setString('savedEmail', emailController.text);
    } else {
      await prefs.remove('savedEmail');
    }
  }

  Widget _buildSocialButton(String iconPath, VoidCallback onPressed,
      {bool isDisabled = false}) {
    return IconButton(
      icon: SvgPicture.asset(
        iconPath,
        width: 35,
        height: 35,
        fit: BoxFit.contain,
        colorFilter: isDisabled
            ? ColorFilter.mode(Colors.grey.withOpacity(0.2), BlendMode.srcIn)
            : null,
      ),
      onPressed: isDisabled
          ? () {
              CustomToast().alert('소셜로그인 준비중입니다. 애플 로그인을 이용해주세요.');
            }
          : onPressed,
    );
  }

  // 네이버 로그인 정보 가져오기
  void _naverLogin() async {
    if (isLoading) return; // 이미 로딩 중이면 중복 실행 방지

    try {
      setState(() {
        isLoading = true;
      });
      final NaverLoginResult user = await FlutterNaverLogin.logIn();

      // 로그인이 취소되었거나 이미 종료된 경우 early return
      if (!mounted) {
        return;
      }

      switch (user.status) {
        case NaverLoginStatus.loggedIn:
          var result = await authCon.onSocialNaverSignUp(user.account, "naver");
          if (result && mounted) {
            Timer(const Duration(milliseconds: 500), () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/splash',
                (route) => false,
              );
            });
          }
          break;
        case NaverLoginStatus.cancelledByUser:
          CustomToast().alert('사용자가 로그인을 취소했습니다.');
          break;
        case NaverLoginStatus.error:
          CustomToast().alert('로그인 오류: ${user.errorMessage}');
          break;
      }
    } catch (e) {
      if (mounted) {
        CustomToast().alert('네이버 로그인 실패: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // 카카오 로그인 정보 가져오기
  void _kakaoLogin() async {
    try {
      // 카카오톡 앱을 통한 로그인 시도
      bool installed = await isKakaoTalkInstalled();
      print('installed: $installed');

      OAuthToken token = installed
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      print("token: $token");
      // 로그인 성공 후 유저 정보 가져오기
      User user = await UserApi.instance.me();
      print("user: $user");

      // loading overlay start
      setState(() {
        isLoading = true;
      });
      // 서버로 유저 정보 전송하여 데이터베이스에 저장하기
      var result = await authCon.onSocialKaKaoSignUp(user, "kakao");

      if (result) {
        Timer(const Duration(milliseconds: 500), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/splash',
            (route) => false,
          );
          setState(() {
            isLoading = false;
          });
        });
      } else {
        CustomToast().alert('카카오톡 회원가입 실패');
      }
    } catch (e) {
      print('카카오톡 회원가입 실패: $e');
      CustomToast().alert('카카오톡 회원가입 실패');
    } finally {
      // loading overlay end
      setState(() {
        isLoading = false;
      });
    }
  }

  // 애플 로그인 정보 가져오기
  void _appleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("credential: $credential");

      // 이후에 credential을 사용하여 서버로 전송하고 로그인 처리를 완료합니다.
      var result = await authCon.onSocialAppleSignUp(credential, "apple");

      if (result) {
        Timer(const Duration(milliseconds: 500), () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/splash',
            (route) => false,
          );
          setState(() {
            isLoading = false;
          });
        });
      } else {
        CustomToast().alert('애플 회원가입 실패');
      }
    } catch (e) {
      print('애플 로그인 실패: $e');
      CustomToast().alert('애플 로그인 실패');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
        init: AuthController(),
        builder: (authCon) {
          return LoadingOverlay(
            isLoading: isLoading,
            child: Scaffold(
              backgroundColor: AppColors().white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Gap(140),
                        // logo
                        Image.asset(
                          'assets/icons/logo.png',
                          width: 170,
                        ),

                        const SizedBox(height: 50),

                        // username textfield
                        LabelTextField(
                          controller: emailController,
                          hintText: '이메일',
                          focusNode: userEmailfocusNode,
                          obscureText: false,
                        ),

                        const SizedBox(height: 10),

                        // password textfield
                        LabelTextField(
                          controller: passwordController,
                          hintText: '비밀번호',
                          obscureText: true,
                        ),

                        const SizedBox(height: 10),

                        // 아이디 저장 체크박스
                        Container(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Checkbox(
                                value: isSaveId,
                                onChanged: (value) {
                                  setState(() {
                                    isSaveId = value!;
                                    _saveEmail();
                                  });
                                },
                                side: BorderSide(
                                  color: AppColors().mainColor,
                                ),
                                activeColor: AppColors().mainColor,
                                visualDensity: const VisualDensity(
                                    horizontal: -4.0, vertical: 0), // ✅ 여백 줄임
                                materialTapTargetSize: MaterialTapTargetSize
                                    .shrinkWrap, // ✅ 터치 영역 최소화 (선택)
                              ),
                              const Gap(5),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSaveId = !isSaveId;
                                    _saveEmail();
                                  });
                                },
                                child: Text(
                                  '아이디 저장',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // sign in button
                        MyButton(
                          title: "로그인",
                          onTap: () async {
                            var result = await authCon.onSignIn(
                                emailController.text, passwordController.text);
                            if (result["success"]) {
                              if (isSaveId) {
                                _saveEmail();
                              }
                              Timer(const Duration(milliseconds: 500), () {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/splash',
                                  (route) => false,
                                );
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            } else {
                              setState(() {
                                errorMsg = result["msg"];
                              });
                              return CustomToast().alert(errorMsg);
                            }
                          },
                          available: true,
                        ),

                        const SizedBox(height: 25),

                        // or continue with
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'SNS 계정으로 로그인',
                                  style: TextStyle(
                                      color: Colors.grey[700], fontSize: 14),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // _buildSocialButton(
                            //   'assets/icons/svg/kakao.svg',
                            //   () async {
                            //     _kakaoLogin();
                            //   },
                            //   isDisabled: true, // 카카오 로그인 비활성화
                            // ),
                            // _buildSocialButton(
                            //   'assets/icons/svg/naver.svg',
                            //   () async {
                            //     _naverLogin();
                            //   },
                            //   isDisabled: true, // 네이버 로그인 비활성화
                            // ),
                            _buildSocialButton(
                              'assets/icons/svg/apple.svg',
                              () {
                                _appleLogin();
                              },
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '아직 멤버가 아니신가요?',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              child: Text(
                                '연결하러 가기',
                                style: TextStyle(
                                    color: AppColors().mainColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                            )
                          ],
                        ),
                        Text(
                          'This app made by Component Co.',
                          style: TextStyle(
                              color: AppColors().darkGreyText, fontSize: 14),
                        )
                        //임시 버튼 !!!!!!!
                        // const Gap(30),
                        // MyButton(
                        //   title: "애플 회원 탈퇴",
                        //   onTap: () {
                        //     print('애플 회원 탈퇴');
                        //     revokeSignInWithApple();
                        //   },
                        //   available: true, // 탭 가능 여부
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors().lightGrey, width: 0.5),
                  ),
                ),
                child: BottomAppBar(
                  height: 60,
                  color: AppColors().grey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return const FindIdScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            '아이디 찾기',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors().darkGreyText,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        VerticalDivider(
                          color: AppColors().lightGrey,
                          width: 20,
                          thickness: 1,
                          indent: 5,
                          endIndent: 5,
                        ),
                        Text(
                          '비밀번호 찾기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors().darkGreyText,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
