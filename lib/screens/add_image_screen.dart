import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:haedal/screens/select_map_position_screen.dart';
import 'package:haedal/service/controller/board_controller.dart';
import 'package:haedal/service/provider/board_provider.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
import 'package:haedal/widgets/custom_appbar.dart';
import 'package:haedal/widgets/loading_overlay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kpostal/kpostal.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' hide context;

class AddimageScreen extends StatefulWidget {
  const AddimageScreen({super.key});

  @override
  State<AddimageScreen> createState() => _AddimageScreenState();
}

class _AddimageScreenState extends State<AddimageScreen> {
  BoardController boardCon = Get.put(BoardController());

  final ImagePicker _picker = ImagePicker();

  final titleTextController = TextEditingController();
  final locationTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  List<String> dropdownList = ['음식점', '숙소', '카페'];

  String errorMsg = "";

  // 스토리 저장 시 전송 dataSource
  String title = '';
  String category = '음식점';
  NLatLng? currentLatLng;
  final List<XFile> _pickedImages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleTextController.addListener(() {
      setState(() {
        title = titleTextController.text;
      });
    });
    getMultiImage();
  }

  @override
  void dispose() {
    titleTextController.dispose();
    super.dispose();
  }

  // 이미지 여러개 불러오기
  void getMultiImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty && _pickedImages.isEmpty) {
      return Navigator.pop(context);
    }
    setState(() {
      _pickedImages.addAll(images);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppbar(
                title: "스토리 작성",
                actions: _addBtn(),
              ),
              _thumbPhoto(),
              _pickedImages.isNotEmpty ? _gridPhoto() : const SizedBox(),
              _FormWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // 앱바 게시 버튼
  Widget _addBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: GestureDetector(
        child: Text(
          "게시",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors().mainColor,
          ),
        ),
        onTap: () async {
          if (title.isEmpty) {
            setState(() {
              errorMsg = "제목(title)을 입력해주세요.";
            });
            return CustomToast().signUpToast(errorMsg);
          }
          if (_pickedImages.isEmpty) {
            setState(() {
              errorMsg = "추가된 이미지가 없습니다.";
            });
            return CustomToast().signUpToast(errorMsg);
          }
          if (currentLatLng == null) {
            setState(() {
              errorMsg = "사진과 함께 기억할 위치를 선택해주세요.";
            });
            return CustomToast().signUpToast(errorMsg);
          }

          // 데이터 통신 전 로딩 상태 변경
          setState(() {
            isLoading = true;
          });

          var res;
          var images = [];
          Map<String, dynamic> requestData = {};
          for (int i = 0; i < _pickedImages.length; i++) {
            images.add(
              await MultipartFile.fromFile(
                _pickedImages[i].path,
                filename: basename(_pickedImages[i].path),
              ),
            );
          }

          var dataSource = {
            "title": title,
            "category": category,
            "address": locationTextController.text,
            "lat": currentLatLng?.latitude,
            "lng": currentLatLng?.longitude,
          };

          requestData["postData"] = json.encode(dataSource);
          requestData["images"] = images;

          res = await boardCon.postSubmit(requestData);
          setState(() {
            isLoading = false;
          });
          if (res) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  // 썸네일 이미지
  Widget _thumbPhoto() {
    return Expanded(
      flex: 2,
      child: _pickedImages.isNotEmpty
          ? Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5.0),
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_pickedImages.first.path)),
                  fit: BoxFit.cover,
                ),
              ),
              child: ClipRRect(
                // make sure we apply clip it properly
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.2),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color:
                                Colors.black, // Choose the color of the shadow
                            blurRadius:
                                5.0, // Adjust the blur radius for the shadow effect
                            offset: Offset(1.0,
                                1.0), // Set the horizontal and vertical offset for the shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5.0),
              height: 1,
              width: double.infinity,
              child: InkWell(
                child: ClipRRect(
                  // make sure we apply clip it properly
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.2),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 50,
                            color: Colors.grey,
                          ),
                          Text(
                            "사진추가",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  getMultiImage();
                },
              )),
    );
  }

  // 불러온 이미지 gridView
  Widget _gridPhoto() {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: _pickedImages.isNotEmpty
          ? GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1,
              children: _pickedImages.asMap().entries.map((entry) {
                int idx = entry.key;
                XFile? image = entry.value;

                return image != null
                    ? _gridPhotoItem(XFile(image.path), idx)
                    : const Text('No image');
              }).toList(),
            )
          : const SizedBox(),
    );
  }

  // 인풋 작성 폼 리스트 위젯
  Widget _FormWidget() {
    return Expanded(
      flex: 2,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: renderTextFormField(
                      label: '제목',
                      hintText: "음식점이름, 커스텀",
                      controller: titleTextController,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),

                    // dropdown below..
                    child: DropdownButton<String>(
                      value: category,
                      onChanged: (dynamic value) {
                        setState(() {
                          category = value;
                        });
                      },
                      items: dropdownList
                          .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                          .toList(),

                      // add extra sugar..
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 42,
                      underline: const SizedBox(),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              renderTextFormField(
                hintText: "지번, 도로명, 건물명으로 검색",
                controller: locationTextController,
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: const SelectMapPositionScreen()),
                  ).then((value) {
                    print("Navigator.push!!!");
                    print(value);
                  });
                },
              ),
              // 위치 검색 위젯
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.gps_fixed_sharp,
                            size: 15,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            '주소 검색으로 위치 설정',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.normal,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 15,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  onTap: () async {
                    Kpostal? result = await Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: KpostalView(
                          callback: (Kpostal result) {},
                          useLocalServer: false,
                          kakaoKey: '2313aec57928c855c20fa695fe0480d2',
                        ),
                      ),
                    );
                    print("!!! $result");

                    if (result != null) {
                      _updateSearchAddress(
                        result.address,
                        result.latitude,
                        result.longitude,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 주소 검색 업데이트 함수
  void _updateSearchAddress(String address, latitude, longitude) {
    setState(() {
      currentLatLng = NLatLng(latitude, longitude);
      locationTextController.text = address;
    });
  }

// 스토리 작성 인풋 컨포넌트 위젯
  renderTextFormField(
      {final String label = "",
      final controller,
      final focusNode,
      required hintText,
      readOnly = false,
      Function()? onTap}) {
    return Column(
      children: [
        Row(
          children: [
            label.isNotEmpty
                ? Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
              fillColor: Colors.transparent,
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[500])),
        )
      ],
    );
  }

  // gridView 이미지 박스 아이템 컴포넌트
  Widget _gridPhotoItem(XFile e, int idx) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(e.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _pickedImages.removeAt(idx);
                  });
                },
                child: Icon(Icons.cancel_rounded,
                    color: AppColors().semiGrey, size: 19),
              ),
            )
          ],
        ));
  }
}
