import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:haedal/screens/select_map_position_screen.dart';
import 'package:haedal/service/controller/board_controller.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/utils/toast.dart';
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

// title focus, scroll event
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final titleTextController = TextEditingController();
  final locationTextController = TextEditingController();
  final contentTextController = TextEditingController();
  // 스토리 작성 날짜
  final storyDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  List<String> dropdownList = ['음식점', '장소', '플레이', '카페', '숙소'];
  String category = '음식점';

  String errorMsg = "";

  // 스토리 저장 시 전송 dataSource
  String title = '';

  NLatLng? currentLatLng;
  final List<XFile> _pickedImages = [];
  DateTime selectedDate = DateTime.now();

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
    setState(() {
      storyDateController.text = "${DateTime.now().toLocal()}".split(".")[0];
    });
  }

  @override
  void dispose() {
    titleTextController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 제목 텍스트 누를때 스크롤 젤위로s
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        print("SCROLL!!");
        // Scroll to the bottom when the text field is focused
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // 이미지 여러개 불러오기
  void getMultiImage() async {
    setState(() {
      isLoading = true;
    });
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isEmpty && _pickedImages.isEmpty) {
      return Navigator.pop(context, false);
    }

    setState(() {
      _pickedImages.addAll(images);
    });

    setState(() {
      isLoading = false;
    });
  }

  // 스토리 해당 날짜
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        controller.text = "${picked.toLocal()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "스토리 작성",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Color(0xFF676B85),
          ),
        ),
        centerTitle: true,
        actions: [_addBtn()],
      ),
      body: isLoading
          ? Center(
              //로딩바 구현 부분
              child: SpinKitFadingCube(
                // FadingCube 모양 사용
                color: AppColors().mainColor, // 색상 설정
                size: 50.0, // 크기 설정
                duration: const Duration(seconds: 2), //속도 설정
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // 고른 사진 중 첫번째 사진 썸네일
                    _thumbPhoto(),
                    _pickedImages.isNotEmpty ? _gridPhoto() : const SizedBox(),
                    const Gap(20),
                    _FormWidget()
                  ],
                ),
              ),
            ),
    );
  }

  // 앱바 게시 버튼
  Widget _addBtn() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
        child: Text(
          "게시",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors().mainColor,
            height: 4,
          ),
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
          "lat": currentLatLng == null ? 0 : currentLatLng?.latitude,
          "lng": currentLatLng == null ? 0 : currentLatLng?.longitude,
          "content": contentTextController.text,
          "storyDate": storyDateController.text
        };

        requestData["postData"] = json.encode(dataSource);
        requestData["images"] = images;

        res = await boardCon.postSubmit(requestData);
        setState(() {
          isLoading = false;
        });
        if (res) {
          Navigator.pop(context, res);
        }
      },
    );
  }

  // 썸네일 이미지
  Widget _thumbPhoto() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: _pickedImages.isNotEmpty
          ? Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5.0),
              height: width / 1.5,
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
              height: width / 1.5,
              width: double.infinity,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
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
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: width / 3,
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
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.65,
                child: renderTextFormField(
                    label: '제목',
                    hintText: "음식점이름, 커스텀",
                    controller: titleTextController,
                    focusNode: _focusNode),
              ),
              Container(
                width: width * 0.3 - 10,
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
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                if (value == null) {
                } else {
                  _updateSearchAddress(
                      value["address"], value["lat"], value["lng"]);
                }
              });
            },
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
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
          const SizedBox(height: 12),
          renderTextFormField(
            label: '메모',
            hintText: "메모",
            multiLine: true,
            controller: contentTextController,
          ),
          const SizedBox(height: 12),
          renderTextFormField(
            label: '스토리 날짜 (미선택 시 현재 날짜 자동 저장)',
            hintText: "선택하지 않으면 오늘날짜로 자동 저장됩니다.",
            controller: storyDateController,
            readOnly: true,
            onTap: () {
              _selectDate(context, storyDateController);
            },
          ),
          const SizedBox(height: 24),
        ],
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
      final multiLine = false,
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
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
        multiLine
            ? Container(
                margin: const EdgeInsets.all(12),
                height: 5 * 24.0,
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  onTap: onTap,
                  maxLines: multiLine ? 5 : 1,
                  decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      hintText: hintText,
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
              )
            : TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: readOnly,
                onTap: onTap,
                maxLines: multiLine ? null : 1,
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
      ),
    );
  }
}
