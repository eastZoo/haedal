import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:haedal/routes/app_pages.dart';
import 'package:haedal/screens/main_screen.dart';
import 'package:haedal/screens/select_map_position_screen.dart';
import 'package:haedal/styles/colors.dart';
import 'package:haedal/widgets/app_button.dart';
import 'package:haedal/widgets/custom_appbar.dart';
import 'package:haedal/widgets/main_appbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class AddimageScreen extends StatefulWidget {
  const AddimageScreen({super.key});

  @override
  State<AddimageScreen> createState() => _AddimageScreenState();
}

class _AddimageScreenState extends State<AddimageScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _pickedImages = [];

  final formKey = GlobalKey<FormState>();

  String title = '';
  String address = '';
  NLatLng? currentLatLng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMultiImage();
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppbar(
              title: "스토리 작성",
              actions: _addBtn(),
            ),
            _FormWidget(),
            _thumbPhoto(),
            _gridPhoto(),
          ],
        ),
      ),
    );
  }

  // 위치 등록시 ( 이미지 or 글만 등록 선택 모달 )
  void _SelectPositionPopScreen() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.95,
          maxChildSize: 0.95,
          minChildSize: 0.90,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return const SelectMapPositionScreen();
          }),
    );
  }

  Widget _FormWidget() {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            renderTextFormField(
              label: '제목',
              onSaved: (val) {},
              validator: (val) {
                if (val.length < 1) {
                  return 'title은 필수사항입니다.';
                }
                if (val.length < 2) {
                  return 'title은 두글자 이상 입력 해주셔야합니다.';
                }
                return null;
              },
            ),
            renderTextFormField(
                label: '위치',
                onSaved: (val) {},
                validator: (val) {
                  if (val.length < 1) {
                    return '위치는 필수사항입니다.';
                  }

                  return null;
                },
                onTap: () {
                  _SelectPositionPopScreen();
                }),
          ],
        ),
      ),
    );
  }

  renderTextFormField(
      {required String label,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      Function()? onTap}) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          onTap: onTap,
        ),
      ],
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
        onTap: () {},
      ),
    );
  }

  // 썸네일 이미지
  Widget _thumbPhoto() {
    return Expanded(
      child: _pickedImages.isNotEmpty
          ? Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5.0),
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(File(_pickedImages.first!.path)),
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
                    child: const Text(
                      "title",
                      style: TextStyle(
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
          : const SizedBox(),
    );
  }

  // 불러온 이미지 gridView
  Widget _gridPhoto() {
    return Expanded(
      child: _pickedImages.isNotEmpty
          ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
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
                child: Icon(
                  Icons.cancel_rounded,
                  color: AppColors().semiGrey,
                ),
              ),
            )
          ],
        ));
  }
}
